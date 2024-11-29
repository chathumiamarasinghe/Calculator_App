//IM/2021/030
import 'package:flutter/material.dart';
import 'dart:math';
import 'buttons.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  //managing the calculator's logic and UI updates
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";
  bool calculationPerformed = false;
  List<String> history = [];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // For responsive design
    return Scaffold(
      appBar: AppBar(
        title: Container(),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showHistory,
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          // Allows scrolling if the content overflows
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map((value) => SizedBox(
                        width: screenSize.width / 4,
                        height: screenSize.width / 5,
                        child: buildButton(value),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: getTextColor(value),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //text color based on the button type
  Color getTextColor(String value) {
    return [
      Btn.add,
      Btn.subtract,
      Btn.multiply,
      Btn.divide,
      Btn.del,
      Btn.clr,
      Btn.per,
      Btn.sqrt
    ].contains(value)
        ? Colors.orange
        : Colors.white;
  }

  //button tap logics
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    if (value == Btn.sqrt) {
      calculateSquareRoot();
      return;
    }

    appendvalue(value);
  }

  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    String equation = "$number1$operand$number2";

    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        if (num2 == 0) {
          showErrorDialog("Can't divide by zero");
          return;
        }
        result = num1 / num2;
        break;
      default:
        return;
    }

    setState(() {
      number1 = result.toString();
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";

      history.add("$equation = $result");
      calculationPerformed = true;
    });
  }

  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }

    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);
    double result = number / 100;

    setState(() {
      number1 = "$result%";
      operand = "";
      number2 = "";

      calculationPerformed = true;

      history.add("$number% = $result");
    });
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
      calculationPerformed = false;
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void appendvalue(String value) {
    if (calculationPerformed) {
      if (int.tryParse(value) != null || value == Btn.dot) {
        number1 = "";
        operand = "";
        number2 = "";
        calculationPerformed = false;
      }
    }

    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
    } else if (operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) {
        return;
      }
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.dot)) {
        value = "0.";
      }
      number1 += value;
    } else if (operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) {
        return;
      }
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.dot)) {
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }

  void calculateSquareRoot() {
    if (number1.isEmpty) return;

    if (number1.startsWith("-")) {
      showErrorDialog("Can't calculate square root for negative values.");
      return;
    }

    final double num = double.parse(number1);
    double result = sqrt(num);

    setState(() {
      number1 = result.toString();
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";

      history.add("√$num = $result");
      calculationPerformed = true;
    });
  }

  void showErrorDialog(String message) {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
      calculationPerformed = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Calculation History"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: history.isEmpty
                ? [const Text("No history available.")]
                : history.map((entry) => Text(entry)).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Color getBtnColor(value) {
    return [
      Btn.calculate,
    ].contains(value)
        ? Colors.orange
        : Colors.black;
  }
}
