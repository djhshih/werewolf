import 'dart:math';

import 'src/controller.dart';
import 'src/generated/werewolf.pbenum.dart';


enum Team { Independent, Villager, Werewolf }

class Character {
  int index;
  Team team = Team.Independent;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    return;
  }
  
  bool validTargets(List<int> targets, Characters cs) => targets.isEmpty;
  
  Character make() => new Character();
  Role get role => Role.UNKNOWN;
}

class Villager extends Character {
  Team team = Team.Villager;
  
  Villager make() => new Villager();
  Role get role => Role.VILLAGER;
}

class Werewolf extends Character {
  Team team = Team.Werewolf;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    List<int> xs = cs.find(this);
    addRevelations(xs, cs, revelations);
    
    print('DEBUG: Player $index (${this}) sees other werewolfs.');
    print(' INFO: Player $index sees players $xs awake.');
  }

  Werewolf make() => new Werewolf();
  Role get role => Role.WEREWOLF;
}

class Seer extends Character {
  Team team = Team.Villager;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    addRevelations(targets, cs, revelations);

    print('DEUBG: Player $index (${this}) sees two unclaimed cards OR another player\'s card.');
    for (int i in targets) {
      print(' INFO: Player $index sees ${cs.character(i)}.');
    }
  }
  
  bool validTargets(List<int> targets, Characters cs) {
    if (targets.length == 1) {
      return targets[0] != index && cs.validPlayer(targets[0]);
    }
    // otherwise, all targets must be unclaimed cards
    return targets.every(cs.validUnclaimed);
  }
   
  Seer make() => new Seer();
  Role get role => Role.SEER;
}

class Robber extends Character {
  Team team = Team.Villager;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    int i = targets[0];
    cs.swap(index, i);
    revelations[index] = cs.character(index);
    
    print('DEBUG: Player $index (${this}) swaps cards with another player ($i)');
    print(' INFO: Player $index sees ${cs.character(index)}.');
  }
  
  bool validTargets(List<int> targets, Characters cs) =>
    targets.length == 1 && cs.validPlayer(targets[0]);
  
  Robber make() => new Robber();
  Role get role => Role.ROBBER;
}

class Troublemaker extends Character {
  Team team = Team.Villager;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    cs.swap(targets[0], targets[1]);
    
    print('DEBUG: Player $index (${this}) swaps two other players\' cards (${targets[0]}, ${targets[1]}).');
  }
  
  bool validTargets(List<int> targets, Characters cs) =>
    targets.length == 2 && targets.every((t) => t != index && cs.validPlayer(t));
  
  Troublemaker make() => new Troublemaker();
  Role get role => Role.TROUBLEMAKER;
}

class Tanner extends Character {
  Tanner make() => new Tanner();
  Role get role => Role.TANNER;
}

class Drunk extends Character {
  Team team = Team.Villager;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    int i = targets[0];
    cs.swap(index, i);
    
    print('DEBUG: Player $index (${this}) swaps own card with an unclaimed card ($i).');
  } 
  
  bool validTargets(List<int> targets, Characters cs) =>
    targets.length == 1 && cs.validUnclaimed(targets[0]);
  
  Drunk make() => new Drunk();
  Role get role => Role.DRUNK;
}

class Hunter extends Character {
  Team team = Team.Villager;
  
  Hunter make() => new Hunter();
  Role get role => Role.HUNTER;
}

class Mason extends Character {
  Team team = Team.Villager;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    List<int> xs = cs.find(this);
    addRevelations(xs, cs, revelations);
    
    print('DEBUG: Player $index (${this}) sees other masons.');
    print(' INFO: Player $index sees players $xs awake.');
  } 
  
  Mason make() => new Mason(); 
  Role get role => Role.MASON;
}

class Insomniac extends Character {
  Team team = Team.Villager;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    revelations[index] = cs.character(index);
    
    print('DEBUG: Player $index (${this}) sees own card.');
    print(' INFO: Player $index sees ${cs.character(index)}.');
  } 
  
  Insomniac make() => new Insomniac();
  Role get role => Role.INSOMNIAC;
}

class Minion extends Character {
  Team team = Team.Werewolf;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    List<int> xs = cs.find(new Werewolf());
    addRevelations(xs, cs, revelations);

    print('DEBUG: Player $index (${this}) sees the werewolves.');
    print(' INFO: Player $index sees that players $xs are werewolves.');
  } 
  
  Minion make() => new Minion();
  Role get role => Role.MINION;
}

class Doppelganger extends Character {
  // NB  To allow Doppelganger to take the action of the new role,
  //     this function needs to modify the original list!
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    int i = targets[0];
    Character c = cs.character(i).make();
    c.index = index;
    cs.characters[index] = c;
    revelations[index] = cs.character(index);
    
    print('DEBUG: Player $index (${this}) clones player\'s card ($i).');
    print(' INFO: Player $index becomes ${cs.character(index)}.');
  } 
  
  bool validTargets(List<int> targets, Characters cs) =>
    targets.length == 1 && cs.validPlayer(targets[0]);
  
  Doppelganger make() => new Doppelganger();
  Role get role => Role.DOPPELGANGER;
}

class Characters {
  int nPlayers;
  List<Character> characters;

  Characters(this.nPlayers, this.characters);

  int get nWolves =>
    characters.where((c) => c is Werewolf).length;
  
  void shuffle(Random r) {
    characters.shuffle(r);
    assign();
  }

  // Assign index to each character.
  void assign() {
    int i = 0;
    for (Character c in characters) {
      c.index = i;
      i++;
    }
  }
  
  void swap(int i, int j) {
    Character t = characters[j];
    characters[j] = characters[i];
    characters[i] = t;
  }

  Character character(int i) {
    return characters[i];
  }
  
  Character unclaimed(int i) {
    return characters[nPlayers + i];
  }

  // Wake up players with a matching character and
  // allow them to perform their actions
  void wake(Character m, Characters cs, List<List<int>> targetSets, List<Map<int, Character>> revelationSets) {
    for (int i = 0; i < nPlayers; i++) {
      Character x = characters[i];
      if (x.runtimeType == m.runtimeType) {
        List<int> targets;
        if (targetSets[i].isNotEmpty && x.validTargets(targetSets[i], cs)) {
          targets = targetSets[i];
        } else {
          Controller controller = makeController(x);
          targets = controller.choose(cs);
        }
        x.act(targets, cs, revelationSets[i]);
      }
    }
  }
  
  // Find index of characters matching a given character.
  List<int> find(Character m) {
    List<int> xs = new List();
    for (int i = 0; i < nPlayers; i++) {
      if (characters[i].runtimeType == m.runtimeType) {
        xs.add(i);
      }
    } 
    return xs;
  }
  
  bool validPlayer(int i) =>  i >= 0 && i < nPlayers;
  bool validUnclaimed(int i) =>  i >= nPlayers && i < characters.length;
  bool validCard(int i) => i >= 0 && i < characters.length;

  Iterable<String> toStrings() =>
    characters.map((c) => c.runtimeType.toString());
}

void addRevelations(List<int> xs, Characters cs, Map<int, Character> revelations) {
  for (int i in xs) {
    revelations[i] = cs.character(i);
  }
}
