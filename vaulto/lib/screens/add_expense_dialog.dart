import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddExpenseDialog extends StatefulWidget {
  final Function(double) onAddExpense;

  const AddExpenseDialog({required this.onAddExpense});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _amountController = TextEditingController();
  String? _selectedCategory;

  final List<String> _categories = [
    'Dining',
    'Shopping',
    'Entertainment',
    'Groceries',
    'Transportation',
    'Healthcare',
    'Others',
  ];

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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixText: '₹',
              border: const OutlineInputBorder(),
              labelStyle: GoogleFonts.poppins(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(
                  category,
                  style: GoogleFonts.poppins(),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
        ],
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
            final amount = double.tryParse(_amountController.text);
            if (amount != null && amount > 0 && _selectedCategory != null) {
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