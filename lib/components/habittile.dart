import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Habit_Tile extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;
  Function(BuildContext)? deleteHabit;
  final void Function(BuildContext?)? editHabit;
  Habit_Tile({super.key, required this.isCompleted, required this.text,required this.onChanged,required this.editHabit , required this.deleteHabit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(onPressed: editHabit,
          backgroundColor: Colors.grey.shade800,
          icon: Icons.settings,
          borderRadius: BorderRadius.circular(8),),
          SlidableAction(onPressed: deleteHabit,
            backgroundColor: Colors.red,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(8),)
        ]),
        child: GestureDetector(
          onTap: (){
            if(onChanged !=null){
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isCompleted ? Colors.green : Theme.of(context).colorScheme.secondary,

            ),
            padding: EdgeInsets.all(12),
            child: ListTile(
                tileColor: Colors.transparent,
              title: Text(text,style: TextStyle(color: isCompleted ? Colors.white : Theme.of(context).colorScheme.inversePrimary),),
              leading: Checkbox(value: isCompleted, onChanged: onChanged,activeColor: Colors.green,),
            ),
          ),
        ),
      ),
    );
  }
}
