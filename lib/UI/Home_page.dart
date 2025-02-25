import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _currentInput = "";
  String _expression = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operator = "";
  final Map<String, double> _exchangeRates = {
    "INR→USD": 0.012, // 1 INR = 0.012 USD
    "USD→INR": 83.33, // 1 USD = 83.33 INR
    "EUR→USD": 1.18,  // 1 EUR = 1.18 USD
    "GBP→USD": 1.38,  // 1 GBP = 1.38 USD
  };

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _resetCalculator();
      } else if (buttonText == "(" || buttonText == ")") {
        _handleBrackets(buttonText);
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "x" || buttonText == "/") {
        _handleOperator(buttonText);
      } else if (buttonText == "=") {
        _handleEquals();
      } else if (buttonText == "%") {
        _handlePercentage();
      } else if (_exchangeRates.containsKey(buttonText)) {
        _handleCurrencyConversion(buttonText);
      } else {
        _handleNumberInput(buttonText);
      }
    });
  }

  void _resetCalculator() {
    _output = "0";
    _currentInput = "";
    _expression = "";
    _num1 = 0;
    _num2 = 0;
    _operator = "";
  }

  void _handleBrackets(String buttonText) {
    _currentInput += buttonText;
    _expression = _currentInput;
    _output = _currentInput;
  }

  void _handleOperator(String buttonText) {
    if (_currentInput.isNotEmpty) {
      _num1 = double.parse(_currentInput);
      _operator = buttonText;
      _expression = "$_num1 $_operator";
      _currentInput = "";
    }
  }

  void _handleEquals() {
    if (_operator.isNotEmpty && _currentInput.isNotEmpty) {
      _num2 = double.parse(_currentInput);
      _expression = "$_num1 $_operator $_num2 =";
      switch (_operator) {
        case "+":
          _output = (_num1 + _num2).toString();
          break;
        case "-":
          _output = (_num1 - _num2).toString();
          break;
        case "x":
          _output = (_num1 * _num2).toString();
          break;
        case "/":
          _output = _num2 != 0 ? (_num1 / _num2).toString() : "Error";
          break;
      }
      _currentInput = _output;
      _num1 = 0;
      _num2 = 0;
      _operator = "";
    }
  }

  void _handlePercentage() {
    if (_currentInput.isNotEmpty) {
      double percentageValue = double.parse(_currentInput) / 100;
      _expression = "$_currentInput% =";
      _output = percentageValue.toString();
      _currentInput = _output;
    }
  }

  void _handleCurrencyConversion(String buttonText) {
    if (_currentInput.isNotEmpty) {
      double amount = double.parse(_currentInput);
      double convertedAmount = amount * _exchangeRates[buttonText]!;
      _expression = "$_currentInput $buttonText =";
      _output = convertedAmount.toStringAsFixed(2);
      _currentInput = _output;
    }
  }

  void _handleNumberInput(String buttonText) {
    if (buttonText == "." && _currentInput.contains(".")) {
      return; // Prevent multiple decimal points
    }
    _currentInput += buttonText;
    _output = _currentInput;
    _expression = _currentInput;
  }

  Widget _buildButton(String buttonText, {Color? backgroundColor, Color? textColor}) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => _buttonPressed(buttonText),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(24.0),
          side: BorderSide(color: Colors.white),
          backgroundColor: backgroundColor ?? Colors.blueGrey[800],
        ),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 24.0, color: textColor ?? Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Calculator'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.blueAccent,
      body: Column(
        children: <Widget>[
          // Display the current expression
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            child: Text(
              _expression,
              style: TextStyle(fontSize: 24.0, color: Colors.white.withOpacity(0.7)),
            ),
          ),
          // Display the current output
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Text(
              _output,
              style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.white),
          ),
          Column(
            children: <Widget>[
              Row(children: [_buildButton("7"), _buildButton("8"), _buildButton("9"), _buildButton("/")]),
              Row(children: [_buildButton("4"), _buildButton("5"), _buildButton("6"), _buildButton("x")]),
              Row(children: [_buildButton("1"), _buildButton("2"), _buildButton("3"), _buildButton("-")]),
              Row(children: [_buildButton("C"), _buildButton("0"), _buildButton("="), _buildButton("+")]),
              Row(children: [
                _buildButton("%", backgroundColor: Colors.blueGrey[700]),
                _buildButton("(", backgroundColor: Colors.blueGrey[700]),
                _buildButton(")", backgroundColor: Colors.blueGrey[700]),
                _buildButton("INR→USD", backgroundColor: Colors.blueGrey[700]),
              ]),
              Row(children: [
                //change 1 here
                _buildButton("USD→INR", backgroundColor: Colors.blueGrey[700]),
                _buildButton("EUR→USD", backgroundColor: Colors.blueGrey[700]),
                _buildButton("GBP→USD", backgroundColor: Colors.blueGrey[700]),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}