import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/transaction_provider.dart';
import '../services/ai_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/neumorphic_button.dart';
import 'market_screen.dart';
import 'savings_screen.dart';
import 'add_transaction_screen.dart';
import 'profile_screen.dart'; // Will create next

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize provider data
    Future.microtask(() => 
      Provider.of<TransactionProvider>(context, listen: false).init()
    );
  }

  final List<Widget> _screens = [
    const HomeContent(),
    const MarketScreen(),
    const SizedBox(), // Placeholder for Add
    const SavingsScreen(),
    const ProfileScreen(), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _currentIndex == 0 
          ? const HomeContent() 
          : _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home_filled, color: _currentIndex == 0 ? Colors.white : Colors.white54),
            onPressed: () => setState(() => _currentIndex = 0),
          ),
          IconButton(
            icon: Icon(Icons.analytics_outlined, color: _currentIndex == 1 ? Colors.white : Colors.white54),
            onPressed: () => setState(() => _currentIndex = 1),
          ),
          const SizedBox(width: 48), // Space for FAB
          IconButton(
            icon: Icon(Icons.pie_chart_outline, color: _currentIndex == 3 ? Colors.white : Colors.white54),
            onPressed: () => setState(() => _currentIndex = 3),
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: _currentIndex == 4 ? Colors.white : Colors.white54),
            onPressed: () => setState(() => _currentIndex = 4),
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        // Background Elements
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primaryColor.withOpacity(0.15),
            ),
          ),
        ),
         Positioned(
          bottom: 100,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.secondary.withOpacity(0.1),
            ),
          ),
        ),
        
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                FadeInDown(child: _buildWalletCard(context)),
                const SizedBox(height: 32),
                FadeInLeft(child: _buildQuickActions(context)),
                const SizedBox(height: 32),
                FadeInUp(child: _buildWalletStatus(context)),
                const SizedBox(height: 24),
                _buildSectionHeader(context, "Recent Transactions"),
                const SizedBox(height: 16),
                _buildTransactionList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, User", style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 4),
            Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        GestureDetector(
          onTap: () {
             // Navigate to profile via parent state if needed, or just let bottom nav handle it
          },
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white10,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        return GlassCard(
          height: 220,
          width: double.infinity,
          color: const Color(0xFFE0B0FF).withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.nfc, color: Colors.white70, size: 28),
                  Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1280px-Mastercard-logo.svg.png', height: 32, errorBuilder: (_,__,___) => const Icon(Icons.credit_card, color: Colors.white)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Balance", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(
                    provider.formatCurrency(provider.totalBalance),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("**** **** **** 8899", style: TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 1.5)),
                  Text("10/28", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NeumorphicButton(icon: Icons.arrow_upward, label: "Transfer", onTap: () {}),
        NeumorphicButton(icon: Icons.arrow_downward, label: "Receive", onTap: () {}),
        NeumorphicButton(icon: Icons.swap_horiz, label: "Convert", onTap: () {}),
        NeumorphicButton(icon: Icons.receipt_long, label: "Bills", onTap: () {}),
      ],
    );
  }

  Widget _buildWalletStatus(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        return GlassCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Wallet Status", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("See all", style: TextStyle(color: Theme.of(context).primaryColor)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildStatusItem(
                      context,
                      icon: Icons.arrow_upward_rounded,
                      color: Colors.greenAccent,
                      label: "Income",
                      amount: provider.formatCurrency(provider.totalIncome),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatusItem(
                      context,
                      icon: Icons.arrow_downward_rounded,
                      color: Colors.redAccent,
                      label: "Expense",
                      amount: provider.formatCurrency(provider.totalExpense),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusItem(BuildContext context, {required IconData icon, required Color color, required String label, required String amount}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.white54, fontSize: 12)),
              Text(amount, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        Icon(Icons.more_horiz, color: Colors.white54),
      ],
    );
  }

  Widget _buildTransactionList() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        if (provider.transactions.isEmpty) {
          return const Center(child: Text("No transactions yet", style: TextStyle(color: Colors.white54)));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.transactions.length > 5 ? 5 : provider.transactions.length,
          itemBuilder: (context, index) {
            final tx = provider.transactions[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                borderRadius: 16,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        tx.isExpense ? Icons.shopping_bag_outlined : Icons.attach_money,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(tx.category, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(
                      "${tx.isExpense ? '-' : '+'}${provider.formatCurrency(tx.amount)}",
                      style: TextStyle(
                        color: tx.isExpense ? Colors.redAccent : Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
