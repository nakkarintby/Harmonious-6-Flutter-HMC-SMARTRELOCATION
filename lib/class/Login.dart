class LoginClass {
  User? user;
  List<UserRole>? userRole;
  String? accessToken;
  String? expiration;

  LoginClass({this.user, this.userRole, this.accessToken, this.expiration});

  LoginClass.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['userRole'] != null) {
      userRole = <UserRole>[];
      json['userRole'].forEach((v) {
        userRole!.add(new UserRole.fromJson(v));
      });
    }
    accessToken = json['accessToken'];
    expiration = json['expiration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.userRole != null) {
      data['userRole'] = this.userRole!.map((v) => v.toJson()).toList();
    }
    data['accessToken'] = this.accessToken;
    data['expiration'] = this.expiration;
    return data;
  }
}

class User {
  String? userId;
  String? username;
  String? password;
  String? name;
  dynamic? location;
  dynamic? roleId;
  String? emailAddress;
  dynamic? recoveryPassword;
  bool? isRecovery;
  bool? isDeleted;
  String? createdBy;
  String? createdTime;
  dynamic? lastUpdatedby;
  dynamic? lastUpdatedTime;

  User(
      {this.userId,
      this.username,
      this.password,
      this.name,
      this.location,
      this.roleId,
      this.emailAddress,
      this.recoveryPassword,
      this.isRecovery,
      this.isDeleted,
      this.createdBy,
      this.createdTime,
      this.lastUpdatedby,
      this.lastUpdatedTime});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    password = json['password'];
    name = json['name'];
    location = json['location'];
    roleId = json['roleId'];
    emailAddress = json['emailAddress'];
    recoveryPassword = json['recoveryPassword'];
    isRecovery = json['isRecovery'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'];
    createdTime = json['createdTime'];
    lastUpdatedby = json['lastUpdatedby'];
    lastUpdatedTime = json['lastUpdatedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['name'] = this.name;
    data['location'] = this.location;
    data['roleId'] = this.roleId;
    data['emailAddress'] = this.emailAddress;
    data['recoveryPassword'] = this.recoveryPassword;
    data['isRecovery'] = this.isRecovery;
    data['isDeleted'] = this.isDeleted;
    data['createdBy'] = this.createdBy;
    data['createdTime'] = this.createdTime;
    data['lastUpdatedby'] = this.lastUpdatedby;
    data['lastUpdatedTime'] = this.lastUpdatedTime;
    return data;
  }
}

class UserRole {
  String? userRoleId;
  String? userId;
  String? roleCode;
  String? referenceId;
  bool? isDeleted;
  String? createdBy;
  String? createdTime;
  dynamic? lastUpdatedBy;
  dynamic? lastUpdatedTime;

  UserRole(
      {this.userRoleId,
      this.userId,
      this.roleCode,
      this.referenceId,
      this.isDeleted,
      this.createdBy,
      this.createdTime,
      this.lastUpdatedBy,
      this.lastUpdatedTime});

  UserRole.fromJson(Map<String, dynamic> json) {
    userRoleId = json['userRoleId'];
    userId = json['userId'];
    roleCode = json['roleCode'];
    referenceId = json['referenceId'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'];
    createdTime = json['createdTime'];
    lastUpdatedBy = json['lastUpdatedBy'];
    lastUpdatedTime = json['lastUpdatedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userRoleId'] = this.userRoleId;
    data['userId'] = this.userId;
    data['roleCode'] = this.roleCode;
    data['referenceId'] = this.referenceId;
    data['isDeleted'] = this.isDeleted;
    data['createdBy'] = this.createdBy;
    data['createdTime'] = this.createdTime;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['lastUpdatedTime'] = this.lastUpdatedTime;
    return data;
  }
}