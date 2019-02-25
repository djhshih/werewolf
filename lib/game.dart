import 'dart:math';

import 'src/player.dart';
import 'character.dart';


enum GamePhase {
  Initial, Night, Day, Finale
}

class Game {
  Characters originals;
  Characters finals;
  
  Random random;

  List<Player> players;
  
  GamePhase phase = GamePhase.Initial;
  
  // index of dead players
  List<int> deads;
  
  // index of winners
  List<int> winners;
  
  Game(this.originals, this.random);
  
  void init() {
    originals.shuffle(random);
    
    int nPlayers = originals.nPlayers;
    
    // NB Manual for loop here because we need to create
    //    multiple instances of player.
    //    Using List.filled will create only one.
    players = List(nPlayers);
    for (int i = 0; i < nPlayers; ++i) {
      players[i] = Player();
    }
    
    phase = GamePhase.Night;
  }
  
  bool validPlayer(int player) => originals.validPlayer(player);

  bool validCard(int target) => originals.validCard(target);

  bool castVote(int player, int suspect) {
    if (finals.validPlayer(player) && finals.validPlayer(suspect)) {
      players[player].vote = suspect;
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
    originals.wake(new Doppelganger(), originals, players);
    
    // create a new copy of the characters to avoid characters'
    // actions to interfere during the night phase
    List<Character> finalCharacters = List.from(originals.characters);
    finals = new Characters(originals.nPlayers, finalCharacters);
    
    originals.wake(new Werewolf(), finals, players);
    originals.wake(new Minion(), finals, players);
    originals.wake(new Mason(), finals, players);
    originals.wake(new Seer(), finals, players);
    originals.wake(new Robber(), finals, players);
    originals.wake(new Troublemaker(), finals, players);
    originals.wake(new Drunk(), finals, players);
    originals.wake(new Insomniac(), finals, players);
    
    print('DEBUG: players:');
    for (int i = 0; i < players.length; ++i) {
      Player p = players[i];
      print('$i: ${p.targets} ${p.revelations}');
    }
    
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
      if (players[i].vote == -1) {
        players[i].vote = r.nextInt(cs.nPlayers); 
      }
    }
  }
  
  // Lynch players with highest votes.
  void lynch() {
    final cs = finals; 
    int n = players.length;
    deads = new List();
    
    // count the votes
    List<int> counts = new List.filled(n, 0); 
    for (var p in players) {
      counts[p.vote] += 1;
    }

    print('DEBUG: Vote counts $counts');
    
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
        print(' INFO: Hunter $i takes down player ${players[i].vote}.');
        taken.add(players[i].vote);
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

