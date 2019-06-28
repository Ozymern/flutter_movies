import 'package:flutter/material.dart';
import 'package:movie_encyclopedia/src/models/movie_model.dart';
import 'package:movie_encyclopedia/src/provider/movie_provider.dart';

class DataSearch extends SearchDelegate {
  String select;
  final movieProvider = new MovieProvider();

  final movies = [
    'la vida es bella',
    'la vida es bella',
    'la vida es bella',
    'la vida es bella',
    'la vida es bella',
    'la vida es bella',
    'la vida es bella',
    'la vida es bella',
  ];

  final moviesNow = [
    'batman',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    //Las acciones del AppBar ej:limpiar y cancelar la busquedad, se posiciona a la derecha

    return [
      IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () {
          //query es todo lo que se escriba
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Icono  a la izquierda del AppBar
    //progress es el tiempo en el cual se va a animar este icono
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          //cierro la busquedad y navega a la ventana anterior por defecto
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    //Builder crea los resultados que se mostraran
    return Center(
        child: Container(
      height: 100.0,
      width: 100.0,
      color: Colors.indigo,
      child: Text(select),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Suguerencia que aparece cuando se escribe

//    //creo un filtro
//    final listSuggestions = (query.isEmpty)
//        ? moviesNow
//        : movies
//            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
//            .toList();
//    return ListView.builder(
//      itemBuilder: (context, i) {
//        return ListTile(
//          leading: Icon(Icons.movie),
//          title: Text(listSuggestions[i]),
//          onTap: () {
//            select = listSuggestions[i];
//            //construir los resultados
//            showResults(context);
//          },
//        );
//      },
//      itemCount: listSuggestions.length,
//    );

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
        future: movieProvider.getSearchMovie(query),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data;
            return ListView(
              children: movies.map((movie) {
                return ListTile(
                  leading: FadeInImage(
                    placeholder: AssetImage('assets/img/image-placeholder.png'),
                    image: NetworkImage(movie.getPosterImg()),
                    width: 50.0,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title),
                  subtitle: Text(movie.originalTitle),
                  onTap: () {
                    //cierro la busuquedad
                    close(context, null);
                    //navego a la pagina de detalle
                    movie.uniqueId = '';
                    Navigator.pushNamed(context, 'detail', arguments: movie);
                  },
                );
              }).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
