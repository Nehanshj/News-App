import 'package:flutter/material.dart';

class TimeText extends StatelessWidget {
  TimeText(this.time);

  final Duration time;

  String timeString = " ";

  @override
  Widget build(BuildContext context) {
    //Checking for Days/Hours/Minutes
    if (time.inDays > 0)
      timeString = "${time.inDays} Days ago";
    else if (time.inHours > 0)
      timeString = "${time.inHours} Hours ago";
    else
      timeString = "${time.inMinutes} Minutes ago";

    return Text(timeString,
        style: TextStyle(
          color: Color(0xFFCED3DC),
        ));
  }
}
