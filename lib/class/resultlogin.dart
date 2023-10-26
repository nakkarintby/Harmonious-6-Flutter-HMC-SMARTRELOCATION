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
  String? createdBy;
  String? createdTime;
  bool? isDeleted;
  String? lastUpdatedTime;
  String? lastUpdatedby;
  String? location;
  String? name;
  String? password;
  String? roleId;
  String? userId;
  String? username;
  EntityKey? entityKey;

  User(
      {this.createdBy,
      this.createdTime,
      this.isDeleted,
      this.lastUpdatedTime,
      this.lastUpdatedby,
      this.location,
      this.name,
      this.password,
      this.roleId,
      this.userId,
      this.username,
      this.entityKey});

  User.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createdTime = json['createdTime'];
    isDeleted = json['isDeleted'];
    lastUpdatedTime = json['lastUpdatedTime'];
    lastUpdatedby = json['lastUpdatedby'];
    location = json['location'];
    name = json['name'];
    password = json['password'];
    roleId = json['roleId'];
    userId = json['userId'];
    username = json['username'];
    entityKey = json['entityKey'] != null
        ? new EntityKey.fromJson(json['entityKey'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdBy'] = this.createdBy;
    data['createdTime'] = this.createdTime;
    data['isDeleted'] = this.isDeleted;
    data['lastUpdatedTime'] = this.lastUpdatedTime;
    data['lastUpdatedby'] = this.lastUpdatedby;
    data['location'] = this.location;
    data['name'] = this.name;
    data['password'] = this.password;
    data['roleId'] = this.roleId;
    data['userId'] = this.userId;
    data['username'] = this.username;
    if (this.entityKey != null) {
      data['entityKey'] = this.entityKey!.toJson();
    }
    return data;
  }
}

class EntityKey {
  String? entityContainerName;
  List<EntityKeyValues>? entityKeyValues;
  String? entitySetName;

  EntityKey(
      {this.entityContainerName, this.entityKeyValues, this.entitySetName});

  EntityKey.fromJson(Map<String, dynamic> json) {
    entityContainerName = json['entityContainerName'];
    if (json['entityKeyValues'] != null) {
      entityKeyValues = <EntityKeyValues>[];
      json['entityKeyValues'].forEach((v) {
        entityKeyValues!.add(new EntityKeyValues.fromJson(v));
      });
    }
    entitySetName = json['entitySetName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entityContainerName'] = this.entityContainerName;
    if (this.entityKeyValues != null) {
      data['entityKeyValues'] =
          this.entityKeyValues!.map((v) => v.toJson()).toList();
    }
    data['entitySetName'] = this.entitySetName;
    return data;
  }
}

class EntityKeyValues {
  String? key;
  String? value;

  EntityKeyValues({this.key, this.value});

  EntityKeyValues.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}
