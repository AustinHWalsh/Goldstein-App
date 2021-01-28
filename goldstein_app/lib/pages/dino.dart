import 'package:flutter/material.dart';
import 'package:goldstein_app/assets/constants.dart' as Constants;
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

  @override
  void initState() {
    super.initState();
    currDate = DateTime.now();
    startDate = currDate.subtract(Duration(days: Constants.NUM_DAY_IN_YEAR));
    endDate = currDate.add(Duration(days: Constants.NUM_DAY_IN_YEAR));
    _pageController = PageController(
        initialPage: int.parse(DateFormat("D").format(currDate)));
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
          child: Row(
            children: <Widget>[
              Text(
                DateFormat("EEE, dd MMM yyyy").format(currDate),
                style: TextStyle(color: Colors.white),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          height: MediaQuery.of(context).size.height / 12,
        ),
      ],
    );
  }
}
