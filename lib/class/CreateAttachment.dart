class CreateAttachment {
  String? attachmentId;
  String? referenceId;
  String? referenceName;
  String? value;
  String? fileName;
  String? fileSize;
  String? userType;
  bool? isDeleted;
  String? createdBy;
  String? createdTime;
  String? lastUpdatedBy;
  String? lastUpdatedTime;

  CreateAttachment(
      {this.attachmentId,
      this.referenceId,
      this.referenceName,
      this.value,
      this.fileName,
      this.fileSize,
      this.userType,
      this.isDeleted,
      this.createdBy,
      this.createdTime,
      this.lastUpdatedBy,
      this.lastUpdatedTime});

  CreateAttachment.fromJson(Map<String, dynamic> json) {
    attachmentId = json['attachmentId'];
    referenceId = json['referenceId'];
    referenceName = json['referenceName'];
    value = json['value'];
    fileName = json['fileName'];
    fileSize = json['fileSize'];
    userType = json['userType'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'];
    createdTime = json['createdTime'];
    lastUpdatedBy = json['lastUpdatedBy'];
    lastUpdatedTime = json['lastUpdatedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attachmentId'] = this.attachmentId;
    data['referenceId'] = this.referenceId;
    data['referenceName'] = this.referenceName;
    data['value'] = this.value;
    data['fileName'] = this.fileName;
    data['fileSize'] = this.fileSize;
    data['userType'] = this.userType;
    data['isDeleted'] = this.isDeleted;
    data['createdBy'] = this.createdBy;
    data['createdTime'] = this.createdTime;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['lastUpdatedTime'] = this.lastUpdatedTime;
    return data;
  }
}