import 'package:goldstein_app/dino/dino.dart';

class DinoHelpers {
  // Groups the meals in datetime order, so the date can be used to determine
  // the meals
  Map<DateTime, List<dynamic>> groupEvents(List<DinoModel> allMeals) {
    Map<DateTime, List<dynamic>> data = {};
    allMeals.forEach((event) {
      DateTime date =
          DateTime(event.day.year, event.day.month, event.day.day).toLocal();
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }
}
