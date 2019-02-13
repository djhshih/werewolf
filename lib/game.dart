import 'character.dart';

import 'dart:math';

enum GamePhase {
  Initial, Night, Day, Finale
}

class Game {
  Characters originals;
  Characters finals;
  
  // each player's targets
  List<List<int>> targetSets;
  
  // each player's revelations
  List<List<int>> revelationSets;

  // each player's status
  List<bool> playables;

  List<bool> ready;
  List<int> votes;
  
  GamePhase phase = GamePhase.Initial;
  
  List<int> deads;
  List<int> winners;
  
  Game(this.originals);
  
  void init(Random r) {
    originals.shuffle(r);
    
    int nPlayers = originals.nPlayers;
    
    targetSets = new List.filled(nPlayers, []);
    revelationSets = new List.filled(nPlayers, []);
    playables = new List.filled(nPlayers, false);
    
    resetReady();
    
    votes = new List.filled(nPlayers, -1);
    
    phase = GamePhase.Night;
  }
  
  // Reset ready statuses of players.
  void resetReady() {
    // non-playable characters are ready by default
    ready = playables.map((playable) => !playable).toList();
  }
  
  bool validPlayer(int player) =>
    player >= 0 && player < originals.nPlayers;

  bool castVote(int player, int target) {
    if (validPlayer(player) && validPlayer(target)) {
      votes[player] = target;
      return true;
    }
    return false;
  }
  
  // Set player as ready.
  void setReady(int player) {
    if (!validPlayer(player)) return;
    ready[player] = true;
    tryToAdvance();
  }

  // Check if every players is ready and advance the phase.
  void tryToAdvance() {
    if (ready.every((b) => b)) {
      switch (phase) {
        case GamePhase.Night:
          night();
          phase = GamePhase.Day;
          resetReady();
          break;
        case GamePhase.Day:
          day();
          phase = GamePhase.Finale;
          resetReady();
          break;
        default:
          break;
      }
    } else {
      print('DEBUG: ready: ${ready}');
    }
  }
  
  // Night phase: wake up players in order of their characters.
  void night() {
    originals.wake(new Doppelganger(), originals, targetSets);
    
    // create a new copy of the characters to avoid characters'
    // actions to interfere during the night phase
    List<Character> finalCharacters = List.from(originals.characters);
    finals = new Characters(originals.nPlayers, finalCharacters);
    
    originals.wake(new Werewolf(), finals, targetSets);
    originals.wake(new Minion(), finals, targetSets);
    originals.wake(new Mason(), finals, targetSets);
    originals.wake(new Seer(), finals, targetSets);
    originals.wake(new Robber(), finals, targetSets);
    originals.wake(new Troublemaker(), finals, targetSets);
    originals.wake(new Drunk(), finals, targetSets);
    originals.wake(new Insomniac(), finals, targetSets);
  }
  
  // Day phase; vote, lynch and judge.
  void day() {
    vote();
    lynch();
    judge();
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
  
  // Complete votes.
  void vote() {
    final cs = finals; 

    // if no vote, generate random vote
    Random r = Random();
    for (int i = 0; i < cs.nPlayers; i++) {
      if (votes[i] == -1) {
        votes[i] = r.nextInt(cs.nPlayers); 
      }
    }
  }
  
  // Lynch players with highest votes.
  void lynch() {
    final cs = finals; 
    int n = votes.length;
    
    // count the votes
    List<int> counts = new List.filled(n, 0); 
    for (int vote in votes) {
      counts[vote] += 1;
    }

    print('DEBUG: Votes $counts');
    
    int maxCount = counts.reduce(max);
    
    deads = new List();
    
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
  }
  
  // Judge players who win.
  void judge() {
    final cs = finals; 
    winners = new List();
    
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
  }
}

