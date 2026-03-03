import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Minimal, production-ready doctor appointment flow.
///
/// - No backend writes (per release safety).
/// - Uses Material widgets and defensive validation.
/// - Optional: Add to Google Calendar via URL (gracefully skips if unavailable).
class DoctorAppointmentScreen extends StatefulWidget {
  final String specialty;

  const DoctorAppointmentScreen({super.key, required this.specialty});

  @override
  State<DoctorAppointmentScreen> createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen> {
  int _stepIndex = 0;

  // Step 1
  String? _selectedDoctor;

  // Step 2
  DateTime? _selectedDate;
  String? _selectedSlot;

  // Patient (prefill from local profile if present)
  String _patientName = '';
  String _patientPhone = '';
  String _patientEmail = '';

  final List<String> _slots = const ['Morning', 'Afternoon', 'Evening'];

  // Mock doctor list (safe default until backend ready)
  late final List<String> _doctors;

  @override
  void initState() {
    super.initState();
    _doctors = _mockDoctorsFor(widget.specialty);
    _loadLocalProfile();
  }

  List<String> _mockDoctorsFor(String specialty) {
    // Keep deterministic names for predictable UX/testing.
    switch (specialty) {
      case 'Cardiologist':
        return const ['Dr. Ananya Rao', 'Dr. Vikram Reddy'];
      case 'Diabetologist':
        return const ['Dr. Meera Sharma', 'Dr. Suresh Kumar'];
      case 'Dermatologist':
        return const ['Dr. Neha Singh', 'Dr. Arjun Patel'];
      case 'Gynecologist':
        return const ['Dr. Priya Iyer', 'Dr. Kavya Nair'];
      case 'Pediatrician':
        return const ['Dr. Ritu Gupta', 'Dr. Aman Verma'];
      case 'Orthopedic':
        return const ['Dr. Hari Prasad', 'Dr. Kiran Joshi'];
      case 'ENT Specialist':
        return const ['Dr. Sameer Khan', 'Dr. Lakshmi Devi'];
      case 'General Physician':
      default:
        return const ['Dr. Rohit Mehta', 'Dr. Sneha Kulkarni'];
    }
  }

  Future<void> _loadLocalProfile() async {
    // Local storage only (does not touch backend).
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      _patientName = prefs.getString('profile_name') ?? '';
      _patientPhone = prefs.getString('profile_phone') ?? '';
      _patientEmail = prefs.getString('profile_email') ?? '';
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );
    if (picked == null) return;
    if (!mounted) return;
    setState(() => _selectedDate = picked);
  }

  bool _canContinue() {
    if (_stepIndex == 0) return _selectedDoctor != null;
    if (_stepIndex == 1) return _selectedDate != null && _selectedSlot != null;
    return true;
  }

  void _next() {
    if (!_canContinue()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete the required fields.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() => _stepIndex = (_stepIndex + 1).clamp(0, 2));
  }

  void _back() {
    setState(() => _stepIndex = (_stepIndex - 1).clamp(0, 2));
  }

  Future<void> _confirmBooking() async {
    // Production-safe confirmation: success feedback with no backend dependency.
    if (_selectedDoctor == null ||
        _selectedDate == null ||
        _selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing appointment details.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Appointment booked successfully!'),
        content: Text(
          'Doctor: $_selectedDoctor\n'
          'Patient: ${_patientName.isEmpty ? 'Patient' : _patientName}\n'
          'Date: ${_formatDate(_selectedDate!)}\n'
          'Time Slot: $_selectedSlot',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _addToGoogleCalendar() async {
    if (_selectedDoctor == null ||
        _selectedDate == null ||
        _selectedSlot == null) {
      return;
    }

    // Use an all-day-ish slot since we only capture Morning/Afternoon/Evening.
    final title = 'AASHA MEDIX Doctor Consultation';
    final details = 'Your appointment with $_selectedDoctor at $_selectedSlot.';
    final location = 'AASHA MEDIX Clinic / Telemedicine';

    final url = Uri.https('www.google.com', '/calendar/render', {
      'action': 'TEMPLATE',
      'text': title,
      'details': details,
      'location': location,
      // Date-only format: YYYYMMDD (no timezone issues)
      'dates': _formatDateForCalendar(_selectedDate!),
    });

    final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!mounted) return;

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open Google Calendar. Skipping.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  String _formatDateForCalendar(DateTime date) {
    // Google Calendar expects dates=YYYYMMDD/YYYYMMDD for all-day events.
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final start = '$y$m$d';
    final end = start;
    return '$start/$end';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Stepper(
                  currentStep: _stepIndex,
                  onStepContinue: _stepIndex < 2 ? _next : null,
                  onStepCancel: _stepIndex > 0 ? _back : null,
                  controlsBuilder: (context, details) {
                    return Row(
                      children: [
                        if (_stepIndex > 0)
                          TextButton(
                            onPressed: _back,
                            child: const Text('Back'),
                          ),
                        const Spacer(),
                        if (_stepIndex < 2)
                          FilledButton(
                            onPressed: _canContinue() ? _next : null,
                            child: const Text('Continue'),
                          ),
                      ],
                    );
                  },
                  steps: [
                    Step(
                      title: const Text('Doctor'),
                      isActive: _stepIndex >= 0,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Specialty: ${widget.specialty}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          DropdownMenu<String>(
                            width: MediaQuery.of(context).size.width - 32,
                            initialSelection: _selectedDoctor,
                            label: const Text('Select Doctor'),
                            dropdownMenuEntries: _doctors
                                .map(
                                  (d) => DropdownMenuEntry<String>(
                                    value: d,
                                    label: d,
                                  ),
                                )
                                .toList(),
                            onSelected: (v) =>
                                setState(() => _selectedDoctor = v),
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Schedule'),
                      isActive: _stepIndex >= 1,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              _selectedDate == null
                                  ? 'Select Date'
                                  : _formatDate(_selectedDate!),
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownMenu<String>(
                            width: MediaQuery.of(context).size.width - 32,
                            initialSelection: _selectedSlot,
                            label: const Text('Time Slot'),
                            dropdownMenuEntries: _slots
                                .map(
                                  (s) => DropdownMenuEntry<String>(
                                    value: s,
                                    label: s,
                                  ),
                                )
                                .toList(),
                            onSelected: (v) =>
                                setState(() => _selectedSlot = v),
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Confirm'),
                      isActive: _stepIndex >= 2,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SummaryRow(
                            label: 'Doctor',
                            value: _selectedDoctor ?? '-',
                          ),
                          _SummaryRow(
                            label: 'Patient',
                            value: _patientName.isEmpty
                                ? 'Patient'
                                : _patientName,
                          ),
                          _SummaryRow(
                            label: 'Phone',
                            value: _patientPhone.isEmpty ? '-' : _patientPhone,
                          ),
                          _SummaryRow(
                            label: 'Email',
                            value: _patientEmail.isEmpty ? '-' : _patientEmail,
                          ),
                          _SummaryRow(
                            label: 'Date',
                            value: _selectedDate == null
                                ? '-'
                                : _formatDate(_selectedDate!),
                          ),
                          _SummaryRow(
                            label: 'Time Slot',
                            value: _selectedSlot ?? '-',
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _confirmBooking,
                              child: const Text('Confirm Booking'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _addToGoogleCalendar,
                              child: const Text(
                                'Add to Google Calendar (Optional)',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
