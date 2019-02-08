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
    
    return lynch(cs, votes);
  }
  
  // Lynch players with highest votes.
  List<int> lynch(Characters cs, List<int> votes) {
    int n = votes.length;
    
    // count the votes
    List<int> counts = new List.filled(n, 0); 
    for (int vote in votes) {
      counts[vote] += 1;
    }

    print('DEBUG: Votes $counts');
    
    int maxCount = counts.reduce(max);
    
    List<int> deads = new List();
    const int minVotes = 2;
    // find all players with highest vote and at least two votes
    for (int i = 0; i < n; i++) {
      if (counts[i] == maxCount && counts[i] >= minVotes) {
        deads.add(i);
      }
    }
    
    // Kill characters that lynched hunters vote for.
    List<int> taken = new List();
    for (int i in deads) {
      if (cs.character(i) is Hunter) {
        print(' INFO: Hunter $i takes down player ${votes[i]}.');
        taken.add(votes[i]);
      }
    }
    // NB duplicate can occur here, but it is inconsequential
    deads.addAll(taken);
    
    print(' INFO: Players ${deads} are lynched.');
    
    return deads;
  }
  
  // Judge players who win.
  List<int> judge(Characters cs, List<int> deads) {
    List<int> winners = new List();
    
    bool villagersWin = false;
    bool wolvesWin = false;
  
    bool tannerDied = false;
    for (int i in deads) {
      if (cs.character(i) is Tanner) {
        // NB Only tanners that died wins.
        print(' INFO: Tanner ($i) wins.');
        winners.add(i);
        tannerDied = true;
      }
    }
  
    int nWolves = cs.nWolves;
    if (nWolves == 0) {
      if (deads.isEmpty) {
        print(' INFO: Villagers win.');
        villagersWin = true;
      } else {
        print(' INFO: Villagers lose.');
        // NB Alive minions win.
        for (int i in deads) {
          if (cs.character(i) is Minion) {
            winners.add(i);
            print(' INFO: Minion ($i) wins.');
          }
        }
      }
    } else {
      bool wolfDied = false;
      for (int i in deads) {
        if (cs.character(i) is Werewolf) {
          wolfDied = true;
          break;
        }
      }
      if (wolfDied) {
        print(' INFO: Villagers win.');
        villagersWin = true;
        print(' INFO: Werewolves lose.');
      } else {
        print(' INFO: Villagers lose.');
        if (tannerDied) {
          print(' INFO: Werewolves lose.');
        } else {
          print(' INFO: Werewolves win.');
          wolvesWin = true;
        }
      }
    }
    
    // find all winners
    if (villagersWin) {
      for (int i = 0; i < cs.nPlayers; i++) {
        if (cs.character(i).team == Team.Villager) {
          winners.add(i);
        }
      }
    }
    if (wolvesWin) {
      for (int i = 0; i < cs.nPlayers; i++) {
        if (cs.character(i).team == Team.Werewolf) {
          winners.add(i);
        }
      }
    }

    print(' INFO: Players $winners win.');
    
    return winners;
  }
}

