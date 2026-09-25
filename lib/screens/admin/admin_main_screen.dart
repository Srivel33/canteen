import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/MenuItemModel.dart';
import '../../state/auth_state.dart';
import '../../state/menu_state.dart';
import '../../state/order_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/token_card.dart';
import '../../widgets/veg_indicator.dart';
import '../customer/customer_main_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedStatusFilter = 'All'; // 'All', 'pending', 'preparing', 'ready', 'completed'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = Provider.of<OrderState>(context);
    final menuState = Provider.of<MenuState>(context);
    final authState = Provider.of<AuthState>(context);

    final allOrders = orderState.allOrders;
    final pendingCount = allOrders.where((o) => o.status == 'pending').length;
    final preparingCount = allOrders.where((o) => o.status == 'preparing').length;
    final readyCount = allOrders.where((o) => o.status == 'ready').length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.soup_kitchen_rounded, color: AppTheme.primary, size: 24),
            SizedBox(width: 10),
            Text(
              'Kitchen Live Console',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Switch to Student App
          TextButton.icon(
            onPressed: () {
              // Ensure student demo user is active
              if (authState.isAdmin) {
                authState.switchUser(AuthState.demoUsers[0]);
              }
            },
            icon: const Icon(Icons.school_rounded, color: Colors.amber, size: 16),
            label: const Text(
              'Student View',
              style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: Colors.white60,
          indicatorColor: AppTheme.primary,
          indicatorWeight: 3,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Orders Queue'),
                  const SizedBox(width: 6),
                  if (pendingCount + preparingCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${pendingCount + preparingCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            const Tab(text: 'Menu & Stock'),
            const Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Orders Queue
          _buildOrdersQueueTab(orderState, pendingCount, preparingCount, readyCount),

          // Tab 2: Menu & Stock
          _buildMenuStockTab(menuState),

          // Tab 3: Analytics
          _buildAnalyticsTab(allOrders, menuState),
        ],
      ),
    );
  }

  Widget _buildOrdersQueueTab(
    OrderState orderState,
    int pendingCount,
    int preparingCount,
    int readyCount,
  ) {
    final filtered = orderState.getKitchenOrders(statusFilter: _selectedStatusFilter);

    return Column(
      children: [
        // Quick Stats Strip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.grey.shade100,
          child: Row(
            children: [
              _metricChip('Placed', pendingCount, AppTheme.statusPending),
              const SizedBox(width: 8),
              _metricChip('Cooking', preparingCount, AppTheme.statusPreparing),
              const SizedBox(width: 8),
              _metricChip('Ready', readyCount, AppTheme.statusReady),
            ],
          ),
        ),

        // Filter Pills
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _filterPill('All'),
              _filterPill('pending', label: 'Placed Orders'),
              _filterPill('preparing', label: 'In Kitchen (Cooking)'),
              _filterPill('ready', label: 'Ready for Pickup'),
              _filterPill('completed', label: 'Delivered'),
            ],
          ),
        ),
        const Divider(height: 1),

        // Orders List
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.done_all_rounded, size: 54, color: AppTheme.textMuted),
                      SizedBox(height: 10),
                      Text(
                        'No orders in this status',
                        style: TextStyle(fontSize: 15, color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final order = filtered[index];
                    return TokenCard(
                      order: order,
                      showAdvanceButton: order.status != 'completed' && order.status != 'cancelled',
                      onAdvanceStatus: () {
                        orderState.advanceOrderStatus(order.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Updated ${order.tokenNumber} status!'),
                            duration: const Duration(milliseconds: 900),
                            backgroundColor: AppTheme.primary,
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _metricChip(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterPill(String status, {String? label}) {
    final isSelected = _selectedStatusFilter.toLowerCase() == status.toLowerCase();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label ?? status),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedStatusFilter = status),
        selectedColor: const Color(0xFF1E293B),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textPrimary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
        backgroundColor: Colors.white,
        side: BorderSide(color: isSelected ? const Color(0xFF1E293B) : AppTheme.border),
      ),
    );
  }

  // Tab 2: Menu Stock Management
  Widget _buildMenuStockTab(MenuState menuState) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(menuState),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Dish', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: menuState.allItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = menuState.allItems[index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                VegIndicator(isVeg: item.isVeg),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        '${item.category} • ₹${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                // Instant Availability Toggle Switch
                Row(
                  children: [
                    Text(
                      item.isAvailable ? 'In Stock' : 'Sold Out',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: item.isAvailable ? AppTheme.statusReady : Colors.red,
                      ),
                    ),
                    Switch(
                      value: item.isAvailable,
                      activeThumbColor: AppTheme.statusReady,
                      onChanged: (val) {
                        menuState.toggleAvailability(item.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddItemDialog(MenuState menuState) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    String category = 'Snacks';
    bool isVeg = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Canteen Menu Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Dish Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price (₹)'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ['Breakfast', 'Lunch', 'Snacks', 'Beverages']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => category = val!),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Vegetarian?'),
                    const Spacer(),
                    Switch(
                      value: isVeg,
                      onChanged: (val) => setDialogState(() => isVeg = val),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
                  final newItem = MenuItem(
                    id: 'm_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    price: double.tryParse(priceCtrl.text) ?? 50.0,
                    imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
                    isAvailable: true,
                    category: category,
                    isVeg: isVeg,
                    prepTimeMinutes: 8,
                  );
                  menuState.addMenuItem(newItem);
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Add Dish'),
            ),
          ],
        ),
      ),
    );
  }

  // Tab 3: Canteen Analytics
  Widget _buildAnalyticsTab(List allOrders, MenuState menuState) {
    final totalRevenue = allOrders.fold<double>(0.0, (sum, o) => sum + o.totalAmount);
    final completedCount = allOrders.where((o) => o.status == 'completed').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Performance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 14),

          // Revenue Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TODAY'S ESTIMATED REVENUE",
                  style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '₹${totalRevenue.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.trending_up_rounded, color: Colors.greenAccent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${allOrders.length} Total orders received today',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stat Grid
          Row(
            children: [
              Expanded(
                child: _analyticCard(
                  'Tokens Handed Over',
                  '$completedCount',
                  Icons.check_circle_outline_rounded,
                  AppTheme.statusReady,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _analyticCard(
                  'Active In-Kitchen',
                  '${allOrders.length - completedCount}',
                  Icons.soup_kitchen_outlined,
                  AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _analyticCard(
                  'Dishes on Menu',
                  '${menuState.allItems.length}',
                  Icons.menu_book_rounded,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _analyticCard(
                  'In-Stock Items',
                  '${menuState.allItems.where((i) => i.isAvailable).length}',
                  Icons.inventory_2_outlined,
                  Colors.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _analyticCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            val,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
