class DeliveryOrderDOValidate {
  List<DeliveryOrder>? deliveryOrder;
  bool? result;
  String? message;

  DeliveryOrderDOValidate({this.deliveryOrder, this.result, this.message});

  DeliveryOrderDOValidate.fromJson(Map<String, dynamic> json) {
    if (json['deliveryOrder'] != null) {
      deliveryOrder = <DeliveryOrder>[];
      json['deliveryOrder'].forEach((v) {
        deliveryOrder!.add(new DeliveryOrder.fromJson(v));
      });
    }
    result = json['result'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deliveryOrder != null) {
      data['deliveryOrder'] =
          this.deliveryOrder!.map((v) => v.toJson()).toList();
    }
    data['result'] = this.result;
    data['message'] = this.message;
    return data;
  }
}

class DeliveryOrder {
  String? deliveryOrderId;
  String? dono;
  String? planDate;
  int? sequence;
  String? matno;
  String? batch;
  String? sloc;
  bool? isDeleted;
  bool? isAllowBatch;
  String? status;
  String? repType;
  String? shipNo;
  String? shipto;
  String? matdesc;
  String? matDescLabel;
  String? productionDate;
  String? bagType;
  int? quantity;
  dynamic? deliveryNote;
  dynamic? shipIns;
  String? shipMark;
  dynamic? plate;
  dynamic? driver;
  dynamic? remark;
  dynamic? reason;
  dynamic? tisi;
  String? shipType;
  String? recDBType;
  String? fileName;
  String? refDeliveryOrderId;
  dynamic? printedTime;
  bool? isSynData;
  String? synTime;
  String? createdBy;
  String? createdTime;
  dynamic? lastUpdatedBy;
  dynamic? lastUpdatedTime;
  String? varType;
  String? transporter;
  String? type;
  dynamic? ticketNo;
  dynamic? plant;

  DeliveryOrder(
      {this.deliveryOrderId,
      this.dono,
      this.planDate,
      this.sequence,
      this.matno,
      this.batch,
      this.sloc,
      this.isDeleted,
      this.isAllowBatch,
      this.status,
      this.repType,
      this.shipNo,
      this.shipto,
      this.matdesc,
      this.matDescLabel,
      this.productionDate,
      this.bagType,
      this.quantity,
      this.deliveryNote,
      this.shipIns,
      this.shipMark,
      this.plate,
      this.driver,
      this.remark,
      this.reason,
      this.tisi,
      this.shipType,
      this.recDBType,
      this.fileName,
      this.refDeliveryOrderId,
      this.printedTime,
      this.isSynData,
      this.synTime,
      this.createdBy,
      this.createdTime,
      this.lastUpdatedBy,
      this.lastUpdatedTime,
      this.varType,
      this.transporter,
      this.type,
      this.ticketNo,
      this.plant});

  DeliveryOrder.fromJson(Map<String, dynamic> json) {
    deliveryOrderId = json['deliveryOrderId'];
    dono = json['dono'];
    planDate = json['planDate'];
    sequence = json['sequence'];
    matno = json['matno'];
    batch = json['batch'];
    sloc = json['sloc'];
    isDeleted = json['isDeleted'];
    isAllowBatch = json['isAllowBatch'];
    status = json['status'];
    repType = json['repType'];
    shipNo = json['shipNo'];
    shipto = json['shipto'];
    matdesc = json['matdesc'];
    matDescLabel = json['matDescLabel'];
    productionDate = json['productionDate'];
    bagType = json['bagType'];
    quantity = json['quantity'];
    deliveryNote = json['deliveryNote'];
    shipIns = json['shipIns'];
    shipMark = json['shipMark'];
    plate = json['plate'];
    driver = json['driver'];
    remark = json['remark'];
    reason = json['reason'];
    tisi = json['tisi'];
    shipType = json['shipType'];
    recDBType = json['recDBType'];
    fileName = json['fileName'];
    refDeliveryOrderId = json['refDeliveryOrderId'];
    printedTime = json['printedTime'];
    isSynData = json['isSynData'];
    synTime = json['synTime'];
    createdBy = json['createdBy'];
    createdTime = json['createdTime'];
    lastUpdatedBy = json['lastUpdatedBy'];
    lastUpdatedTime = json['lastUpdatedTime'];
    varType = json['varType'];
    transporter = json['transporter'];
    type = json['type'];
    ticketNo = json['ticketNo'];
    plant = json['plant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliveryOrderId'] = this.deliveryOrderId;
    data['dono'] = this.dono;
    data['planDate'] = this.planDate;
    data['sequence'] = this.sequence;
    data['matno'] = this.matno;
    data['batch'] = this.batch;
    data['sloc'] = this.sloc;
    data['isDeleted'] = this.isDeleted;
    data['isAllowBatch'] = this.isAllowBatch;
    data['status'] = this.status;
    data['repType'] = this.repType;
    data['shipNo'] = this.shipNo;
    data['shipto'] = this.shipto;
    data['matdesc'] = this.matdesc;
    data['matDescLabel'] = this.matDescLabel;
    data['productionDate'] = this.productionDate;
    data['bagType'] = this.bagType;
    data['quantity'] = this.quantity;
    data['deliveryNote'] = this.deliveryNote;
    data['shipIns'] = this.shipIns;
    data['shipMark'] = this.shipMark;
    data['plate'] = this.plate;
    data['driver'] = this.driver;
    data['remark'] = this.remark;
    data['reason'] = this.reason;
    data['tisi'] = this.tisi;
    data['shipType'] = this.shipType;
    data['recDBType'] = this.recDBType;
    data['fileName'] = this.fileName;
    data['refDeliveryOrderId'] = this.refDeliveryOrderId;
    data['printedTime'] = this.printedTime;
    data['isSynData'] = this.isSynData;
    data['synTime'] = this.synTime;
    data['createdBy'] = this.createdBy;
    data['createdTime'] = this.createdTime;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['lastUpdatedTime'] = this.lastUpdatedTime;
    data['varType'] = this.varType;
    data['transporter'] = this.transporter;
    data['type'] = this.type;
    data['ticketNo'] = this.ticketNo;
    data['plant'] = this.plant;
    return data;
  }
}