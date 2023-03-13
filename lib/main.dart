//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:lab4/constants/routes.dart';
import 'package:lab4/services/auth/auth_service.dart';
import 'package:lab4/views/colloquiums.dart';
import 'package:lab4/views/login_view.dart';
import 'package:lab4/views/register_view.dart';
import 'package:lab4/views/verify_email_view.dart';

import 'calendar.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(       
//         primarySwatch: Colors.blue,
//       ),
//       home: const Calendar(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {

//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold();
//   }
// }


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  // AwesomeNotifications().initialize(
  //   'resource://drawable/res_notification_app_icon',
  //   [
  //     NotificationChannel(
  //       channelKey: 'basic_channel', 
  //       channelName: 'Basic Notifications', 
  //       defaultColor: Colors.teal,
  //       importance: NotificationImportance.High,
  //       channelShowBadge: true, channelDescription: '',
  //     )
  //   ]
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute:(context) => const Calendar(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        colloquimsRoute: (context) => const Colloquiums(),
        calendarRoute: (context) => const Calendar(),
      },
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:

            final user  = AuthService.firebase().currentUser;
            if (user != null){
              if (user.isEmailVerified) {
                return const Calendar();
              }
              else {
                return const VerifyEmailView();
              }
            } 
            else {
              return const LoginView();
            }

            default:
              return const CircularProgressIndicator();
          }
        },        
      );
  }
}
