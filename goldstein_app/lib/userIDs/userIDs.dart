import 'package:firebase_helpers/firebase_helpers.dart';

class IDModel extends DatabaseService {
  final String id;
  final bool isLogged;

  IDModel({this.id, this.isLogged}) : super(id);

  factory IDModel.fromMap(Map data) {
    return IDModel(
      isLogged: data['isLogged'],
    );
  }

  factory IDModel.fromDS(String id, Map<String, dynamic> data) {
    return IDModel(
      id: id,
      isLogged: data['isLogged'],
    );
  }
}
