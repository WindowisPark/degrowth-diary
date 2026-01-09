import 'package:equatable/equatable.dart';

/// 유저 엔티티
class User extends Equatable {
  final String id;
  final String nickname;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String timezone;
  final int streakCount;
  final String? lastRecordDate;
  final DateTime? lastRecordAt;
  final UserSettings settings;

  const User({
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

  User copyWith({
    String? id,
    String? nickname,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? timezone,
    int? streakCount,
    String? lastRecordDate,
    DateTime? lastRecordAt,
    UserSettings? settings,
  }) {
    return User(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      timezone: timezone ?? this.timezone,
      streakCount: streakCount ?? this.streakCount,
      lastRecordDate: lastRecordDate ?? this.lastRecordDate,
      lastRecordAt: lastRecordAt ?? this.lastRecordAt,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nickname,
        createdAt,
        updatedAt,
        timezone,
        streakCount,
        lastRecordDate,
        lastRecordAt,
        settings,
      ];
}

/// 유저 설정
class UserSettings extends Equatable {
  final bool pushEnabled;
  final String pushTime;
  final bool darkMode;

  const UserSettings({
    required this.pushEnabled,
    required this.pushTime,
    required this.darkMode,
  });

  const UserSettings.defaults()
      : pushEnabled = true,
        pushTime = '21:00',
        darkMode = false;

  UserSettings copyWith({
    bool? pushEnabled,
    String? pushTime,
    bool? darkMode,
  }) {
    return UserSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      pushTime: pushTime ?? this.pushTime,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  @override
  List<Object?> get props => [pushEnabled, pushTime, darkMode];
}
