import 'package:flutter/material.dart';
import 'doctor_appointment_screen.dart';

class DoctorConsultScreen extends StatefulWidget {
  const DoctorConsultScreen({super.key});

  @override
  State<DoctorConsultScreen> createState() => _DoctorConsultScreenState();
}

class _DoctorConsultScreenState extends State<DoctorConsultScreen> {
  String? _selectedConsultationType;

  final List<Map<String, dynamic>> _consultationTypes = [
    {
      'type': 'General Physician',
      'icon': Icons.medical_services,
      'description':
          'General health checkup, common illnesses, preventive care',
      'fee': '₹500',
    },
    {
      'type': 'Cardiologist',
      'icon': Icons.favorite,
      'description': 'Heart conditions, blood pressure, cardiac health',
      'fee': '₹800',
    },
    {
      'type': 'Diabetologist',
      'icon': Icons.bloodtype,
      'description':
          'Diabetes management, blood sugar control, lifestyle advice',
      'fee': '₹700',
    },
    {
      'type': 'Dermatologist',
      'icon': Icons.face,
      'description': 'Skin conditions, allergies, cosmetic dermatology',
      'fee': '₹600',
    },
    {
      'type': 'Gynecologist',
      'icon': Icons.pregnant_woman,
      'description': 'Women\'s health, pregnancy care, reproductive health',
      'fee': '₹750',
    },
    {
      'type': 'Pediatrician',
      'icon': Icons.child_care,
      'description': 'Child health, growth monitoring, vaccinations',
      'fee': '₹550',
    },
    {
      'type': 'Orthopedic',
      'icon': Icons.accessibility,
      'description': 'Bone and joint problems, sports injuries, arthritis',
      'fee': '₹700',
    },
    {
      'type': 'ENT Specialist',
      'icon': Icons.hearing,
      'description': 'Ear, nose, throat conditions, hearing issues',
      'fee': '₹600',
    },
  ];

  void _bookConsultation() {
    if (_selectedConsultationType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a consultation type'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Navigate to real appointment scheduling flow (no legacy screens).
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DoctorAppointmentScreen(specialty: _selectedConsultationType!),
      ),
    ).then((_) {
      // Clear selection after returning from summary screen
      setState(() {
        _selectedConsultationType = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Consultation'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFE8F5E8),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Online Consultation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Connect with experienced doctors from the comfort of your home',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _consultationTypes.length,
              itemBuilder: (context, index) {
                final consultation = _consultationTypes[index];
                final isSelected =
                    _selectedConsultationType == consultation['type'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF2E7D32)
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedConsultationType = consultation['type'];
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0x332E7D32)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              consultation['icon'],
                              color: isSelected
                                  ? const Color(0xFF2E7D32)
                                  : Colors.grey,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  consultation['type'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? const Color(0xFF2E7D32)
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  consultation['description'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Consultation Fee: ${consultation['fee']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF2E7D32),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _bookConsultation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Book Consultation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
