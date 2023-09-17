import 'package:ourESchool/imports.dart';

class Message {
  String? to;
  String? from;
  String? message;
  Timestamp? timeStamp;
  String? id;
  String? for_;

  Message({this.id, this.to, this.from, this.message, this.timeStamp, this.for_});

  factory Message.fromSnapShot(DocumentSnapshot snapshot) {
    return Message(
      id: snapshot['id'].toString(),
    to: snapshot['to'].toString(),
    for_: snapshot['for'].toString(),
    from: snapshot['from'].toString(),
    message: snapshot['message'].toString(),
    timeStamp: snapshot['timestamp'] as Timestamp,
    );
  
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
    to: json['to'],
    for_: json['for'],
    from: json['from'],
    message: json['message'].toString(),
    timeStamp: json['timestamp'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['for'] = this.for_;
    data['to'] = this.to;
    data['from'] = this.from;
    data['timestamp'] = this.timeStamp;
    data['message'] = this.message;
    return data;
  }
}
