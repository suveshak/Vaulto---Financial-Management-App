import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vaulto/providers/budget_provider.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget Management',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<BudgetProvider>(
        builder: (context, budgetProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBudgetCard(
                  context,
                  'Daily Budget',
                  budgetProvider.dailyLimit,
                  budgetProvider.dailySpent,
                  budgetProvider.isDailyLimitExceeded(),
                  (value) => budgetProvider.setDailyLimit(value),
                  () => budgetProvider.resetDailySpent(),
                  budgetProvider.isDailyLimitEnabled,
                  (enabled) => budgetProvider.toggleDailyLimit(enabled),
                ),
                const SizedBox(height: 16),
                _buildBudgetCard(
                  context,
                  'Weekly Budget',
                  budgetProvider.weeklyLimit,
                  budgetProvider.weeklySpent,
                  budgetProvider.isWeeklyLimitExceeded(),
                  (value) => budgetProvider.setWeeklyLimit(value),
                  () => budgetProvider.resetWeeklySpent(),
                  budgetProvider.isWeeklyLimitEnabled,
                  (enabled) => budgetProvider.toggleWeeklyLimit(enabled),
                ),
                const SizedBox(height: 16),
                _buildBudgetCard(
                  context,
                  'Monthly Budget',
                  budgetProvider.monthlyLimit,
                  budgetProvider.monthlySpent,
                  budgetProvider.isMonthlyLimitExceeded(),
                  (value) => budgetProvider.setMonthlyLimit(value),
                  () => budgetProvider.resetMonthlySpent(),
                  budgetProvider.isMonthlyLimitEnabled,
                  (enabled) => budgetProvider.toggleMonthlyLimit(enabled),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => _AddExpenseDialog(
                        onAddExpense: (amount) {
                          budgetProvider.addExpense(amount);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: Text(
                    'Add Expense',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBudgetCard(
    BuildContext context,
    String title,
    double limit,
    double spent,
    bool isLimitExceeded,
    Function(double) onLimitChanged,
    VoidCallback onResetSpent,
    bool isEnabled,
    Function(bool) onEnabledChanged,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: onEnabledChanged,
                ),
              ],
            ),
            if (isEnabled) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Limit',
                        prefixText: '₹',
                        border: const OutlineInputBorder(),
                        labelStyle: GoogleFonts.poppins(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        final newLimit = double.tryParse(value) ?? 0;
                        onLimitChanged(newLimit);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: onResetSpent,
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      'Reset',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: limit > 0 ? spent / limit : 0,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isLimitExceeded ? Colors.red : Colors.green,
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                'Spent: ₹${spent.toStringAsFixed(2)} / ₹${limit.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  color: isLimitExceeded ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddExpenseDialog extends StatefulWidget {
  final Function(double) onAddExpense;

  const _AddExpenseDialog({required this.onAddExpense});

  @override
  State<_AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<_AddExpenseDialog> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Expense',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      content: TextField(
        controller: _amountController,
        decoration: InputDecoration(
          labelText: 'Amount',
          prefixText: '₹',
          border: const OutlineInputBorder(),
          labelStyle: GoogleFonts.poppins(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(_amountController.text) ?? 0;
            if (amount > 0) {
              widget.onAddExpense(amount);
              Navigator.pop(context);
            }
          },
          child: Text(
            'Add',
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    );
  }
} 