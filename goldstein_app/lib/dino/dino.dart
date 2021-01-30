import 'package:firebase_helpers/firebase_helpers.dart';

class DinoModel extends DatabaseService {
  final String id;
  final String breakfast;
  final String lunch;
  final String dinner;
  final DateTime day;

  DinoModel({this.id, this.breakfast, this.lunch, this.dinner, this.day})
      : super(id);

  factory DinoModel.fromMap(Map data) {
    return DinoModel(
      breakfast: data['breakfast'],
      lunch: data['lunch'],
      dinner: data['dinner'],
      day: data['day'],
    );
  }

  factory DinoModel.fromDS(String id, Map<String, dynamic> data) {
    return DinoModel(
      id: id,
      breakfast: data['breakfast'],
      lunch: data['lunch'],
      dinner: data['dinner'],
      day: data['day'].toDate(),
    );
  }
}
