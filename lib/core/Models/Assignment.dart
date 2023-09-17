import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  String? by;
  String? path;
  String? div;
  String? subject;
  String? standard;
  Timestamp? timeStamp;
  String? url;
  String? type;
  String? details;
  String? id;
  String? title;

  Assignment(
      {this.by,
      this.title,
      this.path,
      this.div,
      this.subject,
      this.standard,
      this.timeStamp,
      this.type,
      this.url,
      this.details,
      this.id});


  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(

    by: json['by'],
    path: json['path'],
    title: json['title'],
    div: json['div'],
    subject: json['subject'],
    type: json['type'],
    standard: json['standard'],
    timeStamp: json['timeStamp'] as Timestamp,
    url: json['url'],
    details: json['details'],
    id: json['id'] ?? '',
    );
  }
  factory Assignment.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return Assignment(

    by: documentSnapshot['by'],
    path: documentSnapshot['path'],
    title: documentSnapshot['title'],
    div: documentSnapshot['div'],
    subject: documentSnapshot['subject'],
    type: documentSnapshot['type'],
    standard: documentSnapshot['standard'],
    timeStamp: documentSnapshot['timeStamp'] as Timestamp,
    url: documentSnapshot['url'],
    details: documentSnapshot['details'],
    id: documentSnapshot['id'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['by'] = this.by;
    data['path'] = this.path;
    data['title'] = this.title;
    data['div'] = this.div;
    data['type'] = this.type;
    data['subject'] = this.subject;
    data['standard'] = this.standard;
    data['url'] = this.url;
    data['details'] = this.details;
    return data;
  }
}
