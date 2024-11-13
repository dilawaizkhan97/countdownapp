
import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(CountdownTimerApp());

class CountdownTimerApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return MaterialApp(
   title: 'Countdown Timer',
   home: CountdownTimerScreen(),
  );
 }
}

class CountdownTimerScreen extends StatefulWidget {
 @override
 _CountdownTimerScreenState createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
 Timer? _timer;
 Duration _timeRemaining = Duration(hours: 0, minutes: 1, seconds: 0); // Default time (1 minute)
 Duration _initialTime = Duration(hours: 0, minutes: 1, seconds: 0);
 bool _isRunning = false;

 // Start Timer
 void _startTimer() {
  if (_isRunning) return;

  setState(() {
   _isRunning = true;
  });

  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
   setState(() {
    if (_timeRemaining.inSeconds > 0) {
     _timeRemaining = _timeRemaining - Duration(seconds: 1);
    } else {
     _stopTimer();
    }
   });
  });
 }

 // Stop Timer
 void _stopTimer() {
  if (_timer != null) {
   _timer!.cancel();
  }
  setState(() {
   _isRunning = false;
  });
 }

 // Reset Timer
 void _resetTimer() {
  _stopTimer();
  setState(() {
   _timeRemaining = _initialTime;
  });
 }

 // Set the initial countdown duration
 void _setTime(Duration time) {
  setState(() {
   _initialTime = time;
   _timeRemaining = time;
  });
 }

 // Format Duration to HH:MM:SS
 String _formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String hours = twoDigits(duration.inHours);
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));
  return "$hours:$minutes:$seconds";
 }

 // Show Time Picker for User to Set Time
 Future<void> _pickTime(BuildContext context) async {
  final pickedTime = await showTimePicker(
   context: context,
   initialTime: TimeOfDay(
    hour: _initialTime.inHours,
    minute: _initialTime.inMinutes.remainder(60),
   ),
  );

  if (pickedTime != null) {
   Duration selectedDuration = Duration(hours: pickedTime.hour, minutes: pickedTime.minute);
   _setTime(selectedDuration);
  }
 }

 @override
 void dispose() {
  _timer?.cancel(); // Clean up the timer when the widget is disposed
  super.dispose();
 }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   backgroundColor: Colors.white,
   appBar: AppBar(
    title: Text('Countdown Timer'),
    backgroundColor: Colors.blueGrey.shade400,
    centerTitle: true,
   ),
   body: Container(
    decoration: BoxDecoration(
     gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.teal.shade200, Colors.pink.shade200], // Matching teal gradient
     ),
    ),
    child: Padding(
     padding: const EdgeInsets.all(20.0),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       // Timer display with smaller font size
       Text(
        _formatTime(_timeRemaining),
        style: TextStyle(
         fontSize: 60, // Reduced font size from 80 to 60
         fontWeight: FontWeight.bold,
         color: Colors.white,
         letterSpacing: 2.0,
        ),
       ),
       SizedBox(height: 30),

       // Button row with uniform, professional design
       Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         // Set Time Button with soft color
         ElevatedButton(
          onPressed: _isRunning ? null : () => _pickTime(context),
          style: ElevatedButton.styleFrom(
           backgroundColor: Colors.pink.shade400,
           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
           'Set Time',
           style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
           ),
          ),
         ),
         SizedBox(width: 20),

         // Start/Stop Button with distinct colors
         ElevatedButton(
          onPressed: _isRunning ? _stopTimer : _startTimer,
          style: ElevatedButton.styleFrom(
           backgroundColor: _isRunning ? Colors.redAccent : Colors.grey.shade400,
           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
           _isRunning ? 'Stop' : 'Start',
           style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
           ),
          ),
         ),
         SizedBox(width: 20),

         // Reset Button with calm, neutral color
         ElevatedButton(
          onPressed: _resetTimer,
          style: ElevatedButton.styleFrom(
           backgroundColor: Colors.pink.shade300,
           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
           'Reset',
           style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
           ),
          ),
         ),
        ],
       ),
      ],
     ),
    ),
   ),
  );
 }
}
