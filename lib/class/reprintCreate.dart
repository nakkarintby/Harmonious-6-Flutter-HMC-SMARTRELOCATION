class RePrintCreate {
  String? bagType;
  String? matNo;
  String? matDesc;
  String? batch;
  String? palletNo;
  int? weight;
  String? unit;
  String? productionDate;
  String? tisi;
  int? labelQty;
  String? user;

  RePrintCreate(
      {this.bagType,
      this.matNo,
      this.matDesc,
      this.batch,
      this.palletNo,
      this.weight,
      this.unit,
      this.productionDate,
      this.tisi,
      this.labelQty,
      this.user});

  RePrintCreate.fromJson(Map<String, dynamic> json) {
    bagType = json['bagType'];
    matNo = json['matNo'];
    matDesc = json['matDesc'];
    batch = json['batch'];
    palletNo = json['palletNo'];
    weight = json['weight'];
    unit = json['unit'];
    productionDate = json['productionDate'];
    tisi = json['tisi'];
    labelQty = json['labelQty'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bagType'] = this.bagType;
    data['matNo'] = this.matNo;
    data['matDesc'] = this.matDesc;
    data['batch'] = this.batch;
    data['palletNo'] = this.palletNo;
    data['weight'] = this.weight;
    data['unit'] = this.unit;
    data['productionDate'] = this.productionDate;
    data['tisi'] = this.tisi;
    data['labelQty'] = this.labelQty;
    data['user'] = this.user;
    return data;
  }
}
