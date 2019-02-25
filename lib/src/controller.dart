import 'dart:math';

import 'package:werewolf/character.dart';

class Controller {
  Random _random = Random();
  Character character;

  factory Controller(Character c) {
    switch (c.runtimeType) {
      case Seer:
        return SeerController(c);
      case Robber:
        return RobberController(c);
      case Troublemaker:
        return TroublemakerController(c);
      case Drunk:
        return DrunkController(c);
      case Doppelganger:
        return DoppelgangerController(c);
      default:
        return Controller._internal(c);
    }
  }
  
  Controller._internal(this.character);
  
  List<int> choose(Characters cs) => const [];
}

class SeerController extends Controller {
  SeerController(Character c): super._internal(c);
  List<int> choose(Characters cs) {
    if (_random.nextBool()) {
      // randomly choose another player
      return [chooseOtherPlayer(cs, character.index, _random)];
    }
    // randomly choose two unclaimed cards
    return chooseTwoUnclaimed(cs, _random);
  }
}

class RobberController extends Controller {
  RobberController(Character c): super._internal(c);
  List<int> choose(Characters cs) =>
    [chooseOtherPlayer(cs, character.index, _random)];
}

class TroublemakerController extends Controller {
  TroublemakerController(Character c): super._internal(c);
  List<int> choose(Characters cs) =>
    chooseTwoOtherPlayers(cs, character.index, _random);
}

class DrunkController extends Controller {
  DrunkController(Character c): super._internal(c);
  List<int> choose(Characters cs) =>
    [chooseUnclaimed(cs, _random)];
}

class DoppelgangerController extends Controller {
  DoppelgangerController(Character c): super._internal(c);
  List<int> choose(Characters cs) =>
    [chooseOtherPlayer(cs, character.index, _random)];
}


int chooseRandomly(int n, Random r) {
    Random r = new Random();
    return r.nextInt(n);
}

int chooseOtherPlayer(Characters cs, int index, Random r) {
  int i = 0;
  do {
    i = chooseRandomly(cs.nPlayers, r);
  } while (i == index);
  
  return i;
}

List<int> chooseTwoOtherPlayers(Characters cs, int index, Random r) {
  List<int> xs = new List(2);
  do {
    xs[0] = chooseRandomly(cs.nPlayers, r);
  } while (xs[0] == index);
  do {
    xs[1] = chooseRandomly(cs.nPlayers, r);
  } while (xs[1] == index || xs[1] == xs[0]);
  
  return xs;
}

int chooseUnclaimed(Characters cs, Random r) {
  return chooseRandomly(cs.characters.length - cs.nPlayers, r) + cs.nPlayers;
}

List<int> chooseTwoUnclaimed(Characters cs, Random r) {
  List<int> xs = new List(2);
  xs[0] = chooseRandomly(cs.characters.length - cs.nPlayers, r) + cs.nPlayers;
  do {
    xs[1] = chooseRandomly(cs.characters.length - cs.nPlayers, r) + cs.nPlayers;
  } while (xs[0] == xs[1]);
  
  return xs;
}
