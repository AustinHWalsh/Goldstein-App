import 'userIDs.dart';
import 'package:firebase_helpers/firebase_helpers.dart';

DatabaseService<IDModel> idDBS = DatabaseService<IDModel>(
  "userIDs",
  fromDS: (id, data) => IDModel.fromDS(id, data),
  toMap: (announcement) => announcement.toMap(idDBS),
);
