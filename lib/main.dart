import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire_chat/bloc/chat/chat_bloc.dart';
import 'package:flutter_fire_chat/bloc/chat/chat_event.dart';
import 'package:flutter_fire_chat/bloc/home/home_bloc.dart';
import 'package:flutter_fire_chat/bloc/home/home_event.dart';
import 'package:flutter_fire_chat/bloc/login/login_bloc.dart';
import 'package:flutter_fire_chat/bloc/login/login_event.dart';
import 'package:flutter_fire_chat/bloc/register/register_bloc.dart';
import 'package:flutter_fire_chat/bloc/register/register_event.dart';
import 'package:flutter_fire_chat/bloc/search/search_bloc.dart';
import 'package:flutter_fire_chat/bloc/search/search_event.dart';
import 'package:flutter_fire_chat/containers/auth/auth_screen.dart';
import 'package:flutter_fire_chat/containers/chat/chat_screen.dart';
import 'package:flutter_fire_chat/containers/chat/home_screen.dart';
import 'package:flutter_fire_chat/containers/search/search_screen.dart';
import 'package:flutter_fire_chat/utils/util_routes.dart';

String initRoute = Route_Auth_Screen;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  User user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    initRoute = Route_Home_Screen;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc()..add(LoginInitAction()),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc()..add(RegisterInitAction()),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()..add(HomeInitAction()),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc()..add(ChatInitAction()),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc()..add(SearchInitAction()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Firebase Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
        ),
        initialRoute: initRoute,
        routes: {
          Route_Auth_Screen: (BuildContext context) => AuthScreen(),
          Route_Home_Screen: (BuildContext context) => HomeScreen(),
          Route_Chat_Screen: (BuildContext context) => ChatScreen(),
          Route_Search_Screen: (BuildContext context) => SearchScreen(),
        },
      ),
    );
  }
}
