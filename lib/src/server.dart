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
  
  Map<int, int> keys = {};
  
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

  Future<Slot> register(grpc.ServiceCall call, Identification request) async {
    Slot response = new Slot();
    
    if (game.phase != GamePhase.Night) {
      return response..status = Status.WAIT;
    }
  
    // Assign a secret key that the requester needs to subsequent interactions
    print('DEBUG: playables: ${game.playables}');
    if (request.key == 0) {
      // Assign player to next available id
      for (int i = 0; i < game.playables.length; i++) {
        if (!game.playables[i]) {
          print('DEBUG: Found available player slot: $i');
          // register player
          response.player = i;
          game.playables[i] = true;
          game.ready[i] = false;
          // register key
          Random r = new Random();
          // key value of 0 is reserved
          response.key = r.nextInt((1 << 32) - 1) + 1;
          keys[i] = response.key;
          print(' INFO: Player ${response.player} joins the game.');
          break;
        }
      }
      if (response.key == 0) {
        // no player slot available
        print(' INFO: Game is full. New player could not join.');
      }
    } else {
      // check if key matches
      int player = request.player;
      int key = request.key;
      if (checkKey(player, key)) {
        // re-register player
        game.playables[player] = true;
        game.ready[player] = false;
        response.player = player;
        response.key = key;
        print(' INFO: Player ${response.player} re-joins the game.');
      } else {
        return response..status = Status.INVALID;
      }
    }
    print('DEBUG: game.ready: ${game.ready}');
    
    response.role = mapCharacterToRole(game.originals.character(response.player));
    
    return response;
  }
  
  bool checkKey(int player, int key) {
    return keys.containsKey(player) && keys[player] == key;
  }

  Future<Effect> act(grpc.ServiceCall call, Action request) async {
    int player = request.player; 
    Effect effect = new Effect();
    
    if (!game.validPlayer(player)) {
      return effect..status = Status.INVALID;
    }
    
    if (!checkKey(player, request.key)) {
      return effect..status = Status.ERROR;
    }
    
    if (game.phase == GamePhase.Night && !game.ready[player]) {
      if (request.targets.every(game.validPlayer)) {
        // record the player's chosen targets
        game.targetSets[player] = request.targets;
        // mark player as ready 
        game.setReady(player);
        // wait to allow game phase to change
        await Future.delayed(Duration(seconds: 1));
      } else {
        return effect..status = Status.INVALID;
      }
    }

    if (game.phase == GamePhase.Night) {
      print(' INFO: Instructing player ${player} to Wait for game phase to change to Day');
      effect.status = Status.WAIT;
    } else {
      List revelations = game.revelationSets[player];
      for (var i in revelations) {
        effect.revelations.add(
          new Effect_Revelation()
            ..player = i
            ..role = mapCharacterToRole(game.finals.character(i))
        );
      }
    }
    
    return effect;
  }
  
  Future<Verdict> vote(grpc.ServiceCall call, Ballot request) async {
    Verdict verdict = new Verdict(); 
    int player = request.player;
    
    if (!game.validPlayer(player)) {
      return verdict..status = Status.INVALID;
    }
    
    if (!checkKey(player, request.key)) {
      return verdict..status = Status.ERROR;
    }
  
    if (game.phase == GamePhase.Day && !game.ready[player]) {
      if (game.castVote(player, request.target)) {
        // mark player as ready 
        game.setReady(player);
        // wait to allow game phase to change
        await Future.delayed(Duration(seconds: 1));
      } else {
        return verdict..status = Status.INVALID;
      }
    }
    
    if (game.phase == GamePhase.Day) {
      print(' INFO: Instructing player ${player} for game phase to change to Finale');
      return verdict..status = Status.WAIT;
    } else {
      verdict
        ..votes.addAll(game.votes)
        ..winners.addAll(game.winners)
        ..deads.addAll(game.deads)
        ..roles.addAll( game.finals.characters.map(mapCharacterToRole) );
    }
    
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