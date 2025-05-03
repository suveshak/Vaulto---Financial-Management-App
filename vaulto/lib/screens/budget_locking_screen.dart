import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';

class BudgetLockingScreen extends StatefulWidget {
  const BudgetLockingScreen({super.key});

  @override
  State<BudgetLockingScreen> createState() => _BudgetLockingScreenState();
}

class _BudgetLockingScreenState extends State<BudgetLockingScreen> {
  late double _dailyLimit;
  late double _weeklyLimit;
  late double _monthlyLimit;
  late Map<String, double> _categoryLimits;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    _dailyLimit = budgetProvider.dailyLimit;
    _weeklyLimit = budgetProvider.weeklyLimit;
    _monthlyLimit = budgetProvider.monthlyLimit;
    _categoryLimits = Map.from(budgetProvider.categoryLimits);
  }

  void _updateHasChanges() {
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    setState(() {
      _hasChanges = _dailyLimit != budgetProvider.dailyLimit ||
          _weeklyLimit != budgetProvider.weeklyLimit ||
          _monthlyLimit != budgetProvider.monthlyLimit ||
          !_categoryLimits.entries.every(
            (e) => budgetProvider.categoryLimits[e.key] == e.value,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetProvider>(
      builder: (context, budgetProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Budget Locking',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildInfoCard(),
              const SizedBox(height: 24),
              Text(
                'Spending Limits',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _buildLimitCard(
                title: 'Daily Limit',
                amount: _dailyLimit,
                isEnabled: budgetProvider.isDailyLimitEnabled,
                onChanged: (value) {
                  budgetProvider.toggleDailyLimit(value);
                },
                onSliderChanged: (value) {
                  setState(() {
                    _dailyLimit = value;
                    _updateHasChanges();
                  });
                },
                maxAmount: 10000.0,
              ),
              const SizedBox(height: 12),
              _buildLimitCard(
                title: 'Weekly Limit',
                amount: _weeklyLimit,
                isEnabled: budgetProvider.isWeeklyLimitEnabled,
                onChanged: (value) {
                  budgetProvider.toggleWeeklyLimit(value);
                },
                onSliderChanged: (value) {
                  setState(() {
                    _weeklyLimit = value;
                    _updateHasChanges();
                  });
                },
                maxAmount: 50000.0,
              ),
              const SizedBox(height: 12),
              _buildLimitCard(
                title: 'Monthly Limit',
                amount: _monthlyLimit,
                isEnabled: budgetProvider.isMonthlyLimitEnabled,
                onChanged: (value) {
                  budgetProvider.toggleMonthlyLimit(value);
                },
                onSliderChanged: (value) {
                  setState(() {
                    _monthlyLimit = value;
                    _updateHasChanges();
                  });
                },
                maxAmount: 200000.0,
              ),
              const SizedBox(height: 24),
              _buildCategoryLimits(budgetProvider),
            ],
          ),
          floatingActionButton: _hasChanges
              ? FloatingActionButton.extended(
                  onPressed: () {
                    budgetProvider.saveChanges(
                      dailyLimit: _dailyLimit,
                      isDailyEnabled: budgetProvider.isDailyLimitEnabled,
                      weeklyLimit: _weeklyLimit,
                      isWeeklyEnabled: budgetProvider.isWeeklyLimitEnabled,
                      monthlyLimit: _monthlyLimit,
                      isMonthlyEnabled: budgetProvider.isMonthlyLimitEnabled,
                      categoryLimits: _categoryLimits,
                    );
                    setState(() {
                      _hasChanges = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Budget limits saved successfully',
                          style: GoogleFonts.poppins(),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: Text(
                    'Save Changes',
                    style: GoogleFonts.poppins(),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Set spending limits to help manage your budget. When enabled, transactions exceeding these limits will require additional verification.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLimitCard({
    required String title,
    required double amount,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
    required ValueChanged<double> onSliderChanged,
    required double maxAmount,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: onChanged,
                ),
              ],
            ),
            if (isEnabled) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Limit Amount',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '₹${amount.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Theme.of(context).colorScheme.primary,
                  inactiveTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  thumbColor: Theme.of(context).colorScheme.primary,
                ),
                child: Slider(
                  value: amount,
                  min: 0,
                  max: maxAmount,
                  onChanged: onSliderChanged,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryLimits(BudgetProvider budgetProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Limits',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categoryLimits.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final category = _categoryLimits.keys.elementAt(index);
              final limit = _categoryLimits[category]!;
              final color = index == 0
                  ? Colors.orange
                  : index == 1
                      ? Colors.blue
                      : Colors.purple;
              final icon = index == 0
                  ? Icons.restaurant
                  : index == 1
                      ? Icons.shopping_bag
                      : Icons.movie;

              return _buildCategoryLimitTile(
                icon: icon,
                category: category,
                limit: limit,
                color: color,
                onTap: () async {
                  final result = await showDialog<double>(
                    context: context,
                    builder: (context) => _CategoryLimitDialog(
                      category: category,
                      currentLimit: limit,
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _categoryLimits[category] = result;
                      _updateHasChanges();
                    });
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryLimitTile({
    required IconData icon,
    required String category,
    required double limit,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        category,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        '₹${limit.toStringAsFixed(2)}',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _CategoryLimitDialog extends StatefulWidget {
  final String category;
  final double currentLimit;

  const _CategoryLimitDialog({
    required this.category,
    required this.currentLimit,
  });

  @override
  State<_CategoryLimitDialog> createState() => _CategoryLimitDialogState();
}

class _CategoryLimitDialogState extends State<_CategoryLimitDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentLimit.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Set ${widget.category} Limit',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: TextField(
        controller: _controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          prefixText: '₹',
          labelText: 'Limit Amount',
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(),
          ),
        ),
        TextButton(
          onPressed: () {
            final amount = double.tryParse(_controller.text);
            if (amount != null && amount >= 0) {
              Navigator.pop(context, amount);
            }
          },
          child: Text(
            'Save',
            style: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
} 