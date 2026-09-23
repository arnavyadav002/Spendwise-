import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../state/expense_provider.dart';
import '../domain/models/expense.dart';
import '../domain/models/expense_category.dart';
import '../../../core/utils/money.dart';
import '../../../core/utils/validators.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory _selectedCategory = _categories.first;
  DateTime _selectedDate = DateTime.now();
  bool _saving = false;

  static const _categories = [
    ExpenseCategory(id: 'c1', name: 'Food & Dining', icon: '🍔'),
    ExpenseCategory(id: 'c2', name: 'Transport', icon: '🚗'),
    ExpenseCategory(id: 'c3', name: 'Entertainment', icon: '🎬'),
    ExpenseCategory(id: 'c4', name: 'Shopping', icon: '🛍️'),
    ExpenseCategory(id: 'c5', name: 'Bills & Utilities', icon: '💡'),
  ];

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final amountInPaise = (double.parse(_amountController.text) * 100)
          .round();
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: Money(amountInPaise),
        description: _descController.text.trim(),
        date: _selectedDate,
        category: _selectedCategory,
      );

      await ref.read(expensesProvider.notifier).addExpense(expense);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Expense added!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFF00897B),
        ),
      );
      if (context.mounted) {
        context.pop();
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceAll('Exception: ', '')),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF232340) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Expense',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Amount field
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: Validators.amount,
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                      decoration: InputDecoration(
                        prefixText: 'Rs. ',
                        prefixStyle: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade400,
                        ),
                        hintText: '0.00',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  controller: _descController,
                  validator: Validators.required,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'e.g. Coffee at Starbucks',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date selector
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMM d, yyyy').format(_selectedDate),
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category selector
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        final selected = _selectedCategory.id == cat.id;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF00897B)
                                  : (isDark
                                        ? Colors.white10
                                        : Colors.grey.shade100),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  cat.icon,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  cat.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: selected ? Colors.white : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _saving
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00897B),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00897B),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: _save,
                        child: Text(
                          'Save Expense',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
