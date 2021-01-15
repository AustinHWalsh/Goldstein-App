import 'announcement.dart';
import 'package:firebase_helpers/firebase_helpers.dart';

DatabaseService<AnnouncementModel> announcementDBS =
    DatabaseService<AnnouncementModel>(
  "Announcements",
  fromDS: (id, data) => AnnouncementModel.fromDS(id, data),
  toMap: (announcement) => announcement.toMap(announcementDBS),
);
