import 'dart:convert' show json;

class MvList {

  String sourceLink;
  String sourceName;
  String sourceType;
  int id;
  String mvImg;
  String mvLink;
  String mvName;
  String mvStatus;
  String sourceTime;

  MvList.fromParams({this.sourceLink, this.sourceName, this.sourceType, this.id, this.mvImg, this.mvLink, this.mvName, this.mvStatus, this.sourceTime});

  factory MvList(jsonStr) => jsonStr == null ? null : jsonStr is String ? new MvList.fromJson(json.decode(jsonStr)) : new MvList.fromJson(jsonStr);

  MvList.fromJson(jsonRes) {
    sourceLink = jsonRes['sourceLink'];
    sourceName = jsonRes['sourceName'];
    sourceType = jsonRes['sourceType'];
    id = jsonRes['id'];
    mvImg = jsonRes['mvImg'];
    mvLink = jsonRes['mvLink'];
    mvName = jsonRes['mvName'];
    mvStatus = jsonRes['mvStatus'];
    sourceTime = jsonRes['sourceTime'];
  }

  @override
  String toString() {
    return '{"sourceLink": ${sourceLink != null?'${json.encode(sourceLink)}':'null'},"sourceName": ${sourceName != null?'${json.encode(sourceName)}':'null'},"sourceType": ${sourceType != null?'${json.encode(sourceType)}':'null'},"id": $id,"mvImg": ${mvImg != null?'${json.encode(mvImg)}':'null'},"mvLink": ${mvLink != null?'${json.encode(mvLink)}':'null'},"mvName": ${mvName != null?'${json.encode(mvName)}':'null'},"mvStatus": ${mvStatus != null?'${json.encode(mvStatus)}':'null'},"sourceTime": ${sourceTime != null?'${json.encode(sourceTime)}':'null'}}';
  }
}

