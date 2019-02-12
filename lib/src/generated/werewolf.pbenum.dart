///
//  Generated code. Do not modify.
//  source: werewolf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class Role extends $pb.ProtobufEnum {
  static const Role UNKNOWN = const Role._(0, 'UNKNOWN');
  static const Role VILLAGER = const Role._(1, 'VILLAGER');
  static const Role WEREWOLF = const Role._(2, 'WEREWOLF');
  static const Role SEER = const Role._(3, 'SEER');
  static const Role ROBBER = const Role._(4, 'ROBBER');
  static const Role TROUBLEMAKER = const Role._(5, 'TROUBLEMAKER');
  static const Role TANNER = const Role._(6, 'TANNER');
  static const Role DRUNK = const Role._(7, 'DRUNK');
  static const Role HUNTER = const Role._(8, 'HUNTER');
  static const Role MASON = const Role._(9, 'MASON');
  static const Role INSOMNIAC = const Role._(10, 'INSOMNIAC');
  static const Role MINION = const Role._(11, 'MINION');
  static const Role DOPPELGANGER = const Role._(12, 'DOPPELGANGER');

  static const List<Role> values = const <Role> [
    UNKNOWN,
    VILLAGER,
    WEREWOLF,
    SEER,
    ROBBER,
    TROUBLEMAKER,
    TANNER,
    DRUNK,
    HUNTER,
    MASON,
    INSOMNIAC,
    MINION,
    DOPPELGANGER,
  ];

  static final Map<int, Role> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Role valueOf(int value) => _byValue[value];
  static void $checkItem(Role v) {
    if (v is! Role) $pb.checkItemFailed(v, 'Role');
  }

  const Role._(int v, String n) : super(v, n);
}

class Status extends $pb.ProtobufEnum {
  static const Status OK = const Status._(0, 'OK');
  static const Status WAIT = const Status._(1, 'WAIT');
  static const Status INVALID = const Status._(2, 'INVALID');
  static const Status ERROR = const Status._(3, 'ERROR');

  static const List<Status> values = const <Status> [
    OK,
    WAIT,
    INVALID,
    ERROR,
  ];

  static final Map<int, Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Status valueOf(int value) => _byValue[value];
  static void $checkItem(Status v) {
    if (v is! Status) $pb.checkItemFailed(v, 'Status');
  }

  const Status._(int v, String n) : super(v, n);
}

