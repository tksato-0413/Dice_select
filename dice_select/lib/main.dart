import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:math';
import 'favorites.dart';

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
  int dicesum = 1; 
  List<int> diceResults = [1];
  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();
  int? minSide;
  int? maxSide;
 

  void rollDice() {
      if (maxSide != null && maxSide !> 1000){
        showErrorDialog(context, 'Max value should not exceed 999');
        return;
      }
    setState(() {
      if (minSide != null && maxSide != null && minSide! < maxSide!) {
        diceResults = List.generate(diceCount, (index) => Random().nextInt(maxSide! - minSide! + 1) + minSide!);
      } else {
        diceResults = List.generate(diceCount, (index) => Random().nextInt(diceSides) + 1);
      }
      dicesum = diceResults.reduce((a,b) => a+b); //合計値
    });
  }

  void showErrorDialog(BuildContext context, String message){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK')
            ),
          ],
        );
      },
    );
  }

  void _showSaveDialog(BuildContext context){
    String name = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text ('Save Favorite'),
          content: TextField(
            onChanged: (value){
              name = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            )
          ]
        );
      }
    );
  }

  double calculateFontSize(int maxValue){
    if (maxValue <= 99) {
      return 40.0;
    } else {
      return 40.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    int maxDigits = diceResults.isNotEmpty ? diceResults.map((e) => e.toString().length).reduce((a,b) => a > b ? a:b) : 1;
    int maxValue = int.parse('9' * maxDigits); 
    double fontSize = calculateFontSize(maxValue);
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
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child : Container(
                    width: 110,
                    height: 80,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      result.toString(),
                      style: TextStyle(fontSize: fontSize, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: rollDice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Roll Dice',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text(
              'SUM: $dicesum',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showSaveDialog(context);
        },
        tooltip: 'Save Favorite',
        child: Icon(Icons.favorite),
        ),
    );
  }
}