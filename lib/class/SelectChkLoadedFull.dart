class SelectChkLoadedFull {
  String? dono;
  int? loadQTY;
  int? orderQTY;
  String? planDate;

  SelectChkLoadedFull({this.dono, this.loadQTY, this.orderQTY, this.planDate});

  SelectChkLoadedFull.fromJson(Map<String, dynamic> json) {
    dono = json['dono'];
    loadQTY = json['loadQTY'];
    orderQTY = json['orderQTY'];
    planDate = json['planDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dono'] = this.dono;
    data['loadQTY'] = this.loadQTY;
    data['orderQTY'] = this.orderQTY;
    data['planDate'] = this.planDate;
    return data;
  }
}
