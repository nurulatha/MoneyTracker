import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/utils/appvalidator.dart';
import 'package:money_tracker/widget/category_dropdown.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  var type = "expense";
  var category = "Others";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  var appValidator = AppValidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var uid = Uuid();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      var amount = int.parse(amountEditController.text);
      DateTime date = DateTime.now();

      var id = uid.v4();
      String monthyear = DateFormat('MMM y').format(date);
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      int remainingAmount = userDoc['remainingAmount'];
      int totalExpense = userDoc['totalExpense'];
      int totalIncome = userDoc['totalIncome'];

      if (type == 'expense') {
        remainingAmount -= amount;
        totalExpense += amount;
      } else {
        remainingAmount += amount;
        totalIncome += amount;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        "remainingAmount": remainingAmount,
        "totalExpense": totalExpense,
        "totalIncome": totalIncome,
        "updateAt": timestamp,
      });

      var data = {
        "id": id,
        "title": titleEditController.text,
        "amount": amount,
        "timeStamp": timestamp,
        "type": type,
        "totalExpense": totalExpense,
        "totalIncome": totalIncome,
        "remainingAmount": remainingAmount,
        "monthyear": monthyear,
        "category": category,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection("transactions")
          .doc(id)
          .set(data);

      //await authService.login(data, context);
      Navigator.pop(context);
      setState(() {
        isLoader = false;
      });
      //ScaffoldMessenger.of(_formKey.currentContext!)
      //  .showSnackBar(const SnackBar(content: Text('login successful')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: titleEditController,
              validator: appValidator.isEmptyCheck,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: amountEditController,
              validator: appValidator.isEmptyCheck,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            CategoryDropDown(
              cattype: category,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),
            DropdownButtonFormField(
                value: 'expense',
                items: [
                  DropdownMenuItem(
                    child: Text(
                      "Expense",
                    ),
                    value: 'expense',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "Income",
                    ),
                    value: 'income',
                  )
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      type = value;
                    });
                  }
                }),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(onPressed: () {
              if(isLoader == false){
                _submitForm();
              }
            }, child:
            isLoader ? Center(child: CircularProgressIndicator()):
            Text("Add Transaction"))
          ],
        ),
      ),
    );
  }
}
