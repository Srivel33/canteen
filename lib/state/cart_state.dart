import 'package:flutter/material.dart';
import '../models/MenuItemModel.dart';
import '../models/OrderModel.dart';

class CartState extends ChangeNotifier {
  final Map<String, OrderItem> _items = {};
  String _cookingNotes = '';

  Map<String, OrderItem> get items => _items;
  List<OrderItem> get itemList => _items.values.toList();
  String get cookingNotes => _cookingNotes;

  int get totalItemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  // Canteen GST / platform charge (5%)
  double get taxAmount => subtotal * 0.05;

  double get totalAmount => subtotal + taxAmount;

  bool get isEmpty => _items.isEmpty;

  int getQuantity(String menuItemId) {
    return _items[menuItemId]?.quantity ?? 0;
  }

  void addItem(MenuItem menuItem) {
    if (_items.containsKey(menuItem.id)) {
      final existing = _items[menuItem.id]!;
      _items[menuItem.id] = OrderItem(
        menuItemId: existing.menuItemId,
        name: existing.name,
        quantity: existing.quantity + 1,
        price: existing.price,
      );
    } else {
      _items[menuItem.id] = OrderItem(
        menuItemId: menuItem.id,
        name: menuItem.name,
        quantity: 1,
        price: menuItem.price,
      );
    }
    notifyListeners();
  }

  void incrementItem(String menuItemId) {
    if (_items.containsKey(menuItemId)) {
      final existing = _items[menuItemId]!;
      _items[menuItemId] = OrderItem(
        menuItemId: existing.menuItemId,
        name: existing.name,
        quantity: existing.quantity + 1,
        price: existing.price,
      );
      notifyListeners();
    }
  }

  void decrementItem(String menuItemId) {
    if (!_items.containsKey(menuItemId)) return;

    if (_items[menuItemId]!.quantity > 1) {
      final existing = _items[menuItemId]!;
      _items[menuItemId] = OrderItem(
        menuItemId: existing.menuItemId,
        name: existing.name,
        quantity: existing.quantity - 1,
        price: existing.price,
      );
    } else {
      _items.remove(menuItemId);
    }
    notifyListeners();
  }

  void removeItem(String menuItemId) {
    _items.remove(menuItemId);
    notifyListeners();
  }

  void setNotes(String notes) {
    _cookingNotes = notes;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _cookingNotes = '';
    notifyListeners();
  }
}
