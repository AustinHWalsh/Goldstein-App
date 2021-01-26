import 'package:firebase_helpers/firebase_helpers.dart';

class AnnouncementModel extends DatabaseService {
  final String id;
  final String details;
  final DateTime announcementDate;
  final String author;
  final String url;

  AnnouncementModel(
      {this.id, this.details, this.announcementDate, this.author, this.url})
      : super(id);

  factory AnnouncementModel.fromMap(Map data) {
    return AnnouncementModel(
      details: data['details'],
      announcementDate: data['date'],
      author: data['author'],
      url: data['url'],
    );
  }

  factory AnnouncementModel.fromDS(String id, Map<String, dynamic> data) {
    return AnnouncementModel(
      id: id,
      details: data['details'],
      announcementDate: data['date'].toDate(),
      author: data['author'],
      url: data['url'],
    );
  }
}
