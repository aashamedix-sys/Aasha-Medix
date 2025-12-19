import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show Uint8List;
import '../widgets/prescription_upload_widget.dart';
import '../widgets/order_status_timeline.dart';
import '../l10n/app_localizations.dart';

class MedicineDeliveryScreen extends StatefulWidget {
  const MedicineDeliveryScreen({super.key});

  @override
  State<MedicineDeliveryScreen> createState() => _MedicineDeliveryScreenState();
}

class _MedicineDeliveryScreenState extends State<MedicineDeliveryScreen> {
  int _currentStep = 0;
  File? _prescriptionFile;
  Uint8List? _webPrescription;
  String? _loadedPrescriptionName;
  String _deliveryAddress = '';
  TimeOfDay? _preferredTime;
  bool _isOrderPlaced = false;
  String? _orderId;

  final List<String> _previousPrescriptions = [
    'Prescription from Dr. Sharma - 15 Dec 2024',
    'Prescription from Dr. Patel - 10 Dec 2024',
  ];

  void _onPrescriptionSelected(File? file, Uint8List? webImage) {
    setState(() {
      _prescriptionFile = file;
      _webPrescription = webImage;
    });
  }

  void _loadPreviousPrescription(String prescriptionName) {
    // Simulate loading a previous prescription
    // In a real app, this would fetch the prescription from storage/database
    setState(() {
      // Clear any current prescription
      _prescriptionFile = null;
      _webPrescription = null;
      // Set a flag or placeholder to indicate a previous prescription is loaded
      _loadedPrescriptionName = prescriptionName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Previous prescription "$prescriptionName" loaded successfully',
        ),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }

  void _showPreviousPrescriptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.previousPrescriptions),
          content: SizedBox(
            width: double.maxFinite,
            child: _previousPrescriptions.isEmpty
                ? Text(l10n.noPreviousPrescriptions)
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _previousPrescriptions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.description),
                        title: Text(_previousPrescriptions[index]),
                        onTap: () {
                          Navigator.of(context).pop();
                          // Load previous prescription
                          _loadPreviousPrescription(
                            _previousPrescriptions[index],
                          );
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }

  void _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _preferredTime = picked;
      });
    }
  }

  void _placeOrder() {
    if (_prescriptionFile == null &&
        _webPrescription == null &&
        _loadedPrescriptionName == null) {
      final l10n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(l10n.prescriptionRequired),
            content: Text(l10n.prescriptionRequiredMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.ok),
              ),
            ],
          );
        },
      );
      return;
    }

    if (_deliveryAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter delivery address')),
      );
      return;
    }

    // Generate order ID
    final orderId =
        'MED${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    setState(() {
      _isOrderPlaced = true;
      _orderId = orderId;
    });

    // Show success dialog
    _showOrderSuccessDialog();
  }

  void _showOrderSuccessDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.orderPlaced),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.orderId}: $_orderId'),
              const SizedBox(height: 8),
              Text('${l10n.estimatedDelivery}: 2-3 hours'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        OrderTrackingScreen(orderId: _orderId!),
                  ),
                );
              },
              child: Text(l10n.trackOrder),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isOrderPlaced && _orderId != null) {
      return OrderTrackingScreen(orderId: _orderId!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicineDelivery),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildStepIndicator(0, 'Prescription'),
                  _buildStepConnector(),
                  _buildStepIndicator(1, 'Address'),
                  _buildStepConnector(),
                  _buildStepIndicator(2, 'Confirm'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Step Content
            if (_currentStep == 0) ...[
              _buildPrescriptionStep(l10n),
            ] else if (_currentStep == 1) ...[
              _buildAddressStep(l10n),
            ] else if (_currentStep == 2) ...[
              _buildConfirmationStep(l10n),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(l10n),
    );
  }

  Widget _buildStepIndicator(int step, String title) {
    final isActive = step == _currentStep;
    final isCompleted = step < _currentStep;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? const Color(0xFF2E7D32)
                  : isActive
                  ? const Color(0xFF1976D2)
                  : Colors.grey[300],
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      '${step + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF1976D2) : Colors.grey[600],
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector() {
    return Container(width: 30, height: 2, color: Colors.grey[300]);
  }

  Widget _buildPrescriptionStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Prescription',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 16),
        PrescriptionUploadWidget(
          onImageSelected: _onPrescriptionSelected,
          loadedPrescriptionName: _loadedPrescriptionName,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showPreviousPrescriptionsDialog,
            icon: const Icon(Icons.history),
            label: Text(l10n.previousPrescriptions),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF2E7D32)),
              foregroundColor: const Color(0xFF2E7D32),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.deliveryAddress,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => setState(() => _deliveryAddress = value),
          decoration: InputDecoration(
            hintText: l10n.enterDeliveryAddress,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.location_on),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.preferredDeliveryTime,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showTimePicker,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 12),
                Text(
                  _preferredTime != null
                      ? _preferredTime!.format(context)
                      : l10n.selectTime,
                  style: TextStyle(
                    color: _preferredTime != null
                        ? Colors.black
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Service', l10n.medicineDelivery),
              _buildSummaryRow('Address', _deliveryAddress),
              _buildSummaryRow(
                'Time',
                _preferredTime?.format(context) ?? 'ASAP',
              ),
              _buildSummaryRow('Prescription', 'Uploaded'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep == 2
                  ? _placeOrder
                  : () => setState(() => _currentStep++),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(_currentStep == 2 ? l10n.confirmOrder : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.trackOrder),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l10n.orderId}: $orderId',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.estimatedDelivery}: 2-3 hours',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Order Status Timeline
            OrderStatusTimeline(currentStatus: OrderStatus.verified),
          ],
        ),
      ),
    );
  }
}
