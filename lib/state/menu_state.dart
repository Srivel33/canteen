import 'package:flutter/material.dart';
import '../models/MenuItemModel.dart';

class MenuState extends ChangeNotifier {
  final List<MenuItem> _menuItems = [
    // Breakfast
    MenuItem(
      id: 'm1',
      name: 'Crispy Masala Dosa',
      description: 'Golden fermented crepe filled with spiced potato masala, served with 2 chutneys & sambar.',
      price: 55.0,
      imageUrl: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=400',
      isAvailable: true,
      category: 'Breakfast',
      isVeg: true,
      prepTimeMinutes: 8,
    ),
    MenuItem(
      id: 'm2',
      name: 'Idli Vada Combo',
      description: '2 fluffy steamed rice cakes + 1 crispy medu vada with hot lentil sambar & coconut chutney.',
      price: 45.0,
      imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=400',
      isAvailable: true,
      category: 'Breakfast',
      isVeg: true,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'm3',
      name: 'Indori Poha',
      description: 'Flattened rice tossed with roasted peanuts, curry leaves, onions, and topped with crunchy sev.',
      price: 35.0,
      imageUrl: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=400',
      isAvailable: true,
      category: 'Breakfast',
      isVeg: true,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'm4',
      name: 'Poori Bhaji (3 Pcs)',
      description: 'Crispy puffed whole wheat pooris served with aromatic potato gravy.',
      price: 50.0,
      imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400',
      isAvailable: false, // out of stock demo
      category: 'Breakfast',
      isVeg: true,
      prepTimeMinutes: 10,
    ),

    // Lunch
    MenuItem(
      id: 'm5',
      name: 'Special Veg Thali / Meals',
      description: 'Steamed rice, 2 rotis, paneer gravy, dal fry, seasonal subzi, curd, papad & sweet.',
      price: 90.0,
      imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400',
      isAvailable: true,
      category: 'Lunch',
      isVeg: true,
      prepTimeMinutes: 12,
    ),
    MenuItem(
      id: 'm6',
      name: 'Hyderabadi Chicken Biryani',
      description: 'Fragrant basmati rice slow-cooked with tender spiced chicken pieces, served with raita & salan.',
      price: 130.0,
      imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400',
      isAvailable: true,
      category: 'Lunch',
      isVeg: false,
      prepTimeMinutes: 10,
    ),
    MenuItem(
      id: 'm7',
      name: 'Paneer Butter Masala + Roti',
      description: 'Creamy tomato-butter paneer gravy paired with 3 butter phulkas.',
      price: 95.0,
      imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400',
      isAvailable: true,
      category: 'Lunch',
      isVeg: true,
      prepTimeMinutes: 12,
    ),
    MenuItem(
      id: 'm8',
      name: 'Veg Fried Rice + Manchurian',
      description: 'Wok-tossed vegetables and rice served with crispy vegetable Manchurian balls in rich gravy.',
      price: 85.0,
      imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400',
      isAvailable: true,
      category: 'Lunch',
      isVeg: true,
      prepTimeMinutes: 10,
    ),

    // Snacks
    MenuItem(
      id: 'm9',
      name: 'Crispy Samosa (2 Pcs)',
      description: 'Golden spiced potato stuffed pastry served with tangy mint and sweet tamarind chutneys.',
      price: 30.0,
      imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400',
      isAvailable: true,
      category: 'Snacks',
      isVeg: true,
      prepTimeMinutes: 4,
    ),
    MenuItem(
      id: 'm10',
      name: 'Loaded Veg Grilled Sandwich',
      description: 'Triple-layer toasted bread with sliced vegetables, green chutney, and melted cheese.',
      price: 60.0,
      imageUrl: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400',
      isAvailable: true,
      category: 'Snacks',
      isVeg: true,
      prepTimeMinutes: 8,
    ),
    MenuItem(
      id: 'm11',
      name: 'Peri-Peri French Fries',
      description: 'Hot, crispy potato fries dusted with spicy peri-peri seasoning.',
      price: 50.0,
      imageUrl: 'https://images.unsplash.com/photo-1576107232684-1279f3908594?w=400',
      isAvailable: true,
      category: 'Snacks',
      isVeg: true,
      prepTimeMinutes: 6,
    ),

    // Beverages
    MenuItem(
      id: 'm12',
      name: 'South Indian Filter Coffee',
      description: 'Traditional freshly brewed chicory coffee frothed with boiling hot milk in stainless steel dabara.',
      price: 20.0,
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400',
      isAvailable: true,
      category: 'Beverages',
      isVeg: true,
      prepTimeMinutes: 3,
    ),
    MenuItem(
      id: 'm13',
      name: 'Kullad Masala Chai',
      description: 'Rich milk tea infused with cardamom, ginger, and cloves served piping hot.',
      price: 15.0,
      imageUrl: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400',
      isAvailable: true,
      category: 'Beverages',
      isVeg: true,
      prepTimeMinutes: 3,
    ),
    MenuItem(
      id: 'm14',
      name: 'Fresh Mint Lime Soda',
      description: 'Chilled fizzy soda with fresh squeezed lemon juice, mint leaves, and black salt.',
      price: 30.0,
      imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=400',
      isAvailable: true,
      category: 'Beverages',
      isVeg: true,
      prepTimeMinutes: 4,
    ),
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<String> get categories => ['All', 'Breakfast', 'Lunch', 'Snacks', 'Beverages'];

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<MenuItem> get allItems => List.unmodifiable(_menuItems);

  List<MenuItem> get filteredItems {
    return _menuItems.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Admin Operations
  void toggleAvailability(String id) {
    final index = _menuItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final current = _menuItems[index];
      _menuItems[index] = current.copyWith(isAvailable: !current.isAvailable);
      notifyListeners();
    }
  }

  void addMenuItem(MenuItem item) {
    _menuItems.insert(0, item);
    notifyListeners();
  }

  void updateMenuItem(MenuItem updatedItem) {
    final index = _menuItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _menuItems[index] = updatedItem;
      notifyListeners();
    }
  }

  void deleteMenuItem(String id) {
    _menuItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
