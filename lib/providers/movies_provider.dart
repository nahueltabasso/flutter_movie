import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/models/credits_response.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/models/now_playing_response.dart';
import 'package:movie/models/popular_response.dart';
import 'package:movie/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {

  final String _apiKey = '231c41c24009854f5b79fdd231ed3e75';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  MoviesProvider() {
    print("MoviesProvider inicializado");
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, {int page = 1}) async {
    var url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final body = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromRawJson(body);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final body = await _getJsonData('3/movie/popular', page: _popularPage);
    final popularResponse = PopularResponse.fromRawJson(body);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final body = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditResponse.fromRawJson(body);

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  
  Future<List<Movie>> searchMovie(String query) async {
    final urlSearch = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    final response = await http.get(urlSearch);
    // print(response);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;

  }
}