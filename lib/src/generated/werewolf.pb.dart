///
//  Generated code. Do not modify.
//  source: werewolf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'werewolf.pbenum.dart';

export 'werewolf.pbenum.dart';

class Slot extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Slot', package: const $pb.PackageName('werewolf'))
    ..a<int>(1, 'player', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  Slot() : super();
  Slot.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Slot.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Slot clone() => new Slot()..mergeFromMessage(this);
  Slot copyWith(void Function(Slot) updates) => super.copyWith((message) => updates(message as Slot));
  $pb.BuilderInfo get info_ => _i;
  static Slot create() => new Slot();
  Slot createEmptyInstance() => create();
  static $pb.PbList<Slot> createRepeated() => new $pb.PbList<Slot>();
  static Slot getDefault() => _defaultInstance ??= create()..freeze();
  static Slot _defaultInstance;
  static void $checkItem(Slot v) {
    if (v is! Slot) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get player => $_get(0, 0);
  set player(int v) { $_setUnsignedInt32(0, v); }
  bool hasPlayer() => $_has(0);
  void clearPlayer() => clearField(1);
}

class Action extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Action', package: const $pb.PackageName('werewolf'))
    ..a<int>(1, 'player', $pb.PbFieldType.OU3)
    ..p<int>(2, 'targets', $pb.PbFieldType.PU3)
    ..hasRequiredFields = false
  ;

  Action() : super();
  Action.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Action.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Action clone() => new Action()..mergeFromMessage(this);
  Action copyWith(void Function(Action) updates) => super.copyWith((message) => updates(message as Action));
  $pb.BuilderInfo get info_ => _i;
  static Action create() => new Action();
  Action createEmptyInstance() => create();
  static $pb.PbList<Action> createRepeated() => new $pb.PbList<Action>();
  static Action getDefault() => _defaultInstance ??= create()..freeze();
  static Action _defaultInstance;
  static void $checkItem(Action v) {
    if (v is! Action) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get player => $_get(0, 0);
  set player(int v) { $_setUnsignedInt32(0, v); }
  bool hasPlayer() => $_has(0);
  void clearPlayer() => clearField(1);

  List<int> get targets => $_getList(1);
}

class Effect_Revelation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Effect.Revelation', package: const $pb.PackageName('werewolf'))
    ..a<int>(1, 'player', $pb.PbFieldType.OU3)
    ..e<Role>(2, 'role', $pb.PbFieldType.OE, Role.UNKNOWN, Role.valueOf, Role.values)
    ..hasRequiredFields = false
  ;

  Effect_Revelation() : super();
  Effect_Revelation.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Effect_Revelation.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Effect_Revelation clone() => new Effect_Revelation()..mergeFromMessage(this);
  Effect_Revelation copyWith(void Function(Effect_Revelation) updates) => super.copyWith((message) => updates(message as Effect_Revelation));
  $pb.BuilderInfo get info_ => _i;
  static Effect_Revelation create() => new Effect_Revelation();
  Effect_Revelation createEmptyInstance() => create();
  static $pb.PbList<Effect_Revelation> createRepeated() => new $pb.PbList<Effect_Revelation>();
  static Effect_Revelation getDefault() => _defaultInstance ??= create()..freeze();
  static Effect_Revelation _defaultInstance;
  static void $checkItem(Effect_Revelation v) {
    if (v is! Effect_Revelation) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get player => $_get(0, 0);
  set player(int v) { $_setUnsignedInt32(0, v); }
  bool hasPlayer() => $_has(0);
  void clearPlayer() => clearField(1);

  Role get role => $_getN(1);
  set role(Role v) { setField(2, v); }
  bool hasRole() => $_has(1);
  void clearRole() => clearField(2);
}

class Effect extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Effect', package: const $pb.PackageName('werewolf'))
    ..e<Status>(1, 'status', $pb.PbFieldType.OE, Status.OK, Status.valueOf, Status.values)
    ..pp<Effect_Revelation>(2, 'revelations', $pb.PbFieldType.PM, Effect_Revelation.$checkItem, Effect_Revelation.create)
    ..hasRequiredFields = false
  ;

  Effect() : super();
  Effect.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Effect.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Effect clone() => new Effect()..mergeFromMessage(this);
  Effect copyWith(void Function(Effect) updates) => super.copyWith((message) => updates(message as Effect));
  $pb.BuilderInfo get info_ => _i;
  static Effect create() => new Effect();
  Effect createEmptyInstance() => create();
  static $pb.PbList<Effect> createRepeated() => new $pb.PbList<Effect>();
  static Effect getDefault() => _defaultInstance ??= create()..freeze();
  static Effect _defaultInstance;
  static void $checkItem(Effect v) {
    if (v is! Effect) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Status get status => $_getN(0);
  set status(Status v) { setField(1, v); }
  bool hasStatus() => $_has(0);
  void clearStatus() => clearField(1);

  List<Effect_Revelation> get revelations => $_getList(1);
}

class Ballot extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Ballot', package: const $pb.PackageName('werewolf'))
    ..a<int>(1, 'player', $pb.PbFieldType.OU3)
    ..a<int>(2, 'target', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  Ballot() : super();
  Ballot.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Ballot.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Ballot clone() => new Ballot()..mergeFromMessage(this);
  Ballot copyWith(void Function(Ballot) updates) => super.copyWith((message) => updates(message as Ballot));
  $pb.BuilderInfo get info_ => _i;
  static Ballot create() => new Ballot();
  Ballot createEmptyInstance() => create();
  static $pb.PbList<Ballot> createRepeated() => new $pb.PbList<Ballot>();
  static Ballot getDefault() => _defaultInstance ??= create()..freeze();
  static Ballot _defaultInstance;
  static void $checkItem(Ballot v) {
    if (v is! Ballot) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get player => $_get(0, 0);
  set player(int v) { $_setUnsignedInt32(0, v); }
  bool hasPlayer() => $_has(0);
  void clearPlayer() => clearField(1);

  int get target => $_get(1, 0);
  set target(int v) { $_setUnsignedInt32(1, v); }
  bool hasTarget() => $_has(1);
  void clearTarget() => clearField(2);
}

class Verdict extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Verdict', package: const $pb.PackageName('werewolf'))
    ..e<Status>(1, 'status', $pb.PbFieldType.OE, Status.OK, Status.valueOf, Status.values)
    ..p<int>(2, 'votes', $pb.PbFieldType.PU3)
    ..p<int>(3, 'winners', $pb.PbFieldType.PU3)
    ..p<int>(4, 'deads', $pb.PbFieldType.PU3)
    ..pp<Role>(5, 'roles', $pb.PbFieldType.PE, Role.$checkItem, null, Role.valueOf, Role.values)
    ..hasRequiredFields = false
  ;

  Verdict() : super();
  Verdict.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Verdict.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Verdict clone() => new Verdict()..mergeFromMessage(this);
  Verdict copyWith(void Function(Verdict) updates) => super.copyWith((message) => updates(message as Verdict));
  $pb.BuilderInfo get info_ => _i;
  static Verdict create() => new Verdict();
  Verdict createEmptyInstance() => create();
  static $pb.PbList<Verdict> createRepeated() => new $pb.PbList<Verdict>();
  static Verdict getDefault() => _defaultInstance ??= create()..freeze();
  static Verdict _defaultInstance;
  static void $checkItem(Verdict v) {
    if (v is! Verdict) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Status get status => $_getN(0);
  set status(Status v) { setField(1, v); }
  bool hasStatus() => $_has(0);
  void clearStatus() => clearField(1);

  List<int> get votes => $_getList(1);

  List<int> get winners => $_getList(2);

  List<int> get deads => $_getList(3);

  List<Role> get roles => $_getList(4);
}

