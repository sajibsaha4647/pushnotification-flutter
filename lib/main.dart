import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.notification!.title}');
}

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  FirebaseMessaging messaging = FirebaseMessaging.instance;



  @override
  void initState() {
    FirebaseMessaging.instance.getInitialMessage();

    //controlling in forground
    FirebaseMessaging.onMessage.listen((event) { 
        if(event.notification !=  null){
          print("handle in forground");
            print(event.notification!.title);
            print(event.notification!.body);
        }
    });

    // controlling when app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if(event.notification !=  null){
        print("handle in background");
        print(event.notification!.title);
        print(event.notification!.body);
      }
    });

    //controlling when app is off or terminated
    FirebaseMessaging.instance.getInitialMessage().then((value) => {
      if(value != null){
        print("handle in terminated"),
        print(value.notification!.title),
        print(value.notification!.body)
      }
    });



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: Scaffold(
           appBar: AppBar(
             title: Text("Push Notification"),
           ),
      )),
    );
  }
}
