import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user.dart';

/// User DTO (Firebase 변환용)
class UserModel {
  final String id;
  final String nickname;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String timezone;
  final int streakCount;
  final String? lastRecordDate;
  final DateTime? lastRecordAt;
  final UserSettingsModel settings;

  const UserModel({
    required this.id,
    required this.nickname,
    required this.createdAt,
    required this.updatedAt,
    required this.timezone,
    required this.streakCount,
    this.lastRecordDate,
    this.lastRecordAt,
    required this.settings,
  });

  /// Entity → Model
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      nickname: user.nickname,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      timezone: user.timezone,
      streakCount: user.streakCount,
      lastRecordDate: user.lastRecordDate,
      lastRecordAt: user.lastRecordAt,
      settings: UserSettingsModel.fromEntity(user.settings),
    );
  }

  /// Firestore → Model
  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      nickname: json['nickname'] as String? ?? '익명',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      timezone: json['timezone'] as String? ?? 'Asia/Seoul',
      streakCount: json['streakCount'] as int? ?? 0,
      lastRecordDate: json['lastRecordDate'] as String?,
      lastRecordAt: json['lastRecordAt'] != null
          ? (json['lastRecordAt'] as Timestamp).toDate()
          : null,
      settings: json['settings'] != null
          ? UserSettingsModel.fromJson(json['settings'] as Map<String, dynamic>)
          : const UserSettingsModel.defaults(),
    );
  }

  /// Model → Entity
  User toEntity() {
    return User(
      id: id,
      nickname: nickname,
      createdAt: createdAt,
      updatedAt: updatedAt,
      timezone: timezone,
      streakCount: streakCount,
      lastRecordDate: lastRecordDate,
      lastRecordAt: lastRecordAt,
      settings: settings.toEntity(),
    );
  }

  /// Model → Firestore (생성용)
  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'timezone': timezone,
      'streakCount': 0,
      'lastRecordDate': null,
      'lastRecordAt': null,
      'settings': settings.toJson(),
    };
  }

  /// 신규 유저 생성
  factory UserModel.newUser({
    required String id,
    required String nickname,
    String timezone = 'Asia/Seoul',
  }) {
    final now = DateTime.now();
    return UserModel(
      id: id,
      nickname: nickname,
      createdAt: now,
      updatedAt: now,
      timezone: timezone,
      streakCount: 0,
      lastRecordDate: null,
      lastRecordAt: null,
      settings: const UserSettingsModel.defaults(),
    );
  }
}

/// UserSettings DTO
class UserSettingsModel {
  final bool pushEnabled;
  final String pushTime;
  final bool darkMode;

  const UserSettingsModel({
    required this.pushEnabled,
    required this.pushTime,
    required this.darkMode,
  });

  const UserSettingsModel.defaults()
      : pushEnabled = true,
        pushTime = '21:00',
        darkMode = false;

  factory UserSettingsModel.fromEntity(UserSettings settings) {
    return UserSettingsModel(
      pushEnabled: settings.pushEnabled,
      pushTime: settings.pushTime,
      darkMode: settings.darkMode,
    );
  }

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      pushTime: json['pushTime'] as String? ?? '21:00',
      darkMode: json['darkMode'] as bool? ?? false,
    );
  }

  UserSettings toEntity() {
    return UserSettings(
      pushEnabled: pushEnabled,
      pushTime: pushTime,
      darkMode: darkMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushEnabled': pushEnabled,
      'pushTime': pushTime,
      'darkMode': darkMode,
    };
  }
}
