import 'package:habit_tracker/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays){
  final today = DateTime.now();
  return completedDays.any((date) =>
  date.year == today.year &&
      date.month == today.month &&
      date.day == today.day
  );
}

// prepare the heat map dataset

Map<DateTime , int> prepHeaMapDataSet (List<Habit> habits){
  Map<DateTime, int > dataset= {};
  for (var habit in habits){
    for(var date in habit.completeDays){
      //normalize the data to avoid time mismatch
      final normalizeData = DateTime(date.year , date.month , date.day);
      // if the data already exist in the dataset , increment its counter
      if(dataset.containsKey(normalizeData)){
        dataset[ normalizeData] = dataset[normalizeData]!+1;

      }
      else{
        dataset[normalizeData] = 1;
      }
    }
  }
  return dataset;
}