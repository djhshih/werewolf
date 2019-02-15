import 'dart:math';

int chooseRandomly(int n) {
    Random r = new Random();
    return r.nextInt(n);
}

int chooseOtherPlayer(Characters cs, int index) {
  int i = 0;
  do {
    i = chooseRandomly(cs.nPlayers);
  } while (i == index);
  
  return i;
}

List<int> chooseTwoOtherPlayers(Characters cs, int index) {
  List<int> xs = new List(2);
  do {
    xs[0] = chooseRandomly(cs.nPlayers);
  } while (xs[0] == index);
  do {
    xs[1] = chooseRandomly(cs.nPlayers);
  } while (xs[1] == index || xs[1] == xs[0]);
  
  return xs;
}

int chooseUnclaimed(Characters cs) {
  return chooseRandomly(cs.characters.length - cs.nPlayers) + cs.nPlayers;
}

List<int> chooseTwoUnclaimed(Characters cs) {
  List<int> xs = new List(2);
  xs[0] = chooseRandomly(cs.characters.length - cs.nPlayers) + cs.nPlayers;
  do {
    xs[1] = chooseRandomly(cs.characters.length - cs.nPlayers) + cs.nPlayers;
  } while (xs[0] == xs[1]);
  
  return xs;
}


enum Team { Independent, Villager, Werewolf }

class Character {
  int index;
  Team team = Team.Independent;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    return;
  }
  
  void actRandomly(Characters cs, Map<int, Character> revelations) => act([], cs, revelations);
  
  Character make() => new Character();
}

class Villager extends Character {
  Team team = Team.Villager;
  
  Villager make() => new Villager();
}

void addRevelations(List<int> xs, Characters cs, Map<int, Character> revelations) {
  for (int i in xs) {
    revelations[i] = cs.character(i);
  }
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
  
  void actRandomly(Characters cs, Map<int, Character> revelations) {
    Random r = new Random();
    List<int> targets;
    if (r.nextBool()) {
      // randomly choose another player
      targets = [chooseOtherPlayer(cs, index)];
    } else {
      // randomly choose two unclaimed cards
      targets = chooseTwoUnclaimed(cs);
    }
    act(targets, cs, revelations);
  }
   
  Seer make() => new Seer();
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
  
  void actRandomly(Characters cs, Map<int, Character> revelations) {
    act([chooseOtherPlayer(cs, index)], cs, revelations);
  }
  
  Robber make() => new Robber();
}

class Troublemaker extends Character {
  Team team = Team.Villager;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    cs.swap(targets[0], targets[1]);
    
    print('DEBUG: Player $index (${this}) swaps two other players\' cards (${targets[0]}, ${targets[1]}).');
  }

  void actRandomly(Characters cs, Map<int, Character> revelations) {
    act(chooseTwoOtherPlayers(cs, index), cs, revelations);  
  }
  
  Troublemaker make() => new Troublemaker();
}

class Tanner extends Character {
  Tanner make() => new Tanner();
}

class Drunk extends Character {
  Team team = Team.Villager;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    int i = targets[0];
    cs.swap(index, i);
    
    print('DEBUG: Player $index (${this}) swaps own card with an unclaimed card ($i).');
  } 
  
  void actRandomly(Characters cs, Map<int, Character> revelations) {
    act([chooseUnclaimed(cs)], cs, revelations);  
  }
  
  Drunk make() => new Drunk();
}

class Hunter extends Character {
  Team team = Team.Villager;
  
  Hunter make() => new Hunter();
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
}

class Insomniac extends Character {
  Team team = Team.Villager;
  
  void act(List<int> targets, Characters cs, Map<int, Character> revelations) {
    revelations[index] = cs.character(index);
    
    print('DEBUG: Player $index (${this}) sees own card.');
    print(' INFO: Player $index sees ${cs.character(index)}.');
  } 
  
  Insomniac make() => new Insomniac();
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
  
  void actRandomly(Characters cs, Map<int, Character> revelations) {
    act([chooseOtherPlayer(cs, index)], cs, revelations);
  }
  
  Doppelganger make() => new Doppelganger();
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
        if (targetSets[i].isNotEmpty) {
          x.act(targetSets[i], cs, revelationSets[i]);
        } else {
          x.actRandomly(cs, revelationSets[i]);
        }
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

  Iterable<String> toStrings() =>
    characters.map((c) => c.runtimeType.toString());
}