import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  // Add color constants
  static const Color primaryGreen = Color(0xFF8DC63F);
  static const Color lightBackground = Color(0xFFFFFEF2);
  static const Color darkText = Color(0xFF333333);

  // Sample expense data - in a real app, this would come from a database
  final List<Map<String, dynamic>> _expenses = [
    {
      'title': 'Grocery Shopping',
      'amount': 1200.0,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'category': 'Food & Dining',
      'icon': Icons.shopping_cart,
      'color': Colors.orange,
    },
    {
      'title': 'Movie Tickets',
      'amount': 800.0,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'category': 'Entertainment',
      'icon': Icons.movie,
      'color': Colors.purple,
    },
    {
      'title': 'Electricity Bill',
      'amount': 2500.0,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'category': 'Bills',
      'icon': Icons.electric_bolt,
      'color': Colors.blue,
    },
    {
      'title': 'Online Shopping',
      'amount': 3200.0,
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'category': 'Shopping',
      'icon': Icons.shopping_bag,
      'color': Colors.red,
    },
    {
      'title': 'Fuel',
      'amount': 1500.0,
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'category': 'Transport',
      'icon': Icons.local_gas_station,
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        title: Text(
          'My Expenses',
          style: GoogleFonts.poppins(
            color: darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: darkText),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 24),
            _buildExpensesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalExpenses = _expenses.fold(0.0, (sum, item) => sum + item['amount']);
    final averageExpense = totalExpenses / _expenses.length;

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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Expenses',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: darkText,
                ),
              ),
              Text(
                'This Month',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₹${totalExpenses.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Total Expenses', _expenses.length.toString()),
              _buildStatItem('Average', '₹${averageExpense.toStringAsFixed(2)}'),
              _buildStatItem('Highest', '₹${_expenses.map((e) => e['amount']).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: darkText,
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Expenses',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _expenses.length,
          itemBuilder: (context, index) {
            final expense = _expenses[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: expense['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      expense['icon'],
                      color: expense['color'],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: darkText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              expense['category'],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('MMM dd, yyyy').format(expense['date']),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '-₹${expense['amount'].toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[700],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
} 