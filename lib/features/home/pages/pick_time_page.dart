import 'package:assesment_flutter/common_widgets/background_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PickTimePage extends StatefulWidget {
  const PickTimePage({super.key});

  @override
  State<PickTimePage> createState() => _PickTimePageState();
}

class _PickTimePageState extends State<PickTimePage> {
  DateTime? picked;

  Future<void> _pickDateTime() async {
    final today = DateTime.now();

    if (!mounted) return;
    final date = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null || !mounted) return;

    setState(() {
      picked = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    final label = picked == null
        ? 'Pick Date & Time'
        : DateFormat('EEE d MMM yyyy, h:mm a').format(picked!);

    return Scaffold(
      appBar: AppBar(title: const Text('Set Alarm', 
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),),
       backgroundColor: Color.fromRGBO(11, 0, 36, 1),
      ),
      body: BackgroundColor(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(onPressed: _pickDateTime, child: Text(label)),
              const SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: picked == null
                    ? null
                    : () => Navigator.pop(context, picked),
                child: const Text('Save Alarm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
