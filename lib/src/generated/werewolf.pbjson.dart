///
//  Generated code. Do not modify.
//  source: werewolf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const Role$json = const {
  '1': 'Role',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'VILLAGER', '2': 1},
    const {'1': 'WEREWOLF', '2': 2},
    const {'1': 'SEER', '2': 3},
    const {'1': 'ROBBER', '2': 4},
    const {'1': 'TROUBLEMAKER', '2': 5},
    const {'1': 'TANNER', '2': 6},
    const {'1': 'DRUNK', '2': 7},
    const {'1': 'HUNTER', '2': 8},
    const {'1': 'MASON', '2': 9},
    const {'1': 'INSOMNIAC', '2': 10},
    const {'1': 'MINION', '2': 11},
    const {'1': 'DOPPELGANGER', '2': 12},
  ],
};

const Status$json = const {
  '1': 'Status',
  '2': const [
    const {'1': 'OK', '2': 0},
    const {'1': 'WAIT', '2': 1},
    const {'1': 'INVALID', '2': 2},
    const {'1': 'ERROR', '2': 3},
  ],
};

const Slot$json = const {
  '1': 'Slot',
  '2': const [
    const {'1': 'player', '3': 1, '4': 1, '5': 13, '10': 'player'},
    const {'1': 'key', '3': 2, '4': 1, '5': 13, '10': 'key'},
  ],
};

const Action$json = const {
  '1': 'Action',
  '2': const [
    const {'1': 'player', '3': 1, '4': 1, '5': 13, '10': 'player'},
    const {'1': 'key', '3': 2, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'targets', '3': 3, '4': 3, '5': 13, '10': 'targets'},
  ],
};

const Effect$json = const {
  '1': 'Effect',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.werewolf.Status', '10': 'status'},
    const {'1': 'revelations', '3': 2, '4': 3, '5': 11, '6': '.werewolf.Effect.Revelation', '10': 'revelations'},
  ],
  '3': const [Effect_Revelation$json],
};

const Effect_Revelation$json = const {
  '1': 'Revelation',
  '2': const [
    const {'1': 'player', '3': 1, '4': 1, '5': 13, '10': 'player'},
    const {'1': 'role', '3': 2, '4': 1, '5': 14, '6': '.werewolf.Role', '10': 'role'},
  ],
};

const Ballot$json = const {
  '1': 'Ballot',
  '2': const [
    const {'1': 'player', '3': 1, '4': 1, '5': 13, '10': 'player'},
    const {'1': 'key', '3': 2, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'target', '3': 3, '4': 1, '5': 13, '10': 'target'},
  ],
};

const Verdict$json = const {
  '1': 'Verdict',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.werewolf.Status', '10': 'status'},
    const {'1': 'votes', '3': 2, '4': 3, '5': 13, '10': 'votes'},
    const {'1': 'winners', '3': 3, '4': 3, '5': 13, '10': 'winners'},
    const {'1': 'deads', '3': 4, '4': 3, '5': 13, '10': 'deads'},
    const {'1': 'roles', '3': 5, '4': 3, '5': 14, '6': '.werewolf.Role', '10': 'roles'},
  ],
};

