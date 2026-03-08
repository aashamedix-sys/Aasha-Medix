import 'package:flutter/material.dart';

class NursingServicesScreen extends StatelessWidget {
  const NursingServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Nursing Services')),
      body: const Center(
        child: Text('Placeholder for Nursing Services (IV, Dressing, etc.)'),
      ),
    );
  }
}
