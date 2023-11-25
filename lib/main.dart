import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _controller = TextEditingController();
  String text = '';
  int triedNumber = 0;
  String tryOption = '';
  int numberToGuess = 0;
  bool retry = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    numberToGuess = Random().nextInt(100) + 1;
    print("$numberToGuess");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guess my number",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            child: const Column(
              children: [
                Text(
                  "I'm thinking of a number between 1 and 100",
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
                Text(
                  "It's your turn to guess my number!",
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Text(
                    tryOption != "" ? "You tried $triedNumber $tryOption" : ""),
                Card(
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          "Try a number",
                          style: TextStyle(fontSize: 35, color: Colors.grey),
                        ),
                        TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          onChanged: (String value) {
                            setState(() {
                              text = value;
                            });
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                          ),
                          onPressed: () {
                            setState(() {
                              triedNumber = int.parse(text);
                              if (triedNumber > numberToGuess) {
                                tryOption = "Try Lower";
                              } else if (triedNumber < numberToGuess) {
                                tryOption = "Try Higher";
                              } else {
                                tryOption = "You guessed right";
                                if (retry) {
                                  _restartGame();
                                  retry = false;
                                } else {
                                  _dialogBuilder(context).then((dialogResult) {
                                    if (dialogResult != null) {
                                      if (dialogResult == true) {
                                        setState(() {
                                          retry =
                                              true; // Set retry to true if 'OK' is pressed in the dialog
                                        });
                                      } else {
                                        _restartGame();
                                      }
                                    }
                                  });
                                }
                              }
                            });
                          },
                          child: Text(
                            retry ? "reset" : "guess",
                            style: const TextStyle(
                              color: Colors.white,
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
        ],
      ),
    );
  }

  Future<bool?> _dialogBuilder(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: 250,
            height: 250,
            child: SimpleDialog(
                title: Text("You guessed right"),
                children: [
                  Text("It was $text"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text("try again")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text("ok")),
                    ],
                  ),
                ]
            ),
          );
        });
  }

  void _restartGame() {
    setState(() {
      numberToGuess = Random().nextInt(100) + 1;
      print(numberToGuess);
      tryOption = '';
      text = '';
      retry = false;
      _controller.clear();
    });
  }
}
