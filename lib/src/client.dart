import 'package:grpc/grpc.dart';

import 'generated/werewolf.pb.dart';
import 'generated/werewolf.pbgrpc.dart';

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
    
    // TODO implement client
    
    await channel.shutdown();
  }
}