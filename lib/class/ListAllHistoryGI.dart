class ListAllHistoryGI {
  String? loadTrackingId;
  String? dono;
  String? planDate;
  bool? isDeleted;
  String? matno;
  String? matDescLabel;
  String? batch;
  String? sloc;
  String? palletno;
  int? quantity;
  bool? isSynData;
  String? synTime;
  String? createdBy;
  String? createdTime;
  String? lastUpdatedBy;
  String? lastUpdatedTime;

  ListAllHistoryGI(
      {this.loadTrackingId,
      this.dono,
      this.planDate,
      this.isDeleted,
      this.matno,
      this.matDescLabel,
      this.batch,
      this.sloc,
      this.palletno,
      this.quantity,
      this.isSynData,
      this.synTime,
      this.createdBy,
      this.createdTime,
      this.lastUpdatedBy,
      this.lastUpdatedTime});

  ListAllHistoryGI.fromJson(Map<String, dynamic> json) {
    loadTrackingId = json['loadTrackingId'];
    dono = json['dono'];
    planDate = json['planDate'];
    isDeleted = json['isDeleted'];
    matno = json['matno'];
    matDescLabel = json['matDescLabel'];
    batch = json['batch'];
    sloc = json['sloc'];
    palletno = json['palletno'];
    quantity = json['quantity'];
    isSynData = json['isSynData'];
    synTime = json['synTime'];
    createdBy = json['createdBy'];
    createdTime = json['createdTime'];
    lastUpdatedBy = json['lastUpdatedBy'];
    lastUpdatedTime = json['lastUpdatedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loadTrackingId'] = this.loadTrackingId;
    data['dono'] = this.dono;
    data['planDate'] = this.planDate;
    data['isDeleted'] = this.isDeleted;
    data['matno'] = this.matno;
    data['matDescLabel'] = this.matDescLabel;
    data['batch'] = this.batch;
    data['sloc'] = this.sloc;
    data['palletno'] = this.palletno;
    data['quantity'] = this.quantity;
    data['isSynData'] = this.isSynData;
    data['synTime'] = this.synTime;
    data['createdBy'] = this.createdBy;
    data['createdTime'] = this.createdTime;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['lastUpdatedTime'] = this.lastUpdatedTime;
    return data;
  }
}