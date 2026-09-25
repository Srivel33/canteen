import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/OrderModel.dart';
import '../../state/auth_state.dart';
import '../../state/cart_state.dart';
import '../../state/menu_state.dart';
import '../../state/order_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/token_card.dart';

class TokenStatusScreen extends StatefulWidget {
  final VoidCallback? onGoToMenu;

  const TokenStatusScreen({super.key, this.onGoToMenu});

  @override
  State<TokenStatusScreen> createState() => _TokenStatusScreenState();
}

class _TokenStatusScreenState extends State<TokenStatusScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _reorderItems(BuildContext context, OrderModel order) {
    final cartState = Provider.of<CartState>(context, listen: false);
    final menuState = Provider.of<MenuState>(context, listen: false);

    for (final orderItem in order.items) {
      final menuItem = menuState.allItems.firstWhere(
        (m) => m.id == orderItem.menuItemId,
        orElse: () => menuState.allItems.first,
      );
      for (int i = 0; i < orderItem.quantity; i++) {
        cartState.addItem(menuItem);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${order.items.length} items to tray!'),
        backgroundColor: AppTheme.statusReady,
        duration: const Duration(seconds: 2),
      ),
    );

    if (widget.onGoToMenu != null) {
      widget.onGoToMenu!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final orderState = Provider.of<OrderState>(context);
    final user = authState.currentUser;

    if (user == null) {
      return const Center(child: Text('Please log in'));
    }

    final activeOrders = orderState.getActiveOrdersForUser(user.id);
    final pastOrders = orderState.getPastOrdersForUser(user.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokens & Orders'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primary,
          indicatorWeight: 3,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Active Tokens', style: TextStyle(fontWeight: FontWeight.bold)),
                  if (activeOrders.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${activeOrders.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(
              child: Text('Order History', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Tokens Tab
          activeOrders.isEmpty
              ? _buildNoActiveTokens()
              : RefreshIndicator(
                  onRefresh: () async => await Future.delayed(const Duration(milliseconds: 500)),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: activeOrders.length,
                    itemBuilder: (context, index) {
                      final order = activeOrders[index];
                      return Column(
                        children: [
                          if (order.status == 'ready')
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green.shade300),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.notifications_active_rounded, color: Colors.green),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Token ${order.tokenNumber} is READY!',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const Text(
                                          'Please proceed to Counter #1 for pickup',
                                          style: TextStyle(fontSize: 12, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          TokenCard(
                            order: order,
                            showAdvanceButton: true,
                            onAdvanceStatus: () {
                              orderState.advanceOrderStatus(order.id);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),

          // Past Orders Tab
          pastOrders.isEmpty
              ? _buildNoPastOrders()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pastOrders.length,
                  itemBuilder: (context, index) {
                    final order = pastOrders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppTheme.border),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.tokenNumber,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    order.status.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              order.items.map((i) => '${i.quantity}x ${i.name}').join(', '),
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹${order.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primaryDark,
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () => _reorderItems(context, order),
                                  icon: const Icon(Icons.replay_rounded, size: 16),
                                  label: const Text('Re-order'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildNoActiveTokens() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.confirmation_number_outlined,
                size: 56,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Active Food Tokens',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Order something from the menu to generate a live pickup token.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.onGoToMenu,
              child: const Text('Browse Menu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoPastOrders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.history_rounded, size: 54, color: AppTheme.textMuted),
          SizedBox(height: 12),
          Text(
            'No order history yet',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
