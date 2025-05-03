import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:vaulto/providers/auth_provider.dart';
import 'package:vaulto/providers/theme_provider.dart';
import 'qr_scanner_screen.dart';
import 'add_receipt_screen.dart';
import 'add_expense_dialog.dart';
import 'package:vaulto/providers/budget_provider.dart';
import 'chatbot_screen.dart';
import 'goals_screen.dart';
import 'analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _progressController;
  late Animation<double> _weeklyProgressAnimation;
  late Animation<double> _monthlyProgressAnimation;
  int _currentQuoteIndex = 0;
  bool _showChatbot = false;
  final double _currentBalance = 2000.0;
  int _currentIndex = 0;

  // Add color constants
  static const Color primaryGreen = Color(0xFF8DC63F);
  static const Color lightBackground = Color(0xFFFFFEF2);
  static const Color darkText = Color(0xFF333333);

  final List<String> _quotes = [
    "Every penny saved is a penny earned!",
    "Small savings today lead to big dreams tomorrow!",
    "Your future self will thank you for saving now!",
    "Financial freedom starts with smart savings!",
    "Make your money work for you!",
    "A rupee saved is a rupee earned!",
    "Budget like a pro, spend like a king!",
    "Smart spending today, wealthy tomorrow!",
    "Track your expenses, grow your wealth!",
    "Financial success is a journey, not a destination!",
    "Save first, spend later!",
    "Your budget is your financial roadmap!",
    "Small steps in saving lead to giant leaps in wealth!",
    "Financial discipline is the key to freedom!",
    "Invest in your future, one rupee at a time!",
    "Money saved is money earned with interest!",
    "Financial goals are dreams with deadlines!",
    "Budgeting is telling your money where to go!",
    "Wealth is built one smart decision at a time!",
    "Financial freedom is the ultimate luxury!",
    "Save for the life you want, not the life you have!",
    "Financial success is 20% knowledge, 80% behavior!",
    "The best time to start saving was yesterday!",
    "Financial security is the best gift you can give yourself!",
    "Smart money management is the foundation of wealth!",
    "Your financial future is in your hands!",
    "Budgeting is the first step to financial freedom!",
    "Save with purpose, spend with wisdom!",
    "Financial success is a habit, not an act!",
    "Every financial decision shapes your future!",
  ];

  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'title': 'Grocery Shopping',
      'amount': '-₹1,200',
      'date': 'Today',
      'icon': Icons.shopping_cart,
      'color': Colors.orange,
    },
    {
      'title': 'Salary Credit',
      'amount': '+₹45,000',
      'date': 'Yesterday',
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
    },
    {
      'title': 'Movie Tickets',
      'amount': '-₹800',
      'date': 'Yesterday',
      'icon': Icons.movie,
      'color': Colors.purple,
    },
    {
      'title': 'Electricity Bill',
      'amount': '-₹2,500',
      'date': '2 days ago',
      'icon': Icons.electric_bolt,
      'color': Colors.blue,
    },
    {
      'title': 'Online Shopping',
      'amount': '-₹3,200',
      'date': '3 days ago',
      'icon': Icons.shopping_bag,
      'color': Colors.red,
    },
  ];

  final List<Map<String, dynamic>> _offers = [
    {
      'title': 'Get 10% Cashback',
      'description': 'On all grocery purchases',
      'icon': Icons.local_grocery_store,
      'color': Colors.green,
    },
    {
      'title': 'Earn 5X Points',
      'description': 'On movie bookings',
      'icon': Icons.movie,
      'color': Colors.purple,
    },
    {
      'title': 'Free Delivery',
      'description': 'On orders above ₹500',
      'icon': Icons.delivery_dining,
      'color': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _weeklyProgressAnimation = Tween<double>(begin: 0, end: 0.65).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOut,
      ),
    );

    _monthlyProgressAnimation = Tween<double>(begin: 0, end: 0.45).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOut,
      ),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
        });
        _controller.reset();
        _controller.forward();
      }
    });

    _controller.forward();
    _progressController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.userName.isNotEmpty ? authProvider.userName : 'there';

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        title: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              'Vaulto',
              style: GoogleFonts.poppins(
                color: darkText,
              ),
            ),
          ],
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                '₹${_currentBalance.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: darkText),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      drawer: const ProfileScreen(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreetingSection(username),
                const SizedBox(height: 24),
                _buildProgressSection(),
                const SizedBox(height: 24),
                _buildQuotesSection(),
                const SizedBox(height: 24),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildAdSection(),
                const SizedBox(height: 24),
                _buildOffersSection(),
                const SizedBox(height: 24),
                _buildRecentTransactions(),
              ],
            ),
          ),
          if (_showChatbot)
            Positioned(
              right: 16,
              bottom: 80,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showChatbot = false;
                  });
                },
                child: const ChatbotScreen(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showChatbot = !_showChatbot;
          });
        },
        child: Icon(_showChatbot ? Icons.close : Icons.chat),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            // Already on home page
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GoalsScreen(),
              ),
            );
          } else if (index == 2) {
            // Streak button - show streak dialog
            _showStreakDialog(context);
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnalyticsScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Streak',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  void _showStreakDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.local_fire_department,
              color: Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Your Streak',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🔥 7 Day Streak!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Keep going! You\'re on a roll with your savings habits.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.orange.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '7/10 days to next milestone',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingSection(String username) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.waving_hand,
              color: primaryGreen,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $username!',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ready to save more today?',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required String title,
    required double progress,
    required Color color,
    required Animation<double> animation,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: darkText,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: animation.value,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            );
          },
        ),
        const SizedBox(height: 4),
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Text(
              '${(animation.value * 100).toInt()}%',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: darkText,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
        const SizedBox(height: 16),
        _buildProgressBar(
          title: 'Weekly Savings',
          progress: 0.65,
          color: primaryGreen,
          animation: _weeklyProgressAnimation,
        ),
        const SizedBox(height: 16),
        _buildProgressBar(
          title: 'Monthly Goal',
          progress: 0.45,
          color: Colors.blue,
          animation: _monthlyProgressAnimation,
        ),
      ],
    );
  }

  Widget _buildQuotesSection() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            _quotes[_currentQuoteIndex],
            key: ValueKey<int>(_currentQuoteIndex),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickActionButton(
              icon: Icons.qr_code_scanner,
              label: 'Scan QR',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRScannerScreen(),
                  ),
                );
              },
            ),
            _buildQuickActionButton(
              icon: Icons.receipt_long,
              label: 'Add Receipt',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddReceiptScreen(),
                  ),
                );
              },
            ),
            _buildQuickActionButton(
              icon: Icons.add_circle_outline,
              label: 'Add Expense',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AddExpenseDialog(
                    onAddExpense: (amount) {
                      Provider.of<BudgetProvider>(context, listen: false)
                          .addExpense(amount);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: lightBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: primaryGreen,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: darkText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdSection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special Offer!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Get 15% cashback on all online purchases this week',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Claim Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Offers & Rewards',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _offers.length,
            itemBuilder: (context, index) {
              final offer = _offers[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: offer['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: offer['color'].withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      offer['icon'],
                      color: offer['color'],
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      offer['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offer['description'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentTransactions.length,
          itemBuilder: (context, index) {
            final transaction = _recentTransactions[index];
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: transaction['color'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  transaction['icon'],
                  color: transaction['color'],
                ),
              ),
              title: Text(
                transaction['title'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                transaction['date'],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              trailing: Text(
                transaction['amount'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: transaction['amount'].startsWith('+')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
} 