class CreateLoadingTracking {
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
  String? createdBy;
  String? lastUpdatedBy;

  CreateLoadingTracking(
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
      this.createdBy,
      this.lastUpdatedBy});

  CreateLoadingTracking.fromJson(Map<String, dynamic> json) {
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
    createdBy = json['createdBy'];
    lastUpdatedBy = json['lastUpdatedBy'];
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
    data['createdBy'] = this.createdBy;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    return data;
  }
}