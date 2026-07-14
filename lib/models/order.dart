enum OrderType { printOnDemand, homePrint }

enum OrderStatus { pending, confirmed, printing, shipped, delivered }

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'بانتظار التأكيد';
      case OrderStatus.confirmed:
        return 'تم تأكيد الطلب';
      case OrderStatus.printing:
        return 'جاري الطباعة في المطبعة';
      case OrderStatus.shipped:
        return 'تم الشحن';
      case OrderStatus.delivered:
        return 'تم التوصيل';
    }
  }

  int get step {
    switch (this) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.printing:
        return 2;
      case OrderStatus.shipped:
        return 3;
      case OrderStatus.delivered:
        return 4;
    }
  }
}

class Order {
  final String id;
  final OrderType type;
  final String itemTitle;
  final DateTime date;
  final double price;
  final int quantity;
  final OrderStatus status;
  final String? address;

  const Order({
    required this.id,
    required this.type,
    required this.itemTitle,
    required this.date,
    required this.price,
    required this.quantity,
    required this.status,
    this.address,
  });

  Order copyWith({OrderStatus? status}) {
    return Order(
      id: id,
      type: type,
      itemTitle: itemTitle,
      date: date,
      price: price,
      quantity: quantity,
      status: status ?? this.status,
      address: address,
    );
  }
}
