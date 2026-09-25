import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;
  final bool isLarge;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
        bg = AppTheme.statusPending.withOpacity(0.12);
        fg = AppTheme.statusPending;
        icon = Icons.hourglass_top_rounded;
        label = 'Order Placed';
        break;
      case 'preparing':
        bg = AppTheme.statusPreparing.withOpacity(0.12);
        fg = AppTheme.statusPreparing;
        icon = Icons.soup_kitchen_rounded;
        label = 'Kitchen Preparing';
        break;
      case 'ready':
        bg = AppTheme.statusReady.withOpacity(0.15);
        fg = AppTheme.statusReady;
        icon = Icons.check_circle_rounded;
        label = 'Ready for Pickup!';
        break;
      case 'completed':
        bg = AppTheme.statusCompleted.withOpacity(0.12);
        fg = AppTheme.statusCompleted;
        icon = Icons.done_all_rounded;
        label = 'Completed';
        break;
      case 'cancelled':
        bg = AppTheme.statusCancelled.withOpacity(0.12);
        fg = AppTheme.statusCancelled;
        icon = Icons.cancel_rounded;
        label = 'Cancelled';
        break;
      default:
        bg = Colors.grey.withOpacity(0.12);
        fg = Colors.grey.shade700;
        icon = Icons.info_outline;
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 14 : 10,
        vertical: isLarge ? 8 : 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isLarge ? 18 : 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w700,
              fontSize: isLarge ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }
}
