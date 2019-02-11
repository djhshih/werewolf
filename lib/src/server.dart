import 'dart:math';

import 'package:werewolf/game.dart';
import 'package:werewolf/character.dart';

import 'package:grpc/grpc.dart' as grpc;

import 'generated/werewolf.pb.dart';
import 'generated/werewolf.pbenum.dart';
import 'generated/werewolf.pbgrpc.dart';

class WerewolfService extends WerewolfServiceBase {
  Game game;
  List<Character> cards;
  
  WerewolfService(this.cards);
  
  void init() {
    Random r = new Random();
    game = new Game(new Characters(11, cards));
    game.init(r);
    game.reveal(game.originals);
  }
  
  // TODO Fix this ugly switch
  Role mapCharacterToRole(Character c) {
    switch (c.runtimeType) {
      case Villager:
        return Role.VILLAGER;
      case Werewolf:
        return Role.WEREWOLF;
      case Seer:
        return Role.SEER;
      case Robber:
        return Role.ROBBER;
      case Troublemaker:
        return Role.TROUBLEMAKER;
      case Tanner:
        return Role.TANNER;
      case Drunk:
        return Role.DRUNK;
      case Hunter:
        return Role.HUNTER;
      case Mason:
        return Role.MASON;
      case Insomniac:
        return Role.INSOMNIAC;
      case Minion:
        return Role.MINION;
      case Doppelganger:
        return Role.DOPPELGANGER;
    }
    return Role.UNKNOWN;
  }

  // TODO Implement server register
  Future<Slot> register(grpc.ServiceCall call, Slot request) async {
    return request;
  }

  Future<Effect> act(grpc.ServiceCall call, Action request) async {
    if (game.phase != GamePhase.Night) {
      print('ERROR: Cannot act in ${game.phase}');
      return new Effect()..status = Status.ERROR;
    }
    
    int player = request.player; 
    if (!game.validPlayer(player)) {
      return new Effect()..status = Status.INVALID;
    }
    
    // record the player's chosen targets
    game.targetSets[player] = request.targets;
    // mark player as ready 
    game.setReady(player);

    // wait until game deems night phase is complete
    await game.waitForPhase(GamePhase.Day);
    
    Effect effect = new Effect();
    List revelations = game.revelationSets[player];
    for (var i in revelations) {
      effect.revelations.add(
        new Effect_Revelation()
          ..player = i
          ..role = mapCharacterToRole(game.finals.character(i))
      );
    }
    
    return effect;
  }
  
  Future<Verdict> vote(grpc.ServiceCall call, Ballot request) async {
    if (game.phase != GamePhase.Day) {
      print('ERROR: Cannot vote in ${game.phase}');
      return new Verdict()..status = Status.ERROR;
    }
    
    Verdict verdict = new Verdict(); 
  
    if (!game.castVote(request.player, request.target)) {
      verdict.status = Status.INVALID;
    }
    // mark player as ready 
    game.setReady(request.player);
    
    // wait until game deems day phase is complete
    await game.waitForPhase(GamePhase.Finale);
    
    verdict
      ..votes.addAll(game.votes)
      ..winners.addAll(game.winners)
      ..deads.addAll(game.deads)
      ..roles.addAll( game.finals.characters.map(mapCharacterToRole) );
    
    return verdict;
  }
}

class Server {
  Future<void> main(List<String> args) async {
    List<Character> cards = [
      new Villager(),
      new Werewolf(),
      new Werewolf(),
      new Seer(),
      new Robber(),
      new Troublemaker(),
      new Tanner(),
      new Drunk(),
      new Hunter(),
      new Mason(),
      new Mason(),
      new Insomniac(),
      new Minion(),
      new Doppelganger(),
    ];
    final service = new WerewolfService(cards);
    service.init();
    
    final server = new grpc.Server([service]);
    await server.serve(port: 8888);
    print('Server listening on port ${server.port}...');
  }
}