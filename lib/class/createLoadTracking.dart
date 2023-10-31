class CreateLoadingTracking {
  String? loadTrackingId;
  String? dono;
  String? planDate;
  String? matno;
  String? matDescLabel;
  String? batch;
  String? sloc;
  String? palletno;
  int? quantity;
  String? createdBy;
  bool? isDeleted;
  bool? isSynData;

  CreateLoadingTracking(
      {this.loadTrackingId,
      this.dono,
      this.planDate,
      this.matno,
      this.matDescLabel,
      this.batch,
      this.sloc,
      this.palletno,
      this.quantity,
      this.createdBy,
      this.isDeleted,
      this.isSynData});

  CreateLoadingTracking.fromJson(Map<String, dynamic> json) {
    loadTrackingId = json['loadTrackingId'];
    dono = json['dono'];
    planDate = json['planDate'];
    matno = json['matno'];
    matDescLabel = json['matDescLabel'];
    batch = json['batch'];
    sloc = json['sloc'];
    palletno = json['palletno'];
    quantity = json['quantity'];
    createdBy = json['createdBy'];
    isDeleted = json['isDeleted'];
    isSynData = json['isSynData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loadTrackingId'] = this.loadTrackingId;
    data['dono'] = this.dono;
    data['planDate'] = this.planDate;
    data['matno'] = this.matno;
    data['matDescLabel'] = this.matDescLabel;
    data['batch'] = this.batch;
    data['sloc'] = this.sloc;
    data['palletno'] = this.palletno;
    data['quantity'] = this.quantity;
    data['createdBy'] = this.createdBy;
    data['isDeleted'] = this.isDeleted;
    data['isSynData'] = this.isSynData;
    return data;
  }
}
