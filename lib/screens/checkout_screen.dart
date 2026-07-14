import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../models/project_idea.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../services/pdf_service.dart';
import '../widgets/common_widgets.dart';
import 'order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final OrderType orderType;
  final ProjectIdea projectIdea;

  const CheckoutScreen({super.key, required this.orderType, required this.projectIdea});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  int _quantity = 1;
  String _paperFinish = 'ورق عادي';
  bool _processing = false;

  static const double _basePrice = 8.0; // AED per printed worksheet, mock pricing

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleHomePrint() async {
    setState(() => _processing = true);
    final state = context.read<AppState>();
    final childName = state.selectedProfile?.name ?? 'الطالب';
    try {
      final bytes = await PdfService.buildProjectWorksheet(idea: widget.projectIdea, childName: childName);
      await PdfService.printDocument(bytes, widget.projectIdea.title);
      await state.placeOrder(type: OrderType.homePrint, itemTitle: widget.projectIdea.title, price: 0, quantity: _quantity);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال الملف إلى الطابعة بنجاح 🖨️'), backgroundColor: AppColors.success),
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _handlePrintOnDemand() async {
    if (_addressController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى إدخال العنوان ورقم الهاتف')));
      return;
    }
    setState(() => _processing = true);
    final state = context.read<AppState>();
    final order = await state.placeOrder(
      type: OrderType.printOnDemand,
      itemTitle: widget.projectIdea.title,
      price: _basePrice,
      quantity: _quantity,
      address: _addressController.text.trim(),
    );
    if (mounted) {
      setState(() => _processing = false);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHome = widget.orderType == OrderType.homePrint;
    return Scaffold(
      appBar: AppBar(title: Text(isHome ? 'طباعة منزلية' : 'اطلب من المطبعة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
            child: Row(
              children: [
                Icon(isHome ? Icons.print_outlined : Icons.local_shipping_outlined, color: AppColors.primary, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.projectIdea.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                      const SizedBox(height: 4),
                      Text(
                        isHome
                            ? 'سيتم توليد ملف PDF جاهز وإرساله مباشرة لطابعتك المنزلية.'
                            : 'سيتم طباعة وتغليف المشروع وشحنه إلى عنوانك عبر شبكة المطابع الشريكة.',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.9)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('عدد النسخ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Row(
                children: [
                  IconButton(
                    onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$_quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => setState(() => _quantity++),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ],
          ),
          if (!isHome) ...[
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _paperFinish,
              decoration: const InputDecoration(labelText: 'نوع الورق'),
              items: ['ورق عادي', 'ورق مقوى فاخر', 'ورق لامع مقاوم للماء']
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (v) => setState(() => _paperFinish = v ?? _paperFinish),
            ),
            const SizedBox(height: 14),
            TextField(controller: _addressController, decoration: const InputDecoration(labelText: 'عنوان التوصيل')),
            const SizedBox(height: 14),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'رقم الهاتف'),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الإجمالي المتوقع', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    '${(_basePrice * _quantity).toStringAsFixed(2)} د.إ',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 26),
          GradientButton(
            label: isHome ? 'بدء الطباعة الآن' : 'تأكيد الطلب والشحن',
            icon: isHome ? Icons.print : Icons.check_circle_outline,
            colors: isHome ? const [AppColors.teal, Color(0xFF0FA595)] : const [AppColors.secondary, Color(0xFFE8621F)],
            loading: _processing,
            onTap: isHome ? _handleHomePrint : _handlePrintOnDemand,
          ),
          const SizedBox(height: 14),
          const AdBannerPlaceholder(),
        ],
      ),
    );
  }
}
