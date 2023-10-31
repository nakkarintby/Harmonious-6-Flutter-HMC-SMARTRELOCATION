class ResultLogin {
  User? user;
  String? accessToken;
  String? expiration;

  ResultLogin({this.user, this.accessToken, this.expiration});

  ResultLogin.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    accessToken = json['accessToken'];
    expiration = json['expiration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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
  String? location;
  String? roleId;
  bool? isDeleted;
  String? createdBy;
  String? createdTime;
  String? lastUpdatedby;
  String? lastUpdatedTime;

  User(
      {this.userId,
      this.username,
      this.password,
      this.name,
      this.location,
      this.roleId,
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
    data['isDeleted'] = this.isDeleted;
    data['createdBy'] = this.createdBy;
    data['createdTime'] = this.createdTime;
    data['lastUpdatedby'] = this.lastUpdatedby;
    data['lastUpdatedTime'] = this.lastUpdatedTime;
    return data;
  }
}
