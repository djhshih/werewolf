import 'character.dart';

import 'dart:math';

class Game {
  Characters originals;
  Characters finals;
  
  Game(this.originals);
  
  void init(Random r) {
    originals.shuffle(r);
  }
  
  // Wake up players in order of their characters.
  void night() {
    originals.wake(new Doppelganger(), originals);
    
    // create a new copy of the characters to avoid characters'
    // actions to interfere during the night phase
    List<Character> finalCharacters = List.from(originals.characters);
    finals = new Characters(originals.nPlayers, finalCharacters);
    
    originals.wake(new Werewolf(), finals);
    originals.wake(new Minion(), finals);
    originals.wake(new Mason(), finals);
    originals.wake(new Seer(), finals);
    originals.wake(new Robber(), finals);
    originals.wake(new Troublemaker(), finals);
    originals.wake(new Drunk(), finals);
    originals.wake(new Insomniac(), finals);
  }
  
  // Reveal the characters.
  void reveal(Characters cs) {
    int i = 0;
    for (String x in cs.toStrings()) {
      if (i == 0) {
        print('Players: ');
      } else if (i == cs.nPlayers) {
        print('Unclaimed: ');
      }
      print('$i. $x');
      i++;
    }
  }
  
  // TODO Implement actual voting
  List<int> vote(Characters cs) {
    Random r = Random();
    List<int> votes = List(cs.nPlayers);
    for (int i = 0; i < cs.nPlayers; i++) {
      votes[i] = r.nextInt(cs.nPlayers); 
    }
    
    return lynch(votes);
  }
  
  // Lynch players with highest votes.
  List<int> lynch(List<int> votes) {
    int n = votes.length;
    
    // count the votes
    List<int> counts = new List.filled(n, 0); 
    for (int vote in votes) {
      counts[vote] += 1;
    }
    
    int maxCount = counts.reduce(max);
    
    List<int> dead = new List();
    const int minVotes = 2;
    // find all players with highest vote and at least two votes
    for (int i = 0; i < n; i++) {
      if (counts[i] == maxCount && counts[i] > minVotes) {
        dead.add(i);
      }
    }
    
    print(' INFO: Players ${dead} are lynched.');
    
    // TODO  Enforce rule that hunter also kills
    //       the player whom he/she votes for.
    
    return dead;
  }
  
  // Judge players who win.
  List<int> judge(Characters cs, List<int> dead) {
    for (int i in dead) {
      if (cs.character(i) is Tanner) {
        print(' INFO: Tanner ($i) wins.');
        // NB  Do not enforce the silly rule that
        //     werewolves lose when Tanner dies.
      } 
    }
  
    int nWolves = cs.nWolves;
    if (nWolves == 0) {
      if (dead.isEmpty) {
        print(' INFO: Villagers win.');
      } else {
        print(' INFO: Villagers lose.');
      }
    } else {
      bool atLeastOneWolfDied = false;
      for (int i in dead) {
        if (cs.character(i) is Werewolf) {
          atLeastOneWolfDied = true;
          break;
        }
      }
      if (atLeastOneWolfDied) {
        print(' INFO: Villagers win.');
        print(' INFO: Werewolves lose.');
      } else {
        print(' INFO: Villagers lose.');
        print(' INFO: Werewolves win.');
      }
    }
    
    // TODO return list of winners
    return new List();
  }
}

