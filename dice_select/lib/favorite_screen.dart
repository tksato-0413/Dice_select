import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/src/exception.dart';
import 'favorites.dart';

class FavoriteScreen extends StatefulWidget {
  final DatabaseFactory factory;

  const FavoriteScreen({Key? key, required this.factory}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>{
  final _nameController = TextEditingController();
  final _diceCountController = TextEditingController();
  final _minSideController = TextEditingController();
  final _maxSideController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _diceCountController.dispose();
    _minSideController.dispose();
    _maxSideController.dispose();
    super.dispose();
  }

  Future<void> _saveFavorite() async {
    final name = _nameController.text;
    final diceCount = int.tryParse(_diceCountController.text) ?? 0;
    final minSide = int.tryParse(_minSideController.text) ?? 0;
    final maxSide = int.tryParse(_maxSideController.text) ?? 0;

    var helper = FavoriteHelper(widget.factory);

    try {
      await helper.open();
      await helper.insert(1, name, diceCount, minSide, maxSide);
    } on SqfliteDatabaseException catch (e) {
      print (e.message);
    } finally {
      await helper.close();
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Saved to favorites!'),
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Save Favorite condition0'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _diceCountController,
              decoration: InputDecoration(labelText: 'Dice Count'),
            ),
            TextField(
              controller: _minSideController,
              decoration: InputDecoration(labelText: 'Min Side'),
            ),
            TextField(
              controller: _maxSideController,
              decoration: InputDecoration(labelText: 'Max Side'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveFavorite, child: Text('Save to Favorites'),
            ),
          ],
        )
      )
    );
  }
}