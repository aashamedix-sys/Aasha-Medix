import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/payment_model.dart';
import 'dart:convert';

class PaymentService {
  final SupabaseClient _supabase = SupabaseClientConfig.client;

  Future<String> createRazorpayOrder(String bookingId) async {
    // Calling a Supabase Edge Function to securely generate the Razorpay Order ID
    final response = await _supabase.functions.invoke(
      'create-razorpay-order',
      body: {'booking_id': bookingId},
    );

    if (response.status == 200) {
      final data = response.data;
      return data['order_id'];
    } else {
      throw Exception('Failed to create Razorpay Order');
    }
  }

  Future<void> verifyPayment(String paymentId, String orderId, String signature) async {
    // Calling Edge Function to securely verify signature on the server side
    final response = await _supabase.functions.invoke(
      'verify-razorpay-payment',
      body: {
        'razorpay_payment_id': paymentId,
        'razorpay_order_id': orderId,
        'razorpay_signature': signature
      },
    );

    if (response.status != 200 || response.data['success'] != true) {
      throw Exception('Payment Verification Failed');
    }
  }
}
