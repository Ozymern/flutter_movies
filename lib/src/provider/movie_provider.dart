import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_encyclopedia/src/models/actor_model.dart';
import 'package:movie_encyclopedia/src/models/movie_model.dart';

class MovieProvider {
  String _apiKey = '00df9dcac2e66665f32974760cb24f98';
  String _urlBase = 'api.themoviedb.org';
  String _lenguage = 'es-ES';
  int _popularPage = 0;
  bool _loading = false;

  List<Movie> _moviePopular = List();
  final __moviePopularStreamController =
      StreamController<List<Movie>>.broadcast();

  //proceso para introducir peliculas
  Function(List<Movie>) get moviePopularSink =>
      __moviePopularStreamController.sink.add;

  //proceso para escuchar peliculas
  Stream<List<Movie>> get moviePopularStream =>
      __moviePopularStreamController.stream;

  void disposeStream() {
    __moviePopularStreamController?.close();
  }

  Future<List<Movie>> _proccesResponse(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    //inyecto el resultado en mi modelo
    final movies = Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_urlBase, '3/movie/now_playing',
        {'api_key': _apiKey, 'lenguage': _lenguage});

    return await _proccesResponse(url);
  }

  Future<List<ActorModel>> getCast(String movieId) async {
    final url = Uri.https(_urlBase, '3/movie/$movieId/credits', {
      'api_key': _apiKey,
      'lenguage': _lenguage,
    });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final cast = Cast.fromJsonList(decodeData['cast']);

    return cast.actors;
  }

  Future<List<Movie>> getMoviePopular() async {
    //con _loading le decimos que espere hasta que regresen los datos para volver a cargar los siguientes
    if (_loading) return [];
    _loading = true;
    _popularPage++;

    final url = Uri.https(_urlBase, '3/movie/popular', {
      'api_key': _apiKey,
      'lenguage': _lenguage,
      'page': _popularPage.toString()
    });

    //obtengo la lista de peliculas
    final resp = await _proccesResponse(url);

    // las agrego a mi lista
    _moviePopular.addAll(resp);

    //agrego las lista de peliculas al comienzo del Stream
    moviePopularSink(_moviePopular);

    _loading = false;

    return resp;
    // return await _proccesResponse(url);
  }

  Future<List<Movie>> getSearchMovie(String query) async {
    final url = Uri.https(_urlBase, '3/search/movie', {
      'api_key': _apiKey,
      'lenguage': _lenguage,
      'query': query,
    });

    final resp = await _proccesResponse(url);
    return resp;
  }
}
