import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/arabic_helpers.dart';
import '../widgets/common_widgets.dart';
import 'order_tracking_screen.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<AppState>().orders;

    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: orders.isEmpty
          ? const EmptyState(icon: Icons.receipt_long_outlined, message: 'لا توجد طلبات بعد')
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final o = orders[i];
                final isHome = o.type == OrderType.homePrint;
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: isHome
                      ? null
                      : () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: o))),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (isHome ? AppColors.teal : AppColors.secondary).withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isHome ? Icons.print_outlined : Icons.local_shipping_outlined,
                            color: isHome ? AppColors.teal : AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(o.itemTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                              const SizedBox(height: 3),
                              Text(
                                '${formatArabicDate(o.date)} · ${o.status.label}',
                                style: TextStyle(fontSize: 11.5, color: AppColors.textMuted.withValues(alpha: 0.9)),
                              ),
                            ],
                          ),
                        ),
                        if (!isHome) const Icon(Icons.chevron_left, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
