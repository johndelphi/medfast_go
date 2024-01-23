import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medfast_go/data/DatabaseHelper.dart';
import 'package:medfast_go/models/expense.dart';

class AddExpensePage extends StatefulWidget {
  final Expense? expense;

  const AddExpensePage({Key? key, this.expense}) : super(key: key);

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController expenseNameController = TextEditingController();
  final TextEditingController expenseDetailsController =
      TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.expense != null) {
      expenseNameController.text = widget.expense!.expenseName;
      expenseDetailsController.text = widget.expense!.expenseDetails;
      dateController.text = widget.expense!.date;
      costController.text = widget.expense!.cost.toString();
    }
  }

  Future<void> _selectDate() async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: widget.expense != null
          ? DateTime.parse(widget.expense!.date)
          : currentDate,
      firstDate: currentDate.subtract(const Duration(days: 365)),
      lastDate: currentDate.add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromRGBO(58, 205, 50, 1),
            colorScheme: ColorScheme.light(
              primary: const Color.fromRGBO(58, 205, 50, 1),
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null && selectedDate != currentDate) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(58, 205, 50, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _customInputField(
              expenseNameController,
              'Expense Name',
              'Enter Expense Name',
              TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            _customInputField(
              expenseDetailsController,
              'Expense Details',
              'Enter Expense Details',
              TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            _customInputField(
              dateController,
              'Date',
              'Select Date',
              TextInputType.text,
              onTap: _selectDate,
            ),
            const SizedBox(height: 16.0),
            _customInputField(
              costController,
              'Cost',
              'Enter Cost',
              TextInputType.number,
            ),
            const SizedBox(height: 40.0),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await _saveExpense();
                  Navigator.of(context).pop(); // Return from the page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(58, 205, 50, 1),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customInputField(
    TextEditingController controller,
    String header,
    String hintText,
    TextInputType keyboardType, {
    FocusNode? focusNode,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          focusNode: focusNode,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color.fromRGBO(58, 205, 50, 1), width: 2.0),
            ),
            filled: true,
          ),
        ),
      ],
    );
  }

  Future<void> _saveExpense() async {
    if (_validateExpenseForm()) {
      final dbHelper = DatabaseHelper();

      Expense newExpense = Expense(
        id: widget.expense?.id,
        expenseName: expenseNameController.text,
        expenseDetails: expenseDetailsController.text,
        date: dateController.text,
        cost: double.tryParse(costController.text) ?? 0.0,
      );

      if (widget.expense == null) {
        await dbHelper.insertExpense(newExpense);
      } else {
        await dbHelper.updateExpense(newExpense);
      }
    }
  }

  bool _validateExpenseForm() {
    if (expenseNameController.text.isEmpty ||
        expenseDetailsController.text.isEmpty ||
        dateController.text.isEmpty ||
        costController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }
}
