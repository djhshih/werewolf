import 'dart:math';

import 'package:cli/game.dart';
import 'package:cli/character.dart';

main(List<String> arguments) {
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

  Random r = new Random();
  Game game = new Game(new Characters(11, cards));
  game.init(r);
  game.reveal(game.originals);
  game.night();
  game.reveal(game.finals);
  var dead = game.vote(game.finals);
  game.judge(game.finals, dead);
}
