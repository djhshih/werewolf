import 'package:grpc/grpc.dart';

import 'generated/werewolf.pb.dart';
import 'generated/werewolf.pbgrpc.dart';

import 'dart:io';

class Client {
  ClientChannel channel;
  WerewolfClient stub;

  Future<void> main(List<String> args) async {
    channel = new ClientChannel('127.0.0.1',
      port: 8888,
      options: const ChannelOptions(
        credentials: const ChannelCredentials.insecure()
      )
    );
    
    stub = new WerewolfClient(channel,
      options: new CallOptions(timeout: new Duration(seconds: 30))
    );
    
    Slot slot = await stub.register(new Identification());
    int player = slot.player;
    int key = slot.key;
    print('INFO: Server assigned player id ${player} and card ${slot.role}');
    
    Effect effect;
    do {
      stdout.write('Targets: ');
      var input = stdin.readLineSync();
      var targets;
      if (input.isNotEmpty) {
        targets = input.split(' ').map(int.parse);
      } else {
        targets = <int>[];
      }
      Action action = new Action()
        ..player = player
        ..key = key
        ..targets.addAll(targets);
      print('Action: ${action}');
      
      effect = await stub.act(action);
      while (effect.status == Status.WAIT) {
        effect = await Future.delayed(Duration(seconds: 1), () => stub.act(action));
      }
    } while (effect.status == Status.INVALID);
    
    print('Status: ${effect.status}');
    print('Relevations: ${effect.revelations}');
    
    Verdict verdict;
    do {

      int target = -1;
      do {
        stdout.write('Vote: ');
        try {
          target = int.parse(stdin.readLineSync());
        } catch (_) {}
      } while (target < 0);
      
      Ballot ballot = new Ballot()
        ..player = player
        ..key = key
        ..target = target;
        
      verdict = await stub.vote(ballot);
      while (verdict.status == Status.WAIT) {
        verdict = await Future.delayed(Duration(seconds: 1), () => stub.vote(ballot));
      }
    } while (verdict.status == Status.INVALID);
    
    print('Status: ${verdict.status}');
    print('Votes: ${verdict.votes}');
    print('Winners: ${verdict.winners}');
    print('Deads: ${verdict.deads}');
    print('Roles: ${verdict.roles}');
    
    await channel.shutdown();
  }
}