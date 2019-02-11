///
//  Generated code. Do not modify.
//  source: werewolf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart' as $grpc;
import 'werewolf.pb.dart';
export 'werewolf.pb.dart';

class WerewolfClient extends $grpc.Client {
  static final _$register = new $grpc.ClientMethod<Slot, Slot>(
      '/werewolf.Werewolf/Register',
      (Slot value) => value.writeToBuffer(),
      (List<int> value) => new Slot.fromBuffer(value));
  static final _$act = new $grpc.ClientMethod<Action, Effect>(
      '/werewolf.Werewolf/Act',
      (Action value) => value.writeToBuffer(),
      (List<int> value) => new Effect.fromBuffer(value));
  static final _$vote = new $grpc.ClientMethod<Ballot, Verdict>(
      '/werewolf.Werewolf/Vote',
      (Ballot value) => value.writeToBuffer(),
      (List<int> value) => new Verdict.fromBuffer(value));

  WerewolfClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<Slot> register(Slot request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$register, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Effect> act(Action request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$act, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Verdict> vote(Ballot request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$vote, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }
}

abstract class WerewolfServiceBase extends $grpc.Service {
  String get $name => 'werewolf.Werewolf';

  WerewolfServiceBase() {
    $addMethod(new $grpc.ServiceMethod<Slot, Slot>(
        'Register',
        register_Pre,
        false,
        false,
        (List<int> value) => new Slot.fromBuffer(value),
        (Slot value) => value.writeToBuffer()));
    $addMethod(new $grpc.ServiceMethod<Action, Effect>(
        'Act',
        act_Pre,
        false,
        false,
        (List<int> value) => new Action.fromBuffer(value),
        (Effect value) => value.writeToBuffer()));
    $addMethod(new $grpc.ServiceMethod<Ballot, Verdict>(
        'Vote',
        vote_Pre,
        false,
        false,
        (List<int> value) => new Ballot.fromBuffer(value),
        (Verdict value) => value.writeToBuffer()));
  }

  $async.Future<Slot> register_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return register(call, await request);
  }

  $async.Future<Effect> act_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return act(call, await request);
  }

  $async.Future<Verdict> vote_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return vote(call, await request);
  }

  $async.Future<Slot> register($grpc.ServiceCall call, Slot request);
  $async.Future<Effect> act($grpc.ServiceCall call, Action request);
  $async.Future<Verdict> vote($grpc.ServiceCall call, Ballot request);
}
