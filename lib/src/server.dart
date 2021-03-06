import 'dart:math';

import 'package:werewolf/game.dart';
import 'package:werewolf/character.dart';

import 'package:grpc/grpc.dart' as grpc;

import 'generated/werewolf.pb.dart';
import 'generated/werewolf.pbenum.dart';
import 'generated/werewolf.pbgrpc.dart';

// TODO Let game continue for multiple rounds

class WerewolfService extends WerewolfServiceBase {
  Game game;
  List<Character> cards;
  
  WerewolfService(this.cards);
  
  // each playable character's secret key (for identity verification)
  Map<int, int> keys = {};
  
  // whether each character is a playable character or non-playable character
  List<bool> playables;

  // each player's ready status;
  List<bool> ready;
  
  void init() {
    game = new Game(new Characters(11, cards), new Random());
    game.init();
    game.reveal(game.originals);
    
    playables = new List.filled(game.originals.nPlayers, false);
    resetReady();
  }
  
    // Reset ready statuses of players.
  void resetReady() {
    // non-playable characters are ready by default
    ready = playables.map((playable) => !playable).toList();
  }
  
  // Set player as ready and advance if everyone is ready.
  void setReady(int player) {
    if (!game.validPlayer(player)) return;
    ready[player] = true;
    if (ready.every((b) => b)) {
      game.advance();
      resetReady();
    } else {
      print('DEBUG: ready: ${ready}');
    }
  }
  
  Future<Slot> register(grpc.ServiceCall call, Identification request) async {
    Slot response = new Slot();
    
    if (game.phase != GamePhase.Night) {
      return response..status = Status.WAIT;
    }
  
    // Assign a secret key that the requester needs to subsequent interactions
    if (request.key == 0) {
      // Assign player to next available id
      for (int i = 0; i < playables.length; i++) {
        if (!playables[i]) {
          print('DEBUG: Found available player slot: $i');
          // register player
          response.player = i;
          playables[i] = true;
          ready[i] = false;
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
        playables[player] = true;
        ready[player] = false;
        response.player = player;
        response.key = key;
        print(' INFO: Player ${response.player} re-joins the game.');
      } else {
        return response..status = Status.INVALID;
      }
    }
    
    response.role = game.originals.character(response.player).role;
    
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
    
    if (game.phase == GamePhase.Night && !ready[player]) {
      if (game.originals.character(player).validTargets(request.targets, game.originals)) {
        // record the player's chosen targets
        game.players[player].targets = request.targets;
        // mark player as ready 
        setReady(player);
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
      var revelations = game.players[player].revelations;
      print('DEBUG: revelations: ${revelations}');
      for (var i in revelations.keys) {
        effect.revelations.add(
          new Effect_Revelation()
            ..player = i
            ..role = revelations[i].role
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
  
    if (game.phase == GamePhase.Day && !ready[player]) {
      if (game.castVote(player, request.target)) {
        // mark player as ready 
        setReady(player);
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
        ..votes.addAll(game.players.map((p) => p.vote))
        ..winners.addAll(game.winners)
        ..deads.addAll(game.deads)
        ..roles.addAll( game.finals.characters.map((x) => x.role) );
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