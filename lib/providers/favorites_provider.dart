import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/ecoponto.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Ecoponto> _favorites = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Ecoponto> get favorites => _favorites;

  bool isFavorite(Ecoponto ecoponto) {
    return _favorites.any((e) => e.id == ecoponto.id);
  }

  Future<void> toggleFavorite(Ecoponto ecoponto) async {
    if (isFavorite(ecoponto)) {
      _favorites.removeWhere((e) => e.id == ecoponto.id);
    } else {
      _favorites.add(ecoponto);
    }
    notifyListeners();
    await _saveFavoritesToFirestore(); // Salva ao mudar
  }

 Future<void> loadFavoritesFromFirestore(List<Ecoponto> todosEcopontos) async {
  final user = _auth.currentUser;
  if (user == null) return;

  final doc = await _firestore.collection('users').doc(user.uid).get();
  if (doc.exists && doc.data()!.containsKey('favorites')) {
    // Conversão correta dos elementos para int
    List<int> favoriteIds = List.from(doc['favorites']).map((e) => e is int ? e : int.tryParse(e.toString())).whereType<int>().toList();

    _favorites.clear();
    for (var favId in favoriteIds) {
      Ecoponto? matched;
      try {
        matched = todosEcopontos.firstWhere((e) => e.id == favId);
      } catch (e) {
        matched = null;
      }
      if (matched != null) {
        _favorites.add(matched);
      }
    }
    notifyListeners();
  }
}


  Future<void> _saveFavoritesToFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favoriteIds = _favorites.map((e) => e.id).toList();

    await _firestore.collection('users').doc(user.uid).set({
      'favorites': favoriteIds,
    }, SetOptions(merge: true));
  }
}
