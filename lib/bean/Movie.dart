import 'dart:convert' show json;

class Movie {
  int id;
  String actor;
  String bian;
  String dao;
  String date;
  String img;
  String info;
  String link;
  String local;
  String name;
  String origin;
  String score;
  String station;
  String status;
  String time;
  String type;

  Movie();

  Movie.fromParams(
      {this.id,
      this.actor,
      this.bian,
      this.dao,
      this.date,
      this.img,
      this.info,
      this.link,
      this.local,
      this.name,
      this.origin,
      this.score,
      this.station,
      this.status,
      this.time,
      this.type});

  Movie.fromJson(jsonRes) {
    id = jsonRes['id'];
    actor = jsonRes['actor'];
    bian = jsonRes['bian'];
    dao = jsonRes['dao'];
    date = jsonRes['date'];
    img = jsonRes['img'];
    info = jsonRes['info'];
    link = jsonRes['link'];
    local = jsonRes['local'];
    name = jsonRes['name'];
    origin = jsonRes['origin'];
    score = jsonRes['score'];
    station = jsonRes['station'];
    status = jsonRes['status'];
    time = jsonRes['time'];
    type = jsonRes['type'];
  }

  @override
  String toString() {
    return '{"id": $id,"actor": ${actor != null ? '${json.encode(actor)}' : 'null'},"bian": ${bian != null ? '${json.encode(bian)}' : 'null'},"dao": ${dao != null ? '${json.encode(dao)}' : 'null'},"date": ${date != null ? '${json.encode(date)}' : 'null'},"img": ${img != null ? '${json.encode(img)}' : 'null'},"link": ${link != null ? '${json.encode(link)}' : 'null'},"local": ${local != null ? '${json.encode(local)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'},"origin": ${origin != null ? '${json.encode(origin)}' : 'null'},"score": ${score != null ? '${json.encode(score)}' : 'null'},"station": ${station != null ? '${json.encode(station)}' : 'null'},"status": ${status != null ? '${json.encode(status)}' : 'null'},"time": ${time != null ? '${json.encode(time)}' : 'null'},"type": ${type != null ? '${json.encode(type)}' : 'null'}}';
  }
}
