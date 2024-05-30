import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Roller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DicePage(),
    );
  }
}

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int diceCount = 1;
  int diceSides = 6;
  List<int> diceResults = [1];

  void rollDice(){
    setState((){
      diceResults = List.generate(diceCount, (index) => Random().nextInt(diceSides) + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Dice Roller'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Number of Dice:'),
                SizedBox(width: 10,),
                DropdownButton<int>(
                  value: diceCount,
                  items: List.generate(6, (index) => index + 1).map<DropdownMenuItem<int>>((int value){
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      diceCount = newValue!;
                      diceResults = List.generate(diceCount,(index) => 1);
                    });
                  }
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Number of sides:'),
                SizedBox(width: 10,),
                DropdownButton<int>(
                  value: diceSides,
                  items: [4,6,8,10,12,20,100].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState((){
                      diceSides = newValue!;
                      diceResults = List.generate(diceCount, (index) => 1);
                    });
                  }
                )
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: diceResults.map((result) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    result.toString(),
                    style: TextStyle(fontSize: 50),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: rollDice,
              child: Text('Roll Dice'),
            ),
          ],
        ),
      ),
    );
  }
}
