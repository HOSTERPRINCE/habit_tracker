import 'package:isar/isar.dart';

part 'habit.g.dart';

@Collection()
class Habit{
  Id id = Isar.autoIncrement;

  late String name;

  //completed days
  List<DateTime> completeDays = [
    //datetime (year , month , day)
    //DateTime (2025, 2, 12),
  ];
}