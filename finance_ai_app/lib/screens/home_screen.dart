import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/transaction_provider.dart';
import '../services/ai_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/neumorphic_button.dart';
import 'market_screen.dart';
import 'savings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const MarketScreen(), // Placeholder for Market
    const SizedBox(), // Placeholder for Add (FAB handles this)
    const SavingsScreen(), // Placeholder for Savings
    const Center(child: Text("Profile", style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _currentIndex == 0 
          ? const HomeContent() 
          : _screens[_currentIndex], // Simple switching for now
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.black),
          ),
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
        Container(
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
      ],
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return GlassCard(
      height: 220,
      width: double.infinity,
      color: const Color(0xFFE0B0FF).withOpacity(0.1), // Slight purple tint
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
                "\$12,450.00",
                style: TextStyle(
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
                  amount: "\$5,200",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatusItem(
                  context,
                  icon: Icons.arrow_downward_rounded,
                  color: Colors.redAccent,
                  label: "Expense",
                  amount: "\$1,450",
                ),
              ),
            ],
          ),
        ],
      ),
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
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
                  child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Grocery Store", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text("Today, 10:00 AM", style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
                Text(
                  "-\$45.00",
                  style: TextStyle(
                    color: Colors.white,
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
  }
}
