class AccountEntity {
  final String? taxIdOrId;
  final String? username;
  final String? passwordHash;
  final String? salt;
  final String? fullName;
  final bool? enable;
  final DateTime? updateAt;
  final DateTime? lockUntil;
  final int? failedLoginCount;

  AccountEntity({
    this.taxIdOrId,
    this.username,
    this.passwordHash,
    this.salt,
    this.fullName,
    this.enable,
    this.updateAt,
    this.lockUntil,
    this.failedLoginCount = 0,
  });

  // copywith
  AccountEntity copyWith({
    String? taxIdOrId,
    String? username,
    String? passwordHash,
    String? salt,
    String? fullName,
    bool? enable,
    DateTime? updateAt,
    DateTime? lockUntil,
    int? failedLoginCount,
  }) {
    return AccountEntity(
      taxIdOrId: taxIdOrId ?? this.taxIdOrId,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      fullName: fullName ?? this.fullName,
      enable: enable ?? this.enable,
      updateAt: updateAt ?? this.updateAt,
      lockUntil: lockUntil ?? this.lockUntil,
      failedLoginCount: failedLoginCount ?? this.failedLoginCount,
    );
  }

  // from json
  factory AccountEntity.fromJson(Map<String, dynamic> json) {
    return AccountEntity(
      taxIdOrId: json['tax_id_or_id'] as String?,
      username: json['username'] as String?,
      passwordHash: json['password_hash'] as String?,
      salt: json['salt'] as String?,
      fullName: json['full_name'] as String?,
      enable: json['enable'] as bool?,
      updateAt: json['update_at'] != null
          ? DateTime.parse(json['update_at'] as String)
          : null,
      lockUntil: json['lock_until'] != null
          ? DateTime.parse(json['lock_until'] as String)
          : null,
      failedLoginCount: json['failed_login_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tax_id_or_id': taxIdOrId,
      'username': username,
      'password_hash': passwordHash,
      'salt': salt,
      'full_name': fullName,
      'enable': enable,
      'update_at': updateAt?.toIso8601String(),
      'lock_until': lockUntil?.toIso8601String(),
      'failed_login_count': failedLoginCount,
    };
  }
}
