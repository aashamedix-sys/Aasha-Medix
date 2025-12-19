import 'package:flutter/foundation.dart';

enum PaymentMethod {
  payAtCenter,
  payLater,
  // onlinePayment, // Reserved for future implementation
}

class PaymentResult {
  final bool success;
  final String message;
  final String? transactionId;
  final Map<String, dynamic>? data;

  PaymentResult({
    required this.success,
    required this.message,
    this.transactionId,
    this.data,
  });
}

class PaymentService {
  // Payment is disabled by default for pilot safety
  static const bool paymentsEnabled = false;

  // Default payment method for pilot
  static const PaymentMethod defaultPaymentMethod = PaymentMethod.payAtCenter;

  // Get available payment methods (only safe ones for pilot)
  List<PaymentMethod> getAvailablePaymentMethods() {
    return [
      PaymentMethod.payAtCenter,
      PaymentMethod.payLater,
    ];
  }

  // Get display name for payment method
  String getPaymentMethodDisplayName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.payAtCenter:
        return 'Pay at Center';
      case PaymentMethod.payLater:
        return 'Pay Later';
      // case PaymentMethod.onlinePayment:
      //   return 'Online Payment';
      //   break;
    }
  }

  // Get description for payment method
  String getPaymentMethodDescription(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.payAtCenter:
        return 'Pay cash or card at the medical center when you visit';
      case PaymentMethod.payLater:
        return 'Complete payment after receiving services';
      // case PaymentMethod.onlinePayment:
      //   return 'Secure online payment through trusted gateway';
    }
  }

  // Process payment (currently just records intent for pilot)
  Future<PaymentResult> processPayment({
    required double amount,
    required String orderId,
    required String description,
    required PaymentMethod method,
    required String patientName,
    required String patientPhone,
  }) async {
    try {
      // For pilot safety, all payments are handled offline
      if (!paymentsEnabled) {
        return PaymentResult(
          success: true,
          message: 'Payment recorded. Please ${getPaymentMethodDisplayName(method).toLowerCase()} as per your selected option.',
          transactionId: 'PILOT-${DateTime.now().millisecondsSinceEpoch}',
          data: {
            'method': method.toString(),
            'amount': amount,
            'orderId': orderId,
            'description': description,
            'patientName': patientName,
            'patientPhone': patientPhone,
            'timestamp': DateTime.now().toIso8601String(),
            'status': 'pending_offline_payment',
          },
        );
      }

      // Future online payment implementation would go here
      // This is prepared for Phase-3 when payment gateway is integrated

      return PaymentResult(
        success: false,
        message: 'Online payments are not available in pilot mode.',
      );

    } catch (e) {
      debugPrint('Payment processing failed: $e');
      return PaymentResult(
        success: false,
        message: 'Unable to process payment request. Please try again or contact support.',
      );
    }
  }

  // Validate payment method for service
  bool isPaymentMethodValidForService(PaymentMethod method, String serviceType) {
    // All methods are valid for pilot, but payAtCenter is preferred for medical services
    return true;
  }

  // Get recommended payment method for service
  PaymentMethod getRecommendedPaymentMethod(String serviceType) {
    // For medical services, recommend pay at center for trust and verification
    return PaymentMethod.payAtCenter;
  }

  // Check if payment is required immediately
  bool isImmediatePaymentRequired(PaymentMethod method) {
    return method == PaymentMethod.payAtCenter;
  }

  // Get payment status message
  String getPaymentStatusMessage(PaymentMethod method, {bool isConfirmed = false}) {
    if (isConfirmed) {
      return 'Payment confirmed via ${getPaymentMethodDisplayName(method)}';
    }

    switch (method) {
      case PaymentMethod.payAtCenter:
        return 'Please pay at the medical center during your visit';
      case PaymentMethod.payLater:
        return 'Payment will be collected after service completion';
    }
  }

  void dispose() {
    // No cleanup needed for pilot implementation
  }
}
