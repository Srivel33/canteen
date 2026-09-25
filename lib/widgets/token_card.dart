import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/OrderModel.dart';
import '../theme/app_theme.dart';
import 'order_status_badge.dart';

class TokenCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;
  final VoidCallback? onAdvanceStatus;
  final bool showAdvanceButton;

  const TokenCard({
    super.key,
    required this.order,
    this.onTap,
    this.onAdvanceStatus,
    this.showAdvanceButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('hh:mm a').format(order.orderTime);
    final isReady = order.status.toLowerCase() == 'ready';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isReady ? AppTheme.statusReady : AppTheme.border,
            width: isReady ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isReady
                  ? AppTheme.statusReady.withOpacity(0.12)
                  : Colors.black.withOpacity(0.04),
              blurRadius: isReady ? 14 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Header: Token & Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isReady
                    ? AppTheme.statusReady.withOpacity(0.08)
                    : const Color(0xFFFAFAFA),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          order.tokenNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timeStr,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          if (order.userRollNumber.isNotEmpty)
                            Text(
                              order.userRollNumber,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  OrderStatusBadge(status: order.status),
                ],
              ),
            ),

            // Stepper indicator for active orders
            if (order.status != 'completed' && order.status != 'cancelled')
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: _buildProgressStepper(order.status),
              ),

            // Dashed Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: List.generate(
                  30,
                  (index) => Expanded(
                    child: Container(
                      color: index % 2 == 0 ? Colors.transparent : Colors.grey.shade300,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),

            // Items list summary
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${item.quantity}x',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '₹${item.subtotal.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )),
                  if (order.notes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Note: ${order.notes}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber.shade900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            order.paymentMethod == 'UPI'
                                ? Icons.qr_code_2_rounded
                                : order.paymentMethod == 'Wallet'
                                    ? Icons.account_balance_wallet_rounded
                                    : Icons.payments_rounded,
                            size: 16,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            order.paymentMethod,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Total: ₹${order.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  if (showAdvanceButton && onAdvanceStatus != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onAdvanceStatus,
                        icon: const Icon(Icons.fast_forward_rounded, size: 18),
                        label: Text(_getAdvanceButtonLabel(order.status)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getAdvanceButtonColor(order.status),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStepper(String status) {
    int activeStep = 0;
    if (status == 'preparing') activeStep = 1;
    if (status == 'ready') activeStep = 2;

    return Row(
      children: [
        _stepCircle(0, activeStep, 'Placed'),
        _stepLine(0, activeStep),
        _stepCircle(1, activeStep, 'Preparing'),
        _stepLine(1, activeStep),
        _stepCircle(2, activeStep, 'Ready'),
      ],
    );
  }

  Widget _stepCircle(int step, int currentStep, String label) {
    final isDone = currentStep >= step;
    final isCurrent = currentStep == step;
    final color = isDone
        ? (step == 2 ? AppTheme.statusReady : AppTheme.primary)
        : Colors.grey.shade300;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isDone ? color : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : Text(
                      '${step + 1}',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
              color: isCurrent ? AppTheme.textPrimary : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepLine(int step, int currentStep) {
    final isDone = currentStep > step;
    return Container(
      width: 30,
      height: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: isDone ? AppTheme.primary : Colors.grey.shade300,
    );
  }

  String _getAdvanceButtonLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Start Cooking (Preparing)';
      case 'preparing':
        return 'Food is Ready (Notify User)';
      case 'ready':
        return 'Mark Collected (Complete)';
      default:
        return 'Next Step';
    }
  }

  Color _getAdvanceButtonColor(String status) {
    switch (status) {
      case 'pending':
        return AppTheme.statusPreparing;
      case 'preparing':
        return AppTheme.statusReady;
      case 'ready':
        return AppTheme.statusCompleted;
      default:
        return AppTheme.primary;
    }
  }
}
