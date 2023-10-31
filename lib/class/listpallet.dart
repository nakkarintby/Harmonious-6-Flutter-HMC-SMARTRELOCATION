class ListPallet {
  String? batch;
  String? createdBy;
  String? createdTime;
  String? dono;
  bool? isDeleted;
  bool? isSynData;
  String? lastUpdatedBy;
  String? lastUpdatedTime;
  String? loadTrackingId;
  String? matDescLabel;
  String? matno;
  String? palletno;
  String? planDate;
  int? quantity;
  String? sloc;
  String? synTime;
  EntityKey? entityKey;

  ListPallet(
      {this.batch,
      this.createdBy,
      this.createdTime,
      this.dono,
      this.isDeleted,
      this.isSynData,
      this.lastUpdatedBy,
      this.lastUpdatedTime,
      this.loadTrackingId,
      this.matDescLabel,
      this.matno,
      this.palletno,
      this.planDate,
      this.quantity,
      this.sloc,
      this.synTime,
      this.entityKey});

  ListPallet.fromJson(Map<String, dynamic> json) {
    batch = json['batch'];
    createdBy = json['createdBy'];
    createdTime = json['createdTime'];
    dono = json['dono'];
    isDeleted = json['isDeleted'];
    isSynData = json['isSynData'];
    lastUpdatedBy = json['lastUpdatedBy'];
    lastUpdatedTime = json['lastUpdatedTime'];
    loadTrackingId = json['loadTrackingId'];
    matDescLabel = json['matDescLabel'];
    matno = json['matno'];
    palletno = json['palletno'];
    planDate = json['planDate'];
    quantity = json['quantity'];
    sloc = json['sloc'];
    synTime = json['synTime'];
    entityKey = json['entityKey'] != null
        ? new EntityKey.fromJson(json['entityKey'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batch'] = this.batch;
    data['createdBy'] = this.createdBy;
    data['createdTime'] = this.createdTime;
    data['dono'] = this.dono;
    data['isDeleted'] = this.isDeleted;
    data['isSynData'] = this.isSynData;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['lastUpdatedTime'] = this.lastUpdatedTime;
    data['loadTrackingId'] = this.loadTrackingId;
    data['matDescLabel'] = this.matDescLabel;
    data['matno'] = this.matno;
    data['palletno'] = this.palletno;
    data['planDate'] = this.planDate;
    data['quantity'] = this.quantity;
    data['sloc'] = this.sloc;
    data['synTime'] = this.synTime;
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
