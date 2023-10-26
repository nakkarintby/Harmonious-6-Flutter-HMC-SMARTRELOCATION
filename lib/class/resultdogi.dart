class ResultDOGI {
  List<DeliveryOrder>? deliveryOrder;
  String? message;
  bool? result;

  ResultDOGI({this.deliveryOrder, this.message, this.result});

  ResultDOGI.fromJson(Map<String, dynamic> json) {
    if (json['deliveryOrder'] != null) {
      deliveryOrder = <DeliveryOrder>[];
      json['deliveryOrder'].forEach((v) {
        deliveryOrder!.add(new DeliveryOrder.fromJson(v));
      });
    }
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deliveryOrder != null) {
      data['deliveryOrder'] =
          this.deliveryOrder!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}

class DeliveryOrder {
  String? bagType;
  String? batch;
  String? createdBy;
  String? createdTime;
  String? deliveryNote;
  String? deliveryOrderId;
  String? dono;
  String? driver;
  String? fileName;
  bool? isAllowBatch;
  bool? isDeleted;
  bool? isSynData;
  String? lastUpdatedBy;
  String? lastUpdatedTime;
  String? matDescLabel;
  String? matdesc;
  String? matno;
  String? planDate;
  String? plate;
  String? printedTime;
  String? productionDate;
  int? quantity;
  String? reason;
  String? recDBType;
  String? refDeliveryOrderId;
  String? remark;
  String? repType;
  int? sequence;
  String? shipIns;
  String? shipMark;
  String? shipNo;
  String? shipType;
  String? shipto;
  String? sloc;
  String? status;
  String? synTime;
  String? tisi;
  String? transporter;
  String? varType;
  EntityKey? entityKey;

  DeliveryOrder(
      {this.bagType,
      this.batch,
      this.createdBy,
      this.createdTime,
      this.deliveryNote,
      this.deliveryOrderId,
      this.dono,
      this.driver,
      this.fileName,
      this.isAllowBatch,
      this.isDeleted,
      this.isSynData,
      this.lastUpdatedBy,
      this.lastUpdatedTime,
      this.matDescLabel,
      this.matdesc,
      this.matno,
      this.planDate,
      this.plate,
      this.printedTime,
      this.productionDate,
      this.quantity,
      this.reason,
      this.recDBType,
      this.refDeliveryOrderId,
      this.remark,
      this.repType,
      this.sequence,
      this.shipIns,
      this.shipMark,
      this.shipNo,
      this.shipType,
      this.shipto,
      this.sloc,
      this.status,
      this.synTime,
      this.tisi,
      this.transporter,
      this.varType,
      this.entityKey});

  DeliveryOrder.fromJson(Map<String, dynamic> json) {
    bagType = json['bagType'];
    batch = json['batch'];
    createdBy = json['createdBy'];
    createdTime = json['createdTime'];
    deliveryNote = json['deliveryNote'];
    deliveryOrderId = json['deliveryOrderId'];
    dono = json['dono'];
    driver = json['driver'];
    fileName = json['fileName'];
    isAllowBatch = json['isAllowBatch'];
    isDeleted = json['isDeleted'];
    isSynData = json['isSynData'];
    lastUpdatedBy = json['lastUpdatedBy'];
    lastUpdatedTime = json['lastUpdatedTime'];
    matDescLabel = json['matDescLabel'];
    matdesc = json['matdesc'];
    matno = json['matno'];
    planDate = json['planDate'];
    plate = json['plate'];
    printedTime = json['printedTime'];
    productionDate = json['productionDate'];
    quantity = json['quantity'];
    reason = json['reason'];
    recDBType = json['recDBType'];
    refDeliveryOrderId = json['refDeliveryOrderId'];
    remark = json['remark'];
    repType = json['repType'];
    sequence = json['sequence'];
    shipIns = json['shipIns'];
    shipMark = json['shipMark'];
    shipNo = json['shipNo'];
    shipType = json['shipType'];
    shipto = json['shipto'];
    sloc = json['sloc'];
    status = json['status'];
    synTime = json['synTime'];
    tisi = json['tisi'];
    transporter = json['transporter'];
    varType = json['varType'];
    entityKey = json['entityKey'] != null
        ? new EntityKey.fromJson(json['entityKey'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bagType'] = this.bagType;
    data['batch'] = this.batch;
    data['createdBy'] = this.createdBy;
    data['createdTime'] = this.createdTime;
    data['deliveryNote'] = this.deliveryNote;
    data['deliveryOrderId'] = this.deliveryOrderId;
    data['dono'] = this.dono;
    data['driver'] = this.driver;
    data['fileName'] = this.fileName;
    data['isAllowBatch'] = this.isAllowBatch;
    data['isDeleted'] = this.isDeleted;
    data['isSynData'] = this.isSynData;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['lastUpdatedTime'] = this.lastUpdatedTime;
    data['matDescLabel'] = this.matDescLabel;
    data['matdesc'] = this.matdesc;
    data['matno'] = this.matno;
    data['planDate'] = this.planDate;
    data['plate'] = this.plate;
    data['printedTime'] = this.printedTime;
    data['productionDate'] = this.productionDate;
    data['quantity'] = this.quantity;
    data['reason'] = this.reason;
    data['recDBType'] = this.recDBType;
    data['refDeliveryOrderId'] = this.refDeliveryOrderId;
    data['remark'] = this.remark;
    data['repType'] = this.repType;
    data['sequence'] = this.sequence;
    data['shipIns'] = this.shipIns;
    data['shipMark'] = this.shipMark;
    data['shipNo'] = this.shipNo;
    data['shipType'] = this.shipType;
    data['shipto'] = this.shipto;
    data['sloc'] = this.sloc;
    data['status'] = this.status;
    data['synTime'] = this.synTime;
    data['tisi'] = this.tisi;
    data['transporter'] = this.transporter;
    data['varType'] = this.varType;
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
  dynamic value;

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
