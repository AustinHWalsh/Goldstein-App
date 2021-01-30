import 'dino.dart';
import 'package:firebase_helpers/firebase_helpers.dart';

DatabaseService<DinoModel> dinoDBS = DatabaseService<DinoModel>(
  "meals",
  fromDS: (id, data) => DinoModel.fromDS(id, data),
  toMap: (meal) => meal.toMap(dinoDBS),
);
