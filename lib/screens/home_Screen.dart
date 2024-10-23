import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../custom_widgets/movie_tile.dart';
import '../provider/movie_provider.dart';
import 'favrorites_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MovieProvider>(context, listen: false).init(context);
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        Provider.of<MovieProvider>(context, listen: false).searchController.clear();
        Provider.of<MovieProvider>(context, listen: false).init(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: Provider.of<MovieProvider>(context).searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
          ),
        )
            : const Text('Popular Movies'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.clear : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (movieProvider.movies.isEmpty) {
            return const Center(child: Text('No movies found.'));
          }

          return ListView.builder(
            controller: movieProvider.scrollController,
            itemCount: movieProvider.movies.length + 1,
            itemBuilder: (context, index) {
              if (index == movieProvider.movies.length) {
                return movieProvider.loading
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }

              final movie = movieProvider.movies[index];
              return MovieListTile(
                title: movie['Title'],
                posterUrl: movie['Poster'],
                rating: movie['imdbRating'] ?? 'N/A',
                onTap: () {
                  Navigator.pushNamed(context, '/details', arguments: movie['imdbID']);
                },
              );
            },
          );
        },
      ),
    );
  }
}
