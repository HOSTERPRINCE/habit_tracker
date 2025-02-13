import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier{
  static late Isar isar;
  //initializing the database
  static Future<void> initialize() async{
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([HabitSchema,AppSettingsSchema], directory: dir.path);


  }
  //saving the first date when the app was opened
  Future<void> saveFirstLaunchData() async {
    final existingSettings= await isar.appSettings.where().findFirst();
    if(existingSettings == null){
      final settings=AppSettings()..firstLaunchDate=DateTime.now();
      await isar.writeTxn(()=> isar.appSettings.put(settings));
    }
  }
  //getting the first launch date
  Future<DateTime?> getfirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  final List<Habit> currentHabits=[];
  //creating a new habit in database
  Future<void> addHabit(String habitName) async{
    //create a new habit
    final newHabit = Habit();
    newHabit.name = habitName;

    //write to database
    await isar.writeTxn(()=>isar.habits.put(newHabit));
    //read from the data base
    readHabits();
    notifyListeners();
  }
  //reading the habits for changes
  Future<void> readHabits() async{
    List<Habit> fetchedHabits= await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);
    notifyListeners();
  }
  //update the habit completed or pending
  Future<void> updateHabitCompleted(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);

        if (isCompleted) {
          if (!habit.completeDays.contains(todayDate)) {
            habit.completeDays.add(todayDate);
          }
        } else {
          habit.completeDays.removeWhere((date) =>
          date.year == today.year &&
              date.month == today.month &&
              date.day == today.day);
        }

        await isar.habits.put(habit);
      });

      readHabits();

    }
  }

  Future<void> updateHabitName(int id , String newName) async{
    final habit = await isar.habits.get(id);

    if(habit !=null){
      await isar.writeTxn(() async{
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    readHabits();

  }
  Future<void> deleteHabit(int id ) async{
    await isar.writeTxn(() async{
      await isar.habits.delete(id);
    });
    readHabits();
  }

}