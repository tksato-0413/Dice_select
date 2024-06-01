import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FavoriteCondition {
  final String name;
  final int diceCount;
  final int minSide;
  final int maxSide;

  FavoriteCondition({
    required this .name,
    required this.diceCount,
    required this.minSide,
    required this.maxSide,
  });
}

List<FavoriteCondition> favoriteConditions = [];

void saveConditions(String name, int diceCount, int minSide, int maxSide) {
  favoriteConditions.add(FavoriteCondition(
    name: name,
    diceCount: diceCount,
    minSide: minSide,
    maxSide: maxSide,
 ));
}

FavoriteCondition? getFavorite(int index) {
  if (index < 0 || index >= favoriteConditions.length){
    return null;
  }
  return favoriteConditions[index];
}
