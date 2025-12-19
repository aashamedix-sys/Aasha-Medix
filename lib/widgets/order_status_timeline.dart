import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

enum OrderStatus { uploaded, verified, packed, outForDelivery, delivered }

class OrderStatusTimeline extends StatelessWidget {
  final OrderStatus currentStatus;

  const OrderStatusTimeline({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statuses = [
      OrderStatus.uploaded,
      OrderStatus.verified,
      OrderStatus.packed,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];

    return Container(
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
            l10n.orderStatus,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 16),
          ...statuses.map((status) => _buildStatusItem(context, status, l10n)),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    OrderStatus status,
    AppLocalizations l10n,
  ) {
    final isCompleted = status.index <= currentStatus.index;
    final isCurrent = status == currentStatus;

    return Row(
      children: [
        // Status Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? const Color(0xFF2E7D32) : Colors.grey[300],
            border: isCurrent
                ? Border.all(color: const Color(0xFF2E7D32), width: 2)
                : null,
          ),
          child: Icon(
            _getStatusIcon(status),
            color: isCompleted ? Colors.white : Colors.grey[500],
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        // Status Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getStatusText(status, l10n),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCompleted
                      ? const Color(0xFF1B5E20)
                      : Colors.grey[600],
                ),
              ),
              if (isCurrent) ...[
                const SizedBox(height: 2),
                Text(
                  'In Progress',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF2E7D32),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Completion Indicator
        if (isCompleted)
          Icon(Icons.check_circle, color: const Color(0xFF2E7D32), size: 20),
      ],
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.uploaded:
        return Icons.upload_file;
      case OrderStatus.verified:
        return Icons.verified;
      case OrderStatus.packed:
        return Icons.inventory_2;
      case OrderStatus.outForDelivery:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check_circle;
    }
  }

  String _getStatusText(OrderStatus status, AppLocalizations l10n) {
    switch (status) {
      case OrderStatus.uploaded:
        return l10n.uploaded;
      case OrderStatus.verified:
        return l10n.verified;
      case OrderStatus.packed:
        return l10n.packed;
      case OrderStatus.outForDelivery:
        return l10n.outForDelivery;
      case OrderStatus.delivered:
        return l10n.delivered;
    }
  }
}
