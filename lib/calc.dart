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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final style =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);

  final _resistivity = TextEditingController();
  final _rodelength = TextEditingController();
  final _areaoflength = TextEditingController();

  String result = "";

  bool Loading = false;

  // Track whether the form has been submitted
  bool _userEnteredData = false;

  AutovalidateMode _autovalidateMode =
      AutovalidateMode.disabled; // Add this line

  @override
  void initState() {
    super.initState();
    _resistivity.addListener(() => handleControllerInput(_resistivity));
    _rodelength.addListener(() => handleControllerInput(_rodelength));
    _areaoflength.addListener(() => handleControllerInput(_areaoflength));
  }

  //to restrict the decimal till three
  void handleControllerInput(TextEditingController controller) {
    final text = controller.text;
    final doubleParsed = double.tryParse(text);
    setState(() {
      _userEnteredData = true;
    });
    if (doubleParsed != null) {
      // Limit the input to 3 decimal places
      final decimalIndex = text.indexOf('.');
      if (decimalIndex != -1 && text.length - decimalIndex > 4) {
        // More than 3 decimal places, restrict the input
        controller.value = controller.value.copyWith(
          text: text.substring(0, decimalIndex + 4),
          selection: TextSelection.collapsed(offset: decimalIndex + 4),
        );
        return;
      }
    }
  }

  @override
  void dispose() {
    _resistivity.dispose();
    _areaoflength.dispose();
    _rodelength.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            autovalidateMode: _autovalidateMode,
            key: _formKey,
            child: Stack(
              children: [
                SizedBox(
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
                        SizedBox(
                          height: 45,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: double
                              .infinity, // Take up the full available width
                          child: FittedBox(
                            fit: BoxFit
                                .scaleDown, // Scale down the text if it's too large
                            child: Text(
                              "Earth Electrode Calculator",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 4, // Adjust the shadow elevation as needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                15.0), // Adjust the border radius
                            side: BorderSide(
                                color: Colors.black,
                                width: 2.0), // Border color and width
                          ),
                          child: Container(
                            padding:
                                EdgeInsets.all(20.0), // Padding inside the card
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Resistivity Of Soil",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
                                      } else
                                        return null;
                                    },
                                    controller: _resistivity,
                                    // onChanged: (value) {
                                    //   setState(() {
                                    //     _userEnteredData = true;
                                    //   });
                                    // },
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),

                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        helperText: '',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusColor: Colors.black,
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.only(top: 15),
                                        prefixIcon: Icon(
                                          Icons.line_axis,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: TextButton(
                                          onPressed: () {},
                                          child: Container(
                                            child: Text("Ωm",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                        hintText: 'e.g:1.121 Ωm',
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Length of Rod",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        helperText: '',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(top: 5),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: TextButton(
                                          onPressed: () {},
                                          child: Container(
                                            child: Text("m",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                        hintText: 'e.g:2.5 m',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      )),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Diameter of Rod",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        helperText: '',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(top: 5),
                                        prefixIcon: Icon(
                                          Icons.circle,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: TextButton(
                                          onPressed: () {},
                                          child: Container(
                                            child: Text("m",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                        hintText: 'e.g:0.023 m',
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 110,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 35),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _autovalidateMode =
                                                  AutovalidateMode.disabled;
                                              _formKey.currentState
                                                  ?.reset(); // Disable auto-validation
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
                                              side:
                                                  BorderSide(color: Colors.red),
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
                                        padding:
                                            EdgeInsets.symmetric(vertical: 35),
                                        child: ElevatedButton(
                                          onPressed: (_resistivity
                                                      .text.isNotEmpty &&
                                                  _rodelength.text.isNotEmpty &&
                                                  _areaoflength.text.isNotEmpty)
                                              ? () {
                                                  setState(() {
                                                    _autovalidateMode =
                                                        AutovalidateMode.always;
                                                  });
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    if (_resistivity.text ==
                                                            '0' &&
                                                        _rodelength.text ==
                                                            '0' &&
                                                        _areaoflength.text ==
                                                            '0') {
                                                      setState(() {
                                                        result = '';
                                                      });
                                                    } else {
                                                      calculateResistance();
                                                    }
                                                  }
                                                }
                                              : null, // Disable the button if any of the required fields is empty
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.green,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              side: BorderSide(
                                                  color: Colors.green),
                                            ),
                                          ),
                                          child: Text('Calculate'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        "Resistance of Electrode",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        // Conditional border color based on result
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: result.isEmpty
                                                ? Colors.grey
                                                : Colors.blue,
                                          ),
                                        ),
                                        // Additional styling based on result
                                        fillColor: result.isEmpty
                                            ? Colors.grey[200]
                                            : Colors.white,
                                        filled: true,
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                      controller: TextEditingController(
                                          text: result.isEmpty
                                              ? result
                                              : '$result Ω'), // Append 'm' only when result is not empty
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
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

  // bool isValidDecimal(String value) {
  //   if (!_userEnteredData || value.isEmpty) {
  //     // No data entered, or user hasn't entered data, don't show an error
  //     return true;
  //   }
  //   // if (!value.contains('.')) {
  //   //   // No decimal point, consider it as zero decimal places
  //   //   return true;
  //   // }
  //   try {
  //     // double parsedValue = double.parse(value);
  //     int decimalIndex = value.indexOf(
  //         '.'); // Find the index of the decimal point in the original string
  //     if (decimalIndex == -1) {
  //       return false;
  //     }
  //     int decimalPlaces = value.length - decimalIndex - 1;
  //     if (decimalPlaces < 3 || decimalPlaces == 0) {
  //       return false;
  //     }
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
