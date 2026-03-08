import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';

class FeedbackModel {
  final String? id;
  final String patientId;
  final String? bookingId;
  final String serviceType;
  final int overallRating;
  final int serviceRating;
  final int staffRating;
  final int reportSpeedRating;
  final bool wouldRecommend;
  final String? comments;

  const FeedbackModel({
    this.id,
    required this.patientId,
    this.bookingId,
    required this.serviceType,
    required this.overallRating,
    required this.serviceRating,
    required this.staffRating,
    required this.reportSpeedRating,
    required this.wouldRecommend,
    this.comments,
  });

  Map<String, dynamic> toJson() => {
    'patient_id': patientId,
    'booking_id': bookingId,
    'service_type': serviceType,
    'overall_rating': overallRating,
    'service_rating': serviceRating,
    'staff_rating': staffRating,
    'report_speed_rating': reportSpeedRating,
    'would_recommend': wouldRecommend,
    'comments': comments,
  };
}

class FeedbackService {
  final SupabaseClient _supabase = SupabaseClientConfig.client;

  Future<void> submitFeedback(FeedbackModel feedback) async {
    await _supabase.from('patient_feedback').insert(feedback.toJson());
  }

  Future<bool> hasAlreadySubmitted(String bookingId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final response = await _supabase
        .from('patient_feedback')
        .select('id')
        .eq('booking_id', bookingId)
        .eq('patient_id', userId)
        .limit(1);

    return (response as List).isNotEmpty;
  }
}
