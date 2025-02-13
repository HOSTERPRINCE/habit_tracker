import'package:flutter/material.dart';
import 'package:habit_tracker/models/database/habit_database.dart';
import 'package:habit_tracker/theme_provider.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchData();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=> ThemeProvider(),),
      ChangeNotifierProvider(create: (context)=> HabitDatabase(),),

    ],child: MyApp(),)
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Habit Tracker",
      home: Home_Screen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
