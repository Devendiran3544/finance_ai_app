import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/neumorphic_button.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _category = 'General';
  bool _isExpense = true;
  final _formKey = GlobalKey<FormState>();

  final List<String> _categories = ['General', 'Food', 'Transport', 'Shopping', 'Bills', 'Entertainment', 'Salary', 'Investment'];

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final enteredTitle = _titleController.text;
      final enteredAmount = double.parse(_amountController.text);

      if (enteredTitle.isEmpty || enteredAmount <= 0) {
        return;
      }

      final newTx = Transaction(
        id: const Uuid().v4(),
        title: enteredTitle,
        amount: enteredAmount,
        date: DateTime.now(),
        category: _category,
        isExpense: _isExpense,
      );

      Provider.of<TransactionProvider>(context, listen: false).addTransaction(newTx);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Add Transaction", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Selector
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isExpense = true),
                      child: GlassCard(
                        color: _isExpense ? Colors.redAccent.withOpacity(0.2) : null,
                        child: Center(child: Text("Expense", style: TextStyle(color: _isExpense ? Colors.redAccent : Colors.white70, fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isExpense = false),
                      child: GlassCard(
                        color: !_isExpense ? Colors.greenAccent.withOpacity(0.2) : null,
                        child: Center(child: Text("Income", style: TextStyle(color: !_isExpense ? Colors.greenAccent : Colors.white70, fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Amount Input
              Text("Amount (₹)", style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
              const SizedBox(height: 8),
              GlassCard(
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "0.00",
                    hintStyle: TextStyle(color: Colors.white24),
                    prefixText: "₹ ",
                    prefixStyle: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter an amount';
                    if (double.tryParse(value) == null) return 'Please enter a valid number';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Title Input
              Text("Description", style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
              const SizedBox(height: 8),
              GlassCard(
                child: TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "What is this for?",
                    hintStyle: TextStyle(color: Colors.white24),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                ),
              ),
              const SizedBox(height: 24),

              // Category Dropdown
              Text("Category", style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
              const SizedBox(height: 8),
              GlassCard(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _category,
                    dropdownColor: const Color(0xFF1E1E1E),
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white),
                    items: _categories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _category = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Add Transaction", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
