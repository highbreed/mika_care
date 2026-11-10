// To parse this JSON data, do
//
//     final sparePartModal = sparePartModalFromJson(jsonString);

import 'dart:convert';

SparePartModal sparePartModalFromJson(String str) =>
    SparePartModal.fromJson(json.decode(str));

String sparePartModalToJson(SparePartModal data) => json.encode(data.toJson());

class SparePartModal {
  dynamic itemCode;
  dynamic itemName;
  dynamic codeBars;
  dynamic sellItem;
  dynamic invntItem;
  dynamic onHand;
  dynamic isCommited;
  dynamic uBrand;
  dynamic uOurModelNo;
  dynamic uItmSubGrp1;
  dynamic uItmSubGrp2;
  dynamic uItmSubGrp3;
  dynamic uAddSpecs;
  dynamic uFullDesc;

  SparePartModal({
    required this.itemCode,
    required this.itemName,
    required this.codeBars,
    required this.sellItem,
    required this.invntItem,
    required this.onHand,
    required this.isCommited,
    required this.uBrand,
    required this.uOurModelNo,
    required this.uItmSubGrp1,
    required this.uItmSubGrp2,
    required this.uItmSubGrp3,
    required this.uAddSpecs,
    required this.uFullDesc,
  });

  factory SparePartModal.fromJson(Map<String, dynamic> json) => SparePartModal(
    itemCode: json["ItemCode"],
    itemName: json["ItemName"],
    codeBars: json["CodeBars"],
    sellItem: json["SellItem"],
    invntItem: json["InvntItem"],
    onHand: json["OnHand"],
    isCommited: json["IsCommited"],
    uBrand: json["U_Brand"],
    uOurModelNo: json["U_OurModelNo"] ?? json["PartNumber"],
    uItmSubGrp1: json["U_ItmSubGrp1"] ?? json["PartItemGrp1"],
    uItmSubGrp2: json["U_ItmSubGrp2"] ?? json["PartItemGrp2"],
    uItmSubGrp3: json["U_ItmSubGrp3"],
    uAddSpecs: json["U_AddSpecs"],
    uFullDesc: json["U_FullDesc"] ?? json["ItemName"],
  );

  Map<String, dynamic> toJson() => {
    "ItemCode": itemCode,
    "ItemName": itemName,
    "CodeBars": codeBars,
    "SellItem": sellItem,
    "InvntItem": invntItem,
    "OnHand": onHand,
    "IsCommited": isCommited,
    "U_Brand": uBrand,
    "U_OurModelNo": uOurModelNo,
    "U_ItmSubGrp1": uItmSubGrp1,
    "U_ItmSubGrp2": uItmSubGrp2,
    "U_ItmSubGrp3": uItmSubGrp3,
    "U_AddSpecs": uAddSpecs,
    "U_FullDesc": uFullDesc,
  };

  @override
  String toString() {
    return "$itemName-$uOurModelNo";
  }
}
