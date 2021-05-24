import 'package:flutter/material.dart';
import 'package:flutter_demo_ver/Manage/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_demo_ver/table_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(android: androidSetting);
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

  runApp(MyApp());
}

Future<void> showNotification() async{
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  var currentDateTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

  var android = AndroidNotificationDetails(
      'channelId', 'channelName', 'channelDescription');
  var platform = NotificationDetails(android: android);
  //await FlutterLocalNotificationsPlugin().show(0, 'title', 'body', platform);

  await FlutterLocalNotificationsPlugin().zonedSchedule(0,
      'hello',
      'hie',
      currentDateTime,
      platform,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true);

  currentDateTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

  await FlutterLocalNotificationsPlugin().zonedSchedule(1,
      'hello2',
      'hie2',
      currentDateTime,
      platform,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true);

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Baby Names',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor)
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var flutterLocalNotificationsPlugin;

  @override
  void initState(){
    super.initState();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
        children: <Widget>[
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(color: kPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(60)
                )
            ),
            child: Column(
                children: <Widget>[
                  Container(
                      child: Text(
                        '\n\n냉장고를 지켜라',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.04,
                            color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      )
                  ),
                  Container(
                      child: Text(
                        '\n방치되는 재료가 없도록',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.055,
                            color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      )
                  ),
                  Container(
                    child: SvgPicture.asset("assets/images/nangjang1.svg", height: size.height*0.5,),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height*0.05),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Tabless()));
                      },
                      child: Text("  다음  ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.04,
                            color: Colors.white
                        ),
                      ),
                    ),
                  )
                ]
            ),
          ),
        ]
    );
  }
}
