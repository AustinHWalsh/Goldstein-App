import 'package:flutter/material.dart';
import 'package:goldstein_app/announcements/announce_firestore_service.dart';
import 'package:goldstein_app/announcements/announcement.dart';
import 'package:goldstein_app/assets/error.dart';
import 'package:goldstein_app/pages/add_announcement.dart';
import 'package:goldstein_app/ui/leftmenu.dart';
import 'package:goldstein_app/ui/menu_open.dart';
import 'package:goldstein_app/ui/misc_popups.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dino.dart';

enum HomeButton {
  photos,
  facebook,
  contacts,
  dino,
}

// Home Page
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<dynamic> _announcements;
  String formatDate(DateTime date) => new DateFormat("MMMM d").format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homepage(),
      drawer: LeftMenu(),
      floatingActionButton: Visibility(
          visible: MenuOpen.userLogged,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              MenuOpen.adding = true;
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddAnnouncePage()));
              MenuOpen.adding = false;
            },
          )),
    );
  }

  // Main widgets of the homepage
  Widget homepage() {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("Goldstein College"),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
            child: Container(
              child: Text(
                "Announcements",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              height: (MediaQuery.of(context).size.height / 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.8, color: Colors.red),
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(5), bottom: Radius.circular(5)),
              ),
              height: (MediaQuery.of(context).size.height / (2.5)),
              child: createAnnouncements(),
            ),
          )
        ])),
        navigatorButtons(),
        SliverGrid(
          delegate: SliverChildListDelegate.fixed([
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 4),
                      borderRadius: BorderRadius.circular(12)),
                  child: SizedBox.expand(
                    child: OutlinedButton(
                      child: Text("Credits"),
                      onPressed: () {
                        CreditPopup().openCreditPop(context);
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                    ),
                  )),
            ),
          ]),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 12)),
        )
      ],
    );
  }

  // SliverGrid that holds the buttons and their style
  Widget navigatorButtons() {
    return SliverGrid(
        // create the 4 buttons that appear on the homepage
        delegate: SliverChildListDelegate.fixed(
          List<Widget>.generate(4, (nButton) {
            return createButton(nButton);
          }),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 4),
        ));
  }

  // Function to create a styled button depending on the index passed
  // Also creates the text and on pressed function
  Widget createButton(int nButton) {
    HomeButton buttonToBeMade = HomeButton.values[nButton];
    Widget text;
    Function pressed;
    TextStyle buttonStyle = TextStyle(
        inherit: false,
        color: Colors.red,
        fontSize: MediaQuery.of(context).size.width / 30);

    // set the specifics of the each button up
    switch (buttonToBeMade) {
      case HomeButton.photos:
        text = ListTile(
          leading: Icon(
            Icons.camera_alt_rounded,
            color: Colors.red,
            size: 35,
          ),
          title: Text(
            "Photos",
            style: buttonStyle,
            softWrap: false,
            overflow: TextOverflow.visible,
          ),
        );
        pressed = () async {
          const fallbackUrl = "https://www.facebook.com/goldiegatorsphotobooth";
          const fbProtocolUrl = "fb://page/563316737106569";
          try {
            bool launched = await launch(fbProtocolUrl, forceSafariVC: false);
            if (!launched) await launch(fallbackUrl, forceSafariVC: false);
          } catch (e) {
            await launch(fallbackUrl, forceSafariVC: false);
          }
        };
        break;
      case HomeButton.facebook:
        text = ListTile(
            leading: Image.asset(
              "assets/facebook.png",
              height: 35,
              width: 35,
            ),
            title: Text(
              "Facebook",
              style: buttonStyle,
              softWrap: false,
              overflow: TextOverflow.visible,
            ));
        pressed = () async {
          const url = "https://www.facebook.com/groups/242312270845000";
          if (await canLaunch(url)) {
            final bool nativeAppLaunchSucceeded = await launch(
              url,
              forceSafariVC: false,
              universalLinksOnly: true,
            );
            if (!nativeAppLaunchSucceeded) {
              await launch(
                url,
                forceSafariVC: true,
              );
            }
          }
        };
        break;
      case HomeButton.contacts:
        text = ListTile(
          leading: Icon(
            Icons.phone,
            color: Colors.red,
            size: 35,
          ),
          title: Text(
            "Contacts",
            style: buttonStyle,
            softWrap: false,
            overflow: TextOverflow.visible,
          ),
        );
        pressed = () {
          ContactPopup().openContactPop(context);
        };
        break;
      case HomeButton.dino:
        text = ListTile(
          leading: Icon(
            Icons.restaurant_rounded,
            color: Colors.red,
            size: 35,
          ),
          title: Text(
            "Dino",
            style: buttonStyle,
            softWrap: false,
            overflow: TextOverflow.visible,
          ),
        );
        pressed = () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DinoMeals()));
        };
        break;
      default:
        errorReporter.captureMessage("More than 4 tiles created");
    }

    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 4),
            borderRadius: BorderRadius.circular(12)),
        child: SizedBox.expand(
          child: OutlinedButton(
            child: text,
            onPressed: pressed,
            style: ButtonStyle(
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.white)),
          ),
        ),
      ),
    );
  }

  // Get the snapshot of announcements and create a list if it has data
  Widget createAnnouncements() {
    return StreamBuilder<List<AnnouncementModel>>(
      stream: announcementDBS.streamList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) _announcements = snapshot.data;
        return _createAnnouncementList();
      },
    );
  }

  // Create a list of listtiles containing the contents of each announcement
  Widget _createAnnouncementList() {
    if (_announcements != null && _announcements.isNotEmpty) {
      _announcements.sort((a, b) {
        return b.announcementDate
            .toString()
            .compareTo(a.announcementDate.toString());
      });
      return MediaQuery.removePadding(
        context: context,
        child: ListView(
          shrinkWrap: true,
          children: _announcements
              .map((announcement) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.8),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2.0),
                    child: ListTile(
                      dense: true,
                      title: Text(announcement.details.toString()),
                      subtitle: Text(((announcement.author.toString()) +
                          " - " +
                          formatDate(announcement.announcementDate))),
                      trailing: Visibility(
                        visible: (announcement.url.toString() != ""),
                        child: Icon(Icons.launch_rounded),
                      ),
                      onTap: () async {
                        String _url = announcement.url.toString();
                        if (_url != "") {
                          if (await canLaunch(_url))
                            await launch(_url);
                          else {
                            await InvalidURL().openInvalidUrl(context);
                          }
                        }
                      },
                      onLongPress: () async {
                        if (MenuOpen.userLogged) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddAnnouncePage(
                                  key: widget.key,
                                  note: announcement,
                                ),
                              ));
                        }
                      },
                    ),
                  ))
              .toList(),
        ),
        removeTop: true,
      );
    }
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          child: Text("No Announcements"),
          alignment: Alignment.center,
        )
      ],
    );
  }
}
