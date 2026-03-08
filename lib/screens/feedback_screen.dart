import 'package:flutter/material.dart';
import '../services/feedback_service.dart';
import '../core/supabase_client.dart';
import '../utils/colors.dart';
import '../widgets/shared_ui_components.dart';

class FeedbackScreen extends StatefulWidget {
  final String bookingId;
  final String serviceType;

  const FeedbackScreen({
    super.key,
    required this.bookingId,
    required this.serviceType,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _feedbackService = FeedbackService();
  final _commentsController = TextEditingController();

  int _overallRating = 0;
  int _serviceRating = 0;
  int _staffRating = 0;
  int _reportSpeedRating = 0;
  bool _wouldRecommend = true;
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_overallRating == 0 || _serviceRating == 0 || _staffRating == 0) {
      context.showErrorSnackBar('Please rate all categories before submitting.');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final userId = SupabaseClientConfig.client.auth.currentUser!.id;
      await _feedbackService.submitFeedback(FeedbackModel(
        patientId: userId,
        bookingId: widget.bookingId,
        serviceType: widget.serviceType,
        overallRating: _overallRating,
        serviceRating: _serviceRating,
        staffRating: _staffRating,
        reportSpeedRating: _reportSpeedRating == 0 ? 3 : _reportSpeedRating,
        wouldRecommend: _wouldRecommend,
        comments: _commentsController.text.trim().isEmpty ? null : _commentsController.text.trim(),
      ));

      setState(() {
        _submitted = true;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) context.showErrorSnackBar('Failed to submit feedback. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Your Experience', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _submitted ? _ThankYouState() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return LoadingOverlay(
      isLoading: _isSubmitting,
      loadingMessage: 'Submitting your feedback...',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.health_and_safety, color: AppColors.primary, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('How was your ${widget.serviceType} experience?',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const Text('Your feedback helps us improve our services.',
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _RatingSection(
              label: '⭐ Overall Experience',
              value: _overallRating,
              onChanged: (v) => setState(() => _overallRating = v),
            ),
            _RatingSection(
              label: '🏥 Service Quality',
              value: _serviceRating,
              onChanged: (v) => setState(() => _serviceRating = v),
            ),
            _RatingSection(
              label: '👩‍⚕️ Staff Professionalism',
              value: _staffRating,
              onChanged: (v) => setState(() => _staffRating = v),
            ),
            _RatingSection(
              label: '⏱️ Report Turnaround Speed',
              value: _reportSpeedRating,
              onChanged: (v) => setState(() => _reportSpeedRating = v),
              optional: true,
            ),

            const SizedBox(height: 8),
            const Text('Would you recommend AASHA MEDIX?',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                _RecommendChip(
                  label: '👍 Yes',
                  selected: _wouldRecommend,
                  onTap: () => setState(() => _wouldRecommend = true),
                ),
                const SizedBox(width: 12),
                _RecommendChip(
                  label: '👎 No',
                  selected: !_wouldRecommend,
                  onTap: () => setState(() => _wouldRecommend = false),
                ),
              ],
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _commentsController,
              decoration: const InputDecoration(
                labelText: 'Additional Comments (optional)',
                hintText: 'What could we do better?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 300,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submit,
                child: const Text('Submit Feedback',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThankYouState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, size: 52, color: Colors.green),
            ),
            const SizedBox(height: 24),
            const Text('Thank You!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'Your feedback has been recorded.\nIt helps us serve you better.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingSection extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final bool optional;

  const _RatingSection({
    required this.label,
    required this.value,
    required this.onChanged,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            optional ? '$label (optional)' : label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) {
              final star = i + 1;
              return GestureDetector(
                onTap: () => onChanged(star),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    star <= value ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 36,
                    color: star <= value ? Colors.amber : Colors.grey[400],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _RecommendChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RecommendChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Text(label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }
}
