import 'package:flutter/material.dart';
import '../models/OrderModel.dart';

class OrderState extends ChangeNotifier {
  int _tokenCounter = 104;

  final List<OrderModel> _orders = [
    OrderModel(
      id: 'ord_101',
      userId: 'usr_student_1',
      userName: 'Aarav Sharma',
      userRollNumber: '21CS042',
      items: [
        OrderItem(menuItemId: 'm1', name: 'Crispy Masala Dosa', quantity: 1, price: 55.0),
        OrderItem(menuItemId: 'm12', name: 'South Indian Filter Coffee', quantity: 1, price: 20.0),
      ],
      totalAmount: 78.75,
      tokenNumber: '#T-101',
      orderTime: DateTime.now().subtract(const Duration(minutes: 18)),
      status: 'ready', // Ready for pickup!
      paymentMethod: 'UPI',
      notes: 'Extra sambar please',
    ),
    OrderModel(
      id: 'ord_102',
      userId: 'usr_staff_1',
      userName: 'Dr. Priya Raman',
      userRollNumber: 'FAC-804',
      items: [
        OrderItem(menuItemId: 'm5', name: 'Special Veg Thali / Meals', quantity: 1, price: 90.0),
      ],
      totalAmount: 94.50,
      tokenNumber: '#T-102',
      orderTime: DateTime.now().subtract(const Duration(minutes: 10)),
      status: 'preparing', // Kitchen is preparing
      paymentMethod: 'Wallet',
      notes: 'Less spicy',
    ),
    OrderModel(
      id: 'ord_103',
      userId: 'usr_student_1',
      userName: 'Aarav Sharma',
      userRollNumber: '21CS042',
      items: [
        OrderItem(menuItemId: 'm9', name: 'Crispy Samosa (2 Pcs)', quantity: 1, price: 30.0),
        OrderItem(menuItemId: 'm13', name: 'Kullad Masala Chai', quantity: 1, price: 15.0),
      ],
      totalAmount: 47.25,
      tokenNumber: '#T-103',
      orderTime: DateTime.now().subtract(const Duration(hours: 3)),
      status: 'completed', // Already collected
      paymentMethod: 'UPI',
      notes: '',
    ),
  ];

  List<OrderModel> get allOrders => List.unmodifiable(_orders);

  List<OrderModel> getActiveOrdersForUser(String userId) {
    return _orders.where((o) =>
        o.userId == userId &&
        (o.status == 'pending' || o.status == 'preparing' || o.status == 'ready')
    ).toList();
  }

  List<OrderModel> getPastOrdersForUser(String userId) {
    return _orders.where((o) =>
        o.userId == userId &&
        (o.status == 'completed' || o.status == 'cancelled')
    ).toList();
  }

  List<OrderModel> getKitchenOrders({String? statusFilter}) {
    if (statusFilter == null || statusFilter == 'All') {
      return _orders;
    }
    return _orders.where((o) => o.status.toLowerCase() == statusFilter.toLowerCase()).toList();
  }

  OrderModel placeOrder({
    required String userId,
    required String userName,
    required String userRollNumber,
    required List<OrderItem> items,
    required double totalAmount,
    required String paymentMethod,
    String notes = '',
  }) {
    _tokenCounter++;
    final tokenNumber = '#T-$_tokenCounter';
    final order = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      userName: userName,
      userRollNumber: userRollNumber,
      items: List.from(items),
      totalAmount: totalAmount,
      tokenNumber: tokenNumber,
      orderTime: DateTime.now(),
      status: 'pending',
      paymentMethod: paymentMethod,
      notes: notes,
    );

    _orders.insert(0, order);
    notifyListeners();
    return order;
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void cancelOrder(String orderId) {
    updateOrderStatus(orderId, 'cancelled');
  }

  // Helper for quick advancing status in demo
  void advanceOrderStatus(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index == -1) return;

    final currentStatus = _orders[index].status;
    String nextStatus;
    switch (currentStatus) {
      case 'pending':
        nextStatus = 'preparing';
        break;
      case 'preparing':
        nextStatus = 'ready';
        break;
      case 'ready':
        nextStatus = 'completed';
        break;
      default:
        return;
    }

    _orders[index] = _orders[index].copyWith(status: nextStatus);
    notifyListeners();
  }
}
