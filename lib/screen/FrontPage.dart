import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_material_app/Animation/CustomWidgets.dart';
import 'package:study_material_app/Attendance%20and%20Practice/graphPage.dart';
import 'package:study_material_app/Books/bookHome.dart';
import 'package:study_material_app/Maps/mapsHome.dart';
import 'package:study_material_app/Holiday%20Calendar/HolidayPage.dart';
import 'package:study_material_app/BIT_Bus/bus.dart';
import 'package:study_material_app/main.dart';
import 'package:study_material_app/screen/profilePage.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:in_app_update/in_app_update.dart';

class FrontPage extends StatefulWidget {
  static const String id = 'FrontPage';

  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  String name, semester, branch, email, roll;
  AppUpdateInfo _updateInfo;

  // void showNotification() {
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       "",
  //       "",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
  //               importance: Importance.high,
  //               color: Colors.blue,
  //               playSound: true,
  //               icon: '@mipmap/ic_launcher')));
  // }

  @override
  void initState() {
    checkForUpdate().whenComplete(() {});
    getValid().whenComplete(() {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: kPrimaryColorActive,
                    playSound: true,
                    icon: '@mipmap/ic_launcer')
                    ),
                    );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body)],
                ),
              );
            });
      }
    });
    super.initState();
  }

  Future<void> checkForUpdate() async {
    await InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    });

    if (_updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      print("Update Available....");
      await InAppUpdate.performImmediateUpdate();
    } else {
      print("No update Available....");
    }
  }

  Future<void> getValid() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    bool isFetched = sharedPref.getBool('isFetched');
    if (isFetched == false) {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('UserDatabase')
          .doc(uid)
          .get();

      if (doc.exists) {
        // this will check availability of document
        setState(() {
          branch = doc.get('Branch');
          semester = doc.get('Semester');
          roll = doc.get('RollNo');
          name = doc.get('Name');
          email = doc.get('Email');
          // branch = doc.data()['Branch'];
          // semester = doc.data()['Semester'];
          // roll = doc.data()['RollNo'];
          // name = doc.data()['Name'];
          // email = doc.data()['Email'];
        });

        sharedPref.setString('name', name);
        sharedPref.setString('semester', semester);
        sharedPref.setString('branch', branch);
        sharedPref.setString('roll', roll);
        sharedPref.setBool('isFetched', true);
      }
    }
  }

  void _openErp() async {
    await FlutterWebBrowser.openWebPage(
        url:
            'https://erp.bitmesra.ac.in/iitmsv4eGq0RuNHb0G5WbhLmTKLmTO7YBcJ4RHuXxCNPvuIw=?enc=EGbCGWnlHNJ/WdgJnKH8DA==',
        customTabsOptions: CustomTabsOptions(
          toolbarColor: kSecondColor,
          instantAppsEnabled: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Background(
              height1: 280.0,
              height2: 150.0,
              height3: 100.0,
              height4: 100.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ReuseCard(
                    gesture: () {
                      setState(() {
                        Navigator.pushNamed(context, BookHome.id);
                      });
                    },
                    childCard: IconArea(
                      ic: FontAwesomeIcons.bookReader,
                      s: 'Study Aid',
                    ),
                  ),
                ),
                Expanded(
                  child: ReuseCard(
                    gesture: () {
                      setState(() {
                        Navigator.pushNamed(context, GraphPage.id);
                      });
                    },
                    childCard: IconArea(
                      ic: FontAwesomeIcons.listAlt,
                      s: 'Attendance',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ReuseCard(
                    gesture: () {
                      setState(() {
                        _openErp();
                      });
                    },
                    childCard: IconArea(
                      ic: FontAwesomeIcons.laptop,
                      s: 'ERP',
                    ),
                  ),
                ),
                Expanded(
                  child: ReuseCard(
                    gesture: () {
                      setState(() {
                        Navigator.pushNamed(context, Bus.id);
                      });
                    },
                    childCard: IconArea(
                      ic: FontAwesomeIcons.bus,
                      s: 'BIT BUS',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ReuseCard(
                    gesture: () {
                      setState(() {
                        Navigator.pushNamed(context, HolidayPage.id);
                      });
                    },
                    childCard: IconArea(
                      ic: FontAwesomeIcons.calendarAlt,
                      s: 'Holiday Calendar',
                    ),
                  ),
                ),
                Expanded(
                  child: ReuseCard(
                    gesture: () {
                      setState(() {
                        Navigator.pushNamed(context, MapsHome.id);
                      });
                    },
                    childCard: IconArea(
                      ic: FontAwesomeIcons.mapMarkedAlt,
                      s: 'Maps',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
              width: double.infinity,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.pushNamed(context, ProfilePage.id);
          });
        },
        backgroundColor: kPrimaryColor,
        child: Icon(
          FontAwesomeIcons.user,
        ),
      ),
    );
  }
}
