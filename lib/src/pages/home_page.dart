import 'package:flutter/material.dart';
import 'package:movie_encyclopedia/src/provider/movie_provider.dart';
import 'package:movie_encyclopedia/src/search/data_search.dart';
import 'package:movie_encyclopedia/src/widgets/card_swiper.dart';
import 'package:movie_encyclopedia/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  MovieProvider movieProvider = MovieProvider();

  @override
  Widget build(BuildContext context) {
    movieProvider.getMoviePopular();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      //safeAarea es un widget para colocar las cosas donde el dispositivo no tenga problemas
      //safeArea agrega el relleno necesario para evitar que su barra de estado, muescas, agujeros, esquinas redondeadas y otras funciones "creativas" de los fabricantes bloqueen su widget
      //https://stackoverflow.com/questions/49227667/using-safearea-in-flutter
      //body: SafeArea(child: Text('home page')),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperCards(),
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text(
            'populares',
            //Theme.of(context).textTheme.subhead: para configurar de manera global la aplicaicon
            style: Theme.of(context).textTheme.subhead,
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          /*   FutureBuilder(
              future: movieProvider.getMoviePopular(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return MovieHorizontal(movies: snapshot.data);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })*/
          StreamBuilder(
              stream: movieProvider.moviePopularStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return MovieHorizontal(
                    movies: snapshot.data,
                    nextPage: movieProvider.getMoviePopular,
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }

  Widget _swiperCards() {
    return FutureBuilder(
      future: movieProvider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            movies: snapshot.data,
          );
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
