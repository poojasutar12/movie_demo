import 'package:flutter/material.dart';
import '../custom_widgets/movie_detail.dart';
import '../services/services.dart';

class MovieDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: FutureBuilder(
        future: MovieService().fetchMovieDetails(movieId),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading movie details'));
          }

          final movie = snapshot.data!;
          return MovieDetailsBody(
            posterUrl: movie['Poster'],
            title: movie['Title'],
            plot: movie['Plot'],
            rating: movie['imdbRating'] ?? 'N/A',
            movieId: movieId,
          );
        },
      ),
    );
  }
}
