import 'package:flutter/material.dart';

class MovieListTile extends StatelessWidget {
  final String title;
  final String posterUrl;
  final String rating;
  final VoidCallback onTap;

  const MovieListTile({
    Key? key,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: posterUrl != 'N/A'
          ? Image.network(posterUrl, width: 50, fit: BoxFit.cover)
          : const Icon(Icons.movie),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Rating: $rating'),
      onTap: onTap,
    );
  }
}
