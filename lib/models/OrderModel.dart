class OrderModel {
  final String id;
  final String userId;
  final String userName;
  final String userRollNumber;
  final List<OrderItem> items;
  final double totalAmount;
  final String tokenNumber;
  final DateTime orderTime;
  final String status; // 'pending', 'preparing', 'ready', 'completed', 'cancelled'
  final String paymentMethod; // 'UPI', 'Wallet', 'Cash'
  final String notes;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userRollNumber = '',
    required this.items,
    required this.totalAmount,
    required this.tokenNumber,
    required this.orderTime,
    required this.status,
    this.paymentMethod = 'UPI',
    this.notes = '',
  });

  OrderModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userRollNumber,
    List<OrderItem>? items,
    double? totalAmount,
    String? tokenNumber,
    DateTime? orderTime,
    String? status,
    String? paymentMethod,
    String? notes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userRollNumber: userRollNumber ?? this.userRollNumber,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      orderTime: orderTime ?? this.orderTime,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userRollNumber: json['userRollNumber'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      tokenNumber: json['tokenNumber'] ?? '',
      orderTime: json['orderTime'] != null
          ? DateTime.parse(json['orderTime'])
          : DateTime.now(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? 'UPI',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userRollNumber': userRollNumber,
      'items': items.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'tokenNumber': tokenNumber,
      'orderTime': orderTime.toIso8601String(),
      'status': status,
      'paymentMethod': paymentMethod,
      'notes': notes,
    };
  }

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class OrderItem {
  final String menuItemId;
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menuItemId'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  double get subtotal => price * quantity;
}
