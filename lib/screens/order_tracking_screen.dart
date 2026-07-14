import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/arabic_helpers.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({super.key, required this.order});

  static const _stages = [
    (OrderStatus.pending, Icons.hourglass_top, 'بانتظار التأكيد'),
    (OrderStatus.confirmed, Icons.check_circle_outline, 'تم تأكيد الطلب'),
    (OrderStatus.printing, Icons.print_outlined, 'جاري الطباعة'),
    (OrderStatus.shipped, Icons.local_shipping_outlined, 'تم الشحن'),
    (OrderStatus.delivered, Icons.home_outlined, 'تم التوصيل'),
  ];

  @override
  Widget build(BuildContext context) {
    // Watch AppState so the tracker live-updates as the mock backend advances the order.
    final state = context.watch<AppState>();
    final liveOrder = state.orders.firstWhere((o) => o.id == order.id, orElse: () => order);
    final currentStep = liveOrder.status.step;

    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الطلب')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(liveOrder.id, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Text(liveOrder.itemTitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(liveOrder.status.label, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 26),
          ...List.generate(_stages.length, (i) {
            final (status, icon, label) = _stages[i];
            final done = i <= currentStep;
            final isLast = i == _stages.length - 1;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: done ? AppColors.success : AppColors.textMuted.withValues(alpha: 0.15),
                        ),
                        alignment: Alignment.center,
                        child: Icon(icon, color: done ? Colors.white : AppColors.textMuted, size: 18),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2.4,
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            color: i < currentStep ? AppColors.success.withValues(alpha: 0.5) : AppColors.textMuted.withValues(alpha: 0.15),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 26, top: 8),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontWeight: done ? FontWeight.bold : FontWeight.normal,
                          color: done ? AppColors.textDark : AppColors.textMuted,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow('تاريخ الطلب', formatArabicDate(liveOrder.date)),
                _infoRow('عدد النسخ', '${liveOrder.quantity}'),
                if (liveOrder.address != null) _infoRow('عنوان التوصيل', liveOrder.address!),
                _infoRow('الإجمالي', '${liveOrder.price.toStringAsFixed(2)} د.إ'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.9), fontSize: 12.5)),
          Flexible(child: Text(value, textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5))),
        ],
      ),
    );
  }
}
