// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final _formkey = GlobalKey<FormState>();

  final style =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);

  final _resistivity = TextEditingController();
  final _rodelength = TextEditingController();
  final _areaoflength = TextEditingController();

  String result = "";

  bool _isObscure = true;

  String _errorMessage = '';

  bool Loading = false;

  bool _formSubmitted = false; // Track whether the form has been submitted
  bool _userEnteredData = false;

  AutovalidateMode _autovalidateMode =
      AutovalidateMode.disabled; // Add this line

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            autovalidateMode: _autovalidateMode,
            key: _formkey,
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Earth Electrode Calculator",
                          style: TextStyle(fontSize: 28, height: 4),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Restivity Of Soil",
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "resistivity cannot be empty";
                                  } else if (value == "0") {
                                    return "resistivity cannot be zero";
                                  } else if (!isValidDecimal(value)) {
                                    return 'enter decimal numbers with minimum 3 decimal places';
                                  } else
                                    return null;
                                },
                                controller: _resistivity,
                                onChanged: (value) {
                                  setState(() {
                                    _userEnteredData = true;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    helperText: '',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusColor: Colors.black,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(top: 15),
                                    prefixIcon: Icon(
                                      Icons.line_axis,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _resistivity.clear();
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: 'Eg:1.124',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Length of Rod",
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: TextFormField(
                                controller: _rodelength,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "length cannot be empty";
                                  } else if (value == "0") {
                                    return "Length cannot be zero";
                                  } else
                                    return null;
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    helperText: '',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(top: 5),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _rodelength.clear();
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: 'Eg:2.5',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Diameter of Rod",
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: TextFormField(
                                controller: _areaoflength,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "diameter cannot be empty";
                                  } else if (value == "0") {
                                    return "Diameter cannot be zero";
                                  } else
                                    return null;
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    helperText: '',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(top: 5),
                                    prefixIcon: Icon(
                                      Icons.circle,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _areaoflength.clear();
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: 'Eg:0.023',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 110,
                                    padding: EdgeInsets.symmetric(vertical: 35),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _autovalidateMode = AutovalidateMode
                                              .disabled; // Disable auto-validation
                                          _resistivity.clear();
                                          _rodelength.clear();
                                          _areaoflength.clear();
                                          result = "";
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          side: BorderSide(color: Colors.red),
                                        ),
                                      ),
                                      child: Text('Reset'),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    width:
                                        16), // Add some space between the buttons
                                Expanded(
                                  child: Container(
                                    height: 110,
                                    padding: EdgeInsets.symmetric(vertical: 35),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _autovalidateMode =
                                              AutovalidateMode.always;
                                        });
                                        if (_formkey.currentState!.validate()) {
                                          if (_resistivity.text == '0' &&
                                              _rodelength.text == '0' &&
                                              _areaoflength.text == '0') {
                                            setState(() {
                                              _errorMessage = 'Enter the input';
                                              result = '';
                                            });
                                          } else if (!isValidDecimal(
                                              _resistivity.text)) {
                                            setState(() {
                                              _errorMessage =
                                                  'enter decimal numbers with minimum 3 decimal places';
                                              result = '';
                                              _autovalidateMode =
                                                  AutovalidateMode.always;
                                            });
                                          } else {
                                            setState(() {
                                              _errorMessage = '';
                                            });
                                            calculateResistance();
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.green,
                                        backgroundColor:
                                            Colors.white, // Text color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          side: BorderSide(
                                              color:
                                                  Colors.green), // Border color
                                        ),
                                      ),
                                      child: Text('Submit'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Resistance of Electrode",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: result == ""
                                      ? Container() // Empty container if result is empty
                                      : Text(
                                          "$result Ω",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculateResistance() {
    double resistivity = double.parse(_resistivity.text);
    double length = double.parse(_rodelength.text);
    double diameter = double.parse(_areaoflength.text);

    double result1 = (resistivity / (2 * pi * length));

    print(result1);

    double result2 = log((8 * length) / diameter);

    double result3 = result2 - 1;
    print(result3);

    double resistance = result1 * result3;
    // double result1 =

    setState(() {
      _userEnteredData = false;
      result = resistance.toStringAsFixed(3);
    });
  }

  bool isValidDecimal(String value) {
    if (!_userEnteredData || value.isEmpty) {
      // No data entered, or user hasn't entered data, don't show an error
      return true;
    }
    if (!value.contains('.')) {
      // No decimal point, consider it as zero decimal places
      return true;
    }
    try {
      double parsedValue = double.parse(value);

      int decimalIndex = value.indexOf(
          '.'); // Find the index of the decimal point in the original string

// If there is no decimal point, or if the value ends with '0', consider it as zero or less than 3 decimal places
      if (decimalIndex == -1) {
        return true;
      }

// Calculate the number of decimal places
      int decimalPlaces = value.length - decimalIndex - 1;

// Only show an error if there are less than 3 decimal places
      if (decimalPlaces < 3) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
