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
    
    // TODO Generalize player id;
    int player = 0;
    
    stdout.write('Targets: ');
    var input = stdin.readLineSync();
    var targets = input.split(' ').map(int.parse);
    Action action = new Action()
      ..player = player
      ..targets.addAll(targets);
    print('Action: ${action}');
    Effect effect = await stub.act(action);
    
    print('Status: ${effect.status}');
    print('Relevations: ${effect.revelations}');
    
    stdout.write('Vote: ');
    int target = int.parse(stdin.readLineSync());
    Ballot ballot = new Ballot()
      ..player = player
      ..target = target;
      
    Verdict verdict = await stub.vote(ballot);
    
    print('Status: ${verdict.status}');
    print('Votes: ${verdict.votes}');
    print('Winners: ${verdict.winners}');
    print('Deads: ${verdict.deads}');
    print('Roles: ${verdict.roles}');
    
    await channel.shutdown();
  }
}