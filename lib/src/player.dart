import 'package:werewolf/character.dart';

class Player {
  List<int> targets = [];
  Map<int, Character> revelations = {};
  int vote = -1;
}
