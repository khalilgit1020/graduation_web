import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/bloc/craft_states.dart';
import 'package:my_graduation/bloc/home_cubit.dart';
import 'package:my_graduation/helpers/cache_helper.dart';
import 'package:my_graduation/screens/auth/login_screen.dart';
import 'package:my_graduation/screens/auth/register_screen.dart';
import 'package:my_graduation/screens/bottom_bar/feed_screen.dart';
import 'package:my_graduation/screens/bottom_bar/home_screen.dart';
import 'package:my_graduation/screens/onBoarding.dart';

import 'bloc/bloc_observer.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  //customErrorScreen();
  await Firebase.initializeApp(

    options: const FirebaseOptions(
      apiKey: "AIzaSyBGO8blEJP-wXWMk9xkAGq3fkfTlpRugLw",
      authDomain: "graduation-11c9d.firebaseapp.com",
      projectId: "graduation-11c9d",
      storageBucket: "graduation-11c9d.appspot.com",
      messagingSenderId: "1012126560609",
      appId: "1:1012126560609:web:5f31294431337f22335520",
      measurementId: "G-26WW15KRSM",
    ),
  );

  await CacheHelper.init();

  Widget widget;
  uId = CacheHelper.getData(key: 'uId');

  if (uId != null) {
    widget = const HomeScreen();
  } else {
    widget = const OnBoardingScreen();
  }

  BlocOverrides.runZoned(
    () {
      // Use cubits...
      runApp(MyApp(
        widget: widget,
      ));
    },
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  Widget widget;

  MyApp({required this.widget});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CraftHomeCubit()
        ..getUserData()
       // ..getMyWorkImages()
       // ..getNotifications()
        ..checkIfLocationPermissionAllowed(),
      child: BlocConsumer<CraftHomeCubit, CraftStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'my graduation project',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routes: {
              CraftLoginScreen.route : (context) => CraftLoginScreen(),
              CraftRegisterScreen.route : (context) => CraftRegisterScreen(),
              FeedScreen.route : (context) => FeedScreen(),
              HomeScreen.route : (context) =>const HomeScreen(),

            },
            home: FutureBuilder(
              future: _initialization,
              builder: (context, snapShot) {
                if (snapShot.hasError) {
                  print('somethingWrong');
                }

                if (snapShot.connectionState == ConnectionState.done) {
                  return SafeArea(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: widget,
                    ),
                  );
                }

                return CircularProgressIndicator();
              },
            ),
          );
        },
      ),
    );
  }
}
