import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'favorites.dart'; 

class FavoriteListScreen extends StatefulWidget {
  final DatabaseFactory factory;

  const FavoriteListScreen({Key? key, required this.factory}) : super(key: key);

  @override
  _FavoriteListScreenState createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  List<FavoriteCondition> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    var helper = FavoriteHelper(widget.factory);
    try {
      await helper.open();
      List<Map<String, dynamic>> maps = await helper.fetchAll();
      setState(() {
        _favorites = maps.map((map) => FavoriteCondition(
          map['id'],
          map['name'],
          map['diceCount'],
          map['minSide'],
          map['maxSide'],
        )).toList();
      });
    } catch (e) {
      print(e);
    } finally {
      await helper.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final favorite = _favorites[index];
                return ListTile(
                  title: Text(favorite.name),
                  subtitle: Text('Dice Count: ${favorite.diceCount}, Min Side: ${favorite.minSide}, Max Side: ${favorite.maxSide}'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Home'),
          ),
        ],
      ),
    );
  }
}
