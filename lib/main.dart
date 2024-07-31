import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanber_flutter_mini_project_3/firebase_options.dart';
import 'package:sanber_flutter_mini_project_3/helper/cloud_message_helper.dart';
import 'package:sanber_flutter_mini_project_3/helper/notification_helper.dart';
import 'package:sanber_flutter_mini_project_3/logic/auth_bloc/auth_bloc.dart';
import 'package:sanber_flutter_mini_project_3/logic/cart_bloc/cart_bloc.dart';
import 'package:sanber_flutter_mini_project_3/logic/product_bloc/product_bloc.dart';
import 'package:sanber_flutter_mini_project_3/ui/screens/login_screen.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

    await NotificationHelper().init();
    

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CloudMessageHelper().init();

  


  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBloc(),
      ),
      BlocProvider(
        create: (context) => ProductBloc(),
      ),
      BlocProvider(
        create: (context) => CartBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Project 3 - Raihan Rabbani',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
