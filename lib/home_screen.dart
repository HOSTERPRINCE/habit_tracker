import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habittile.dart';
import 'package:habit_tracker/components/my_heat_map.dart';
import 'package:habit_tracker/models/database/habit_database.dart';
import 'package:habit_tracker/theme_provider.dart';
import 'package:habit_tracker/themes.dart';
import 'package:habit_tracker/utils/habit_util.dart';
import 'package:provider/provider.dart';

import 'components/mydrawer.dart';
import 'models/habit.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<HabitDatabase>(context, listen: false).readHabits();
    });
    super.initState();
  }

  TextEditingController textController = TextEditingController();

  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
                hintText: "Edit Habit",
                hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary)),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                String newHabitName = textController.text;
                context
                    .read<HabitDatabase>()
                    .updateHabitName(habit.id, newHabitName);
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text("Save"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text("Cancel"),
            ),
          ],
        ));
  }

  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
                hintText: "Create a new habit",
                hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary)),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                String newHabitName = textController.text;
                context.read<HabitDatabase>().addHabit(newHabitName);
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text("Save"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text("Cancel"),
            ),
          ],
        ));
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Are you sure you want to delete?"),
          backgroundColor: Theme.of(context).colorScheme.background,
          actions: [
            MaterialButton(
              onPressed: () {
                context.read<HabitDatabase>().deleteHabit(habit.id);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        ));
  }

  void CheckHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompleted(habit.id, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      body: Column(
        children: [
          _buildHeatMap(), // Heatmap on top
          Expanded(child: _buildHabitList()), // Listview in expanded
        ],
      ),
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: currentHabits.length,
        itemBuilder: (context, index) {
          final habit = currentHabits[index];
          // Check if the habit is completed
          bool isCompletedToday = isHabitCompletedToday(habit.completeDays);
          return Habit_Tile(
            isCompleted: isCompletedToday,
            text: habit.name,
            onChanged: (value) => CheckHabitOnOff(value, habit),
            editHabit: (context) {
              editHabitBox(habit);
            },
            deleteHabit: (context) => deleteHabitBox(habit),
          );
        });
  }

  Widget _buildHeatMap() {
    final habitDataBase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDataBase.currentHabits;
    return FutureBuilder<DateTime?>(
        future: habitDataBase.getfirstLaunchDate(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: MyHeatMap(
                startDate: snapshot.data!,
                dataSets: prepHeaMapDataSet(currentHabits), // Adjusted spacing
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
