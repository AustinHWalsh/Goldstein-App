import 'package:flutter/material.dart';
import 'package:goldstein_app/assets/constants.dart' as Constants;
import 'package:goldstein_app/assets/error.dart';
import 'package:goldstein_app/dino/dino.dart';
import 'package:goldstein_app/dino/dino_firestore_service.dart';
import 'package:goldstein_app/dino/dino_helpers.dart';
import 'package:goldstein_app/ui/leftmenu.dart';
import 'package:intl/intl.dart';

class DinoMeals extends StatefulWidget {
  @override
  _DinoMealsState createState() => _DinoMealsState();
}

class _DinoMealsState extends State<DinoMeals> {
  // Initial day and max days
  DateTime currDate;
  DateTime startDate;
  DateTime endDate;
  PageController _pageController;
  Map<DateTime, List<dynamic>> _meals;
  DinoModel _currentMeal;

  @override
  void initState() {
    super.initState();
    currDate = DateTime.now();
    startDate = currDate.subtract(Duration(days: Constants.NUM_DAY_IN_YEAR));
    endDate = currDate.add(Duration(days: Constants.NUM_DAY_IN_YEAR));
    _pageController = PageController(
        initialPage: int.parse(DateFormat("D").format(currDate)));

    _meals = {};
    _currentMeal = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meals"),
      ),
      drawer: LeftMenu(),
      body: _dayLayout(),
    );
  }

  // View of the page builder, will show date at top and breakfast, lunch
  // and dinner as sub headers
  Widget _dayLayout() {
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) {
        return _mealInfo();
      },
      onPageChanged: (index) {
        if (index < _pageController.page)
          currDate = currDate.subtract(Duration(days: 1));
        else
          currDate = currDate.add(Duration(days: 1));
        setState(() {});
      },
      itemCount: Constants.TWO_YEARS,
    );
  }

  // Displays breakfast, lunch and dinner with the corresponding meals (if any)
  Widget _mealInfo() {
    return ListView(
      children: <Widget>[
        Container(
          color: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Stack(
            children: <Widget>[
              Container(
                child: FlatButton.icon(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                  color: Colors.red,
                  onPressed: () {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  label: Text(""),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                alignment: Alignment.centerLeft,
              ),
              Text(
                DateFormat("EEE, dd MMM yyyy").format(currDate),
                style: TextStyle(color: Colors.white),
              ),
              Container(
                child: FlatButton.icon(
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                  color: Colors.red,
                  onPressed: () {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  label: Text(""),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                alignment: Alignment.centerRight,
              ),
            ],
            alignment: FractionalOffset.center,
          ),
          height: MediaQuery.of(context).size.height / 12,
        ),
        Container(
          child: ListTile(
            title: Text("Breakfast"),
          ),
          decoration: BoxDecoration(
              color: Colors.grey[300], border: Border.all(color: Colors.black)),
        ),
        showMeal("Breakfast"),
        Container(
          child: ListTile(
            title: Text("Lunch"),
          ),
          decoration: BoxDecoration(
              color: Colors.grey[300], border: Border.all(color: Colors.black)),
        ),
        showMeal("Lunch"),
        Container(
          child: ListTile(
            title: Text("Dinner"),
          ),
          decoration: BoxDecoration(
              color: Colors.grey[300], border: Border.all(color: Colors.black)),
        ),
        showMeal("Dinner"),
      ],
    );
  }

  // Shows a meal from the database corresponding to the current day
  Widget showMeal(String meal) {
    return StreamBuilder(
      stream: dinoDBS.streamList(),
      builder: (context, snapshot) {
        String text = "";
        if (snapshot.hasData) {
          List<DinoModel> allMeals = snapshot.data;
          if (allMeals.isNotEmpty) {
            _meals = DinoHelpers().groupEvents(allMeals);
            DateTime _day =
                DateTime(currDate.year, currDate.month, currDate.day).toLocal();
            _currentMeal = (_meals[_day] == null) ? null : _meals[_day][0];
            if (_currentMeal != null) {
              switch (meal) {
                case "Breakfast":
                  text = _currentMeal.breakfast.toString();
                  break;
                case "Lunch":
                  text = _currentMeal.lunch
                      .toString()
                      .replaceFirst(RegExp('` '), '\n');
                  break;
                case "Dinner":
                  text = _currentMeal.dinner
                      .toString()
                      .replaceFirst(RegExp('` '), '\n');
                  break;
                default:
                  errorReporter.captureMessage("Invalid dino string passed");
              }
            }
          } else {
            _meals = {};
            _currentMeal = null;
          }
        }
        return Visibility(
          visible: _currentMeal != null,
          child: Container(
            child: ListTile(
              title: Text(text),
            ),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          ),
        );
      },
    );
  }
}
