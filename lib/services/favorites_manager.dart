import 'package:ecosyncgh/models/ecoponto.dart';

class FavoritesManager {
  static final List<Ecoponto> _favorites = [];

  static List<Ecoponto> get favorites => _favorites;

  static void add(Ecoponto ecoponto) {
    if (!_favorites.contains(ecoponto)) {
      _favorites.add(ecoponto);
    }
  }

  static void remove(Ecoponto ecoponto) {
    _favorites.remove(ecoponto);
  }

  static bool isFavorite(Ecoponto ecoponto) {
    return _favorites.contains(ecoponto);
  }
}
