import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FavoriteCondition {
  final int diceCount;
  final int minSide;
  final int maxSide;

  FavoriteCondition({
    required this.diceCount,
    required this.minSide,
    required this.maxSide,
  });
}

List<FavoriteCondition> favoriteConditions = [];

void saveConditions(int diceCount, int minSide, int maxSide) {
  favoriteConditions.add(FavoriteCondition(
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
