class SelectDODetail {
  String? deliveryOrderId;
  String? matno;
  String? batch;
  String? sloc;
  String? matdesc;
  String? matDescLabel;
  String? productionDate;
  int? quantity;
  int? loadqty;
  dynamic? remark;
  String? bagType;
  dynamic? tisi;

  SelectDODetail(
      {this.deliveryOrderId,
      this.matno,
      this.batch,
      this.sloc,
      this.matdesc,
      this.matDescLabel,
      this.productionDate,
      this.quantity,
      this.loadqty,
      this.remark,
      this.bagType,
      this.tisi});

  SelectDODetail.fromJson(Map<String, dynamic> json) {
    deliveryOrderId = json['deliveryOrderId'];
    matno = json['matno'];
    batch = json['batch'];
    sloc = json['sloc'];
    matdesc = json['matdesc'];
    matDescLabel = json['matDescLabel'];
    productionDate = json['productionDate'];
    quantity = json['quantity'];
    loadqty = json['loadqty'];
    remark = json['remark'];
    bagType = json['bagType'];
    tisi = json['tisi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliveryOrderId'] = this.deliveryOrderId;
    data['matno'] = this.matno;
    data['batch'] = this.batch;
    data['sloc'] = this.sloc;
    data['matdesc'] = this.matdesc;
    data['matDescLabel'] = this.matDescLabel;
    data['productionDate'] = this.productionDate;
    data['quantity'] = this.quantity;
    data['loadqty'] = this.loadqty;
    data['remark'] = this.remark;
    data['bagType'] = this.bagType;
    data['tisi'] = this.tisi;
    return data;
  }
}