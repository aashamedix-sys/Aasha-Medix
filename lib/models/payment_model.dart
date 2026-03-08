enum PaymentStatus { pending, paid, failed, refunded }

class PaymentModel {
  final String id;
  final String? bookingId;
  final double amount;
  final String paymentMethod;
  final String? gatewayTransactionId;
  final PaymentStatus status;
  final DateTime? paidAt;

  PaymentModel({
    required this.id,
    this.bookingId,
    required this.amount,
    required this.paymentMethod,
    this.gatewayTransactionId,
    this.status = PaymentStatus.pending,
    this.paidAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      bookingId: json['booking_id'],
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'],
      gatewayTransactionId: json['gateway_transaction_id'],
      status: PaymentStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => PaymentStatus.pending),
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'amount': amount,
      'payment_method': paymentMethod,
      'gateway_transaction_id': gatewayTransactionId,
      'status': status.name,
      'paid_at': paidAt?.toIso8601String(),
    };
  }
}
