import 'character.dart';

import 'dart:math';

enum GamePhase {
  Initial, Night, Day, Finale
}

class Game {
  Characters originals;
  Characters finals;
  
  Random random;
  
  // each player's targets
  List<List<int>> targetSets;
  
  // each player's revelations
  List<Map<int, Character>> revelationSets;

  GamePhase phase = GamePhase.Initial;
  
  List<int> votes;
  List<int> deads;
  List<int> winners;
  
  Game(this.originals, this.random);
  
  void init() {
    originals.shuffle(random);
    
    int nPlayers = originals.nPlayers;
    
    // It is okay to assign the same empty set to all targets initially,
    // because we will re-assign each element to a new list instead of appending to the list.
    targetSets = new List.filled(nPlayers, []);
    votes = new List.filled(nPlayers, -1);
    
    // This will assign same list to each element!
    //     revelationSets = new List.filled(nPlayers, {});
    // Therefore, do explicit loop
    revelationSets = new List(nPlayers);
    for (int i = 0; i < nPlayers; i++) {
      revelationSets[i] = new Map();
    }
    
    phase = GamePhase.Night;
  }
  
  bool validPlayer(int player) =>
    player >= 0 && player < originals.nPlayers;

  bool validCard(int target) =>
    target >= 0 && target < originals.characters.length;

  bool castVote(int player, int suspect) {
    if (validPlayer(player) && validPlayer(suspect)) {
      votes[player] = suspect;
      return true;
    }
    return false;
  }

  // Advance the phase.
  void advance() {
    switch (phase) {
      case GamePhase.Initial:
        init();
        break;
      case GamePhase.Night:
        night();
        break;
      case GamePhase.Day:
        day();
        break;
      default:
        break;
    }
  }
  
  // Night phase: wake up players in order of their characters.
  void night() {
    originals.wake(new Doppelganger(), originals, targetSets, revelationSets);
    
    // create a new copy of the characters to avoid characters'
    // actions to interfere during the night phase
    List<Character> finalCharacters = List.from(originals.characters);
    finals = new Characters(originals.nPlayers, finalCharacters);
    
    originals.wake(new Werewolf(), finals, targetSets, revelationSets);
    originals.wake(new Minion(), finals, targetSets, revelationSets);
    originals.wake(new Mason(), finals, targetSets, revelationSets);
    originals.wake(new Seer(), finals, targetSets, revelationSets);
    originals.wake(new Robber(), finals, targetSets, revelationSets);
    originals.wake(new Troublemaker(), finals, targetSets, revelationSets);
    originals.wake(new Drunk(), finals, targetSets, revelationSets);
    originals.wake(new Insomniac(), finals, targetSets, revelationSets);
    
    print('DEBUG: revelationSets: ${revelationSets}');
    print('DEBUG: targetSets: ${targetSets}');
    
    phase = GamePhase.Day;
  }
  
  // Day phase: vote, lynch and judge.
  void day() {
    vote();
    lynch();
    judge();

    phase = GamePhase.Finale;
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
    deads = new List();
    
    // count the votes
    List<int> counts = new List.filled(n, 0); 
    for (int vote in votes) {
      counts[vote] += 1;
    }

    print('DEBUG: Votes $counts');
    
    int maxCount = counts.reduce(max);
    
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

