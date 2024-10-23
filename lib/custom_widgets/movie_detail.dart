import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/movie_provider.dart';

class MovieDetailsBody extends StatelessWidget {
  final String posterUrl;
  final String title;
  final String plot;
  final String rating;
  final String movieId;

  const MovieDetailsBody({
    Key? key,
    required this.posterUrl,
    required this.title,
    required this.plot,
    required this.rating,
    required this.movieId,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.network(posterUrl),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(plot),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: _buildStarRating(rating),
                ),
              ),
              Consumer<MovieProvider>(
                builder: (context, movieProvider, child) {
                  final isFavorite = movieProvider.favorites.contains(movieId);
                  return IconButton(
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                    onPressed: () {
                      movieProvider.toggleFavorite(movieId);
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  List<Widget> _buildStarRating(String rating) {
    double ratingValue = double.tryParse(rating) ?? 0;
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= ratingValue) {
        stars.add(const Icon(Icons.star, color: Colors.yellow)); // Filled star
      } else if (i - 0.5 <= ratingValue) {
        stars.add(const Icon(Icons.star_half, color: Colors.yellow)); // Half-filled star
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.yellow)); // Empty star
      }
    }
    return stars;
  }
}
