import 'package:flutter/material.dart';

class NurseVisitDetailsScreen extends StatelessWidget {
  const NurseVisitDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visit Details')),
      body: const Center(
        child: Text('Placeholder for active visit details, tracking assigned nurse'),
      ),
    );
  }
}
