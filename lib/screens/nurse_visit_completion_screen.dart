import 'package:flutter/material.dart';

class NurseVisitCompletionScreen extends StatelessWidget {
  const NurseVisitCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Visit Complete')),
      body: const Center(
        child: Text('Placeholder for nurse to add notes and finish visit'),
      ),
    );
  }
}
