import 'dart:ffi';

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
  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();
  int? minSide;
  int? maxSide;
 

  void rollDice() {
    setState(() {
      if (minSide != null && maxSide != null && minSide! < maxSide!) {
        diceResults = List.generate(diceCount, (index) => Random().nextInt(maxSide! - minSide! + 1) + minSide!);
      } else {
        diceResults = List.generate(diceCount, (index) => Random().nextInt(diceSides) + 1);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Dice Roller'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row( //ダイスの個数を決定する部分
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Number of Dice:'),
                SizedBox(width: 10,),
                DropdownButton<int>(
                  value: diceCount,
                  items: List.generate(9, (index) => index + 1).map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      diceCount = newValue!;
                      diceResults = List.generate(diceCount, (index) => 1);
                    });
                  }
                )
              ],
            ),
            Row( // 何面ダイスを振るかを決定するための部分
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
                    setState(() {
                      diceSides = newValue!;
                      diceResults = List.generate(diceCount, (index) => 1);
                    });
                  }
                )
              ],
            ),
            Row( // ダイスの最小値と最大値を決定するための部分
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Min side:'),
                SizedBox(width: 10,),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: minController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                Text('Max side'),
                SizedBox(width: 10,),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: maxController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: (){
                    setState((){
                      minSide = int.tryParse(minController.text);
                      maxSide = int.tryParse(maxController.text);
                    });
                  },
                  child: Text('Set')
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16.0,
              runSpacing: 16.0,
              children: diceResults.map((result) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    result.toString(),
                    style: TextStyle(fontSize: 50, color: Colors.white),
                    textAlign: TextAlign.center,
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