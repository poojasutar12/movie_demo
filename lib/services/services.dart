import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  static const String apiKey = 'c376e3d4';
  static const String baseUrl = 'http://www.omdbapi.com/';

  Future<List<dynamic>> fetchPopularMovies({int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl?apikey=$apiKey&s=popular&type=movie&page=$page'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['Search'] ?? [];
    } else {
      // You can customize error handling here
      if (response.statusCode == 404) {
        throw Exception('Movies not found');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Failed to load movies');
      }
    }
  }

  Future<List<dynamic>> searchMovies(String title, {String? year, int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl?apikey=$apiKey&s=$title&type=movie${year != null ? '&y=$year' : ''}&page=$page'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['Search'] ?? [];
    } else {
      // Customize error handling based on status codes
      if (response.statusCode == 404) {
        throw Exception('No movies found for this query');
      } else {
        throw Exception('Failed to search movies');
      }
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetails(String movieId) async {
    final response = await http.get(Uri.parse('$baseUrl?apikey=$apiKey&i=$movieId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Customize error handling based on status codes
      if (response.statusCode == 404) {
        throw Exception('Movie details not found');
      } else {
        throw Exception('Failed to load movie details');
      }
    }
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class MovieService {
//   static const String apiKey = 'c376e3d4';
//   static const String baseUrl = 'http://www.omdbapi.com/';
//
//   Future<List<dynamic>> fetchPopularMovies({int page = 1}) async {
//     final response = await http.get(Uri.parse('$baseUrl?apikey=$apiKey&s=popular&type=movie&page=$page'));
//     print('Response Status: ${response.statusCode}');
//     print('Response Body: ${response.body}');
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['Search'] ?? [];
//     } else {
//       throw Exception('Failed to load movies');
//     }
//   }
//
//   Future<List<dynamic>> searchMovies(String title, {String? year, int page = 1}) async {
//     final response = await http.get(Uri.parse('$baseUrl?apikey=$apiKey&s=$title&type=movie${year != null ? '&y=$year' : ''}&page=$page'));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['Search'] ?? [];
//     } else {
//       throw Exception('Failed to search movies');
//     }
//   }
//
//   Future<Map<String, dynamic>> fetchMovieDetails(String movieId) async {
//     final response = await http.get(Uri.parse('$baseUrl?apikey=$apiKey&i=$movieId'));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load movie details');
//     }
//   }
// }
//
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// //
// // class MovieService {
// //   static const String apiKey = 'c376e3d4';
// //   static const String baseUrl = 'http://www.omdbapi.com/';
// //
// //   Future<List<dynamic>> fetchPopularMovies() async {
// //     final response = await http.get(Uri.parse('$baseUrl?apikey=$apiKey&s=popular&type=movie'));
// //     print('Response Status: ${response.statusCode}');
// //     print('Response Body: ${response.body}');
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return data['Search'] ?? [];
// //     } else {
// //       throw Exception('Failed to load movies');
// //     }
// //   }
// //
// //   Future<List<dynamic>> searchMovies(String title, {String? year}) async {
// //     final response = await http.get(Uri.parse('$baseUrl?apikey=$apiKey&s=$title&type=movie${year != null ? '&y=$year' : ''}'));
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return data['Search'] ?? [];
// //     } else {
// //       throw Exception('Failed to search movies');
// //     }
// //   }
// //
// //   Future<Map<String, dynamic>> fetchMovieDetails(String movieId) async {
// //     final response = await http.get(Uri.parse('$baseUrl?apikey=$apiKey&i=$movieId'));
// //     if (response.statusCode == 200) {
// //       return jsonDecode(response.body);
// //     } else {
// //       throw Exception('Failed to load movie details');
// //     }
// //   }
// // }
