import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/movie_provider.dart';
import '../custom_widgets/movie_tile.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: movieProvider.favorites.isEmpty
          ? const Center(child: Text('No favorite movies found.'))
          : ListView.builder(
              itemCount: movieProvider.favorites.length,
              itemBuilder: (context, index) {
                final movieId = movieProvider.favorites[index];
                final movie = movieProvider.getMovieById(movieId);
                if (movie == null) {
                  return const SizedBox.shrink();
                }

                return MovieListTile(
                  title: movie['Title'],
                  posterUrl: movie['Poster'],
                  rating: movie['imdbRating'] ?? 'N/A',
                  onTap: () {
                    Navigator.pushNamed(context, '/details',
                        arguments: movie['imdbID']);
                  },
                );
              },
            ),
    );
  }
}
