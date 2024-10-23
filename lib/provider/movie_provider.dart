import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/services.dart';

class MovieProvider with ChangeNotifier {
  List<dynamic> _movies = [];
  List<dynamic> _favorites = [];
  bool _loading = false;
  int _currentPage = 1;
  bool _hasMoreMovies = true;

  List<dynamic> get movies => _movies;
  List<dynamic> get favorites => _favorites;
  bool get loading => _loading;

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  MovieService movieService = MovieService();

  MovieProvider(BuildContext context) {
    loadFavorites();
    _initializeControllers(context);
    _initializeConnectivityListener(context);
  }
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  void _initializeConnectivityListener(BuildContext context) {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty && result.first == ConnectivityResult.none) {
        _showSnackBar(context, "No internet connection");
      } else {
        fetchPopularMovies(context);
      }
    });
  }
  void _initializeControllers(BuildContext context) {
    searchController.addListener(() {
      _onSearchTextChanged(searchController.text);
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadMoreMovies(context);
      }
    });
  }

  Future<void> init(BuildContext context) async {
    _currentPage = 1;
    _hasMoreMovies = true;
    await fetchPopularMovies(context);
  }

  Future<void> fetchPopularMovies(BuildContext context) async {
    if (!_hasMoreMovies) return;

    _loading = true;
    notifyListeners();

    // Check for internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _loading = false;
      notifyListeners();
      _showSnackBar(context, "No internet connection");
      return;
    }

    try {
      final movies = await movieService.fetchPopularMovies(page: _currentPage);
      if (movies.isNotEmpty) {
        _movies.addAll(movies);
      } else {
        _hasMoreMovies = false;
      }
    } catch (e) {
      debugPrint('Error: $e');
      _showSnackBar(context, "No internet connection");
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> searchMovies(String title, {String? year, int page = 1, BuildContext? context}) async {
    _loading = true;
    notifyListeners();

    /// Check for internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _loading = false;
      notifyListeners();
      if (context != null) _showSnackBar(context, "No internet connection");
      return;
    }

    try {
      final movies = await movieService.searchMovies(title, year: year, page: page);
      _movies = movies;
      _currentPage = page;
      _hasMoreMovies = movies.isNotEmpty;
    } catch (e) {
      debugPrint('Error: $e');
      if (context != null) _showSnackBar(context, "Error searching movies");
    }
    _loading = false;
    notifyListeners();
  }

  void _onSearchTextChanged(String query) {
    if (query.isNotEmpty && query.length>2) {
       searchMovies(query, context: null);
    }
  }

  Future<void> toggleFavorite(String movieId) async {
    if (_favorites.contains(movieId)) {
      _favorites.remove(movieId);
    } else {
      _favorites.add(movieId);
    }
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favorites.map((m) => m.toString()).toList());
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  Future<void> loadMoreMovies(BuildContext context) async {
    _currentPage++;
    await fetchPopularMovies(context);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  dynamic getMovieById(String movieId) {
    return _movies.firstWhere((movie) => movie['imdbID'] == movieId, orElse: () => null);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );

    // Use ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}


