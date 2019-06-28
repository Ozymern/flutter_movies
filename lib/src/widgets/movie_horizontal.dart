import 'package:flutter/material.dart';
import 'package:movie_encyclopedia/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  MovieHorizontal({@required this.movies, @required this.nextPage});

  //Un controlador de página le permite manipular qué página es visible en un PageView
  //viewportFraction cuantas imagenes se mostraran en el view
  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    //realizo un listener para escuchar todos los cambio, se disparara cada vez que se mueva el scroll
    _pageController.addListener(() {
      if (_pageController.position.pixels <=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,

      //PageView sirve para deslizar las imagenes, como una lista scrooliable, sin embargo el pageView va a renderizar todos los elementos de forma simultanea, posible fuga de memoria
      //sin embargo el builder los va renderizando bajo demanda
//      child: PageView(
//        //pageSnapping se le quita esa especie de magneto que tienen las imagen al situarlas
//        pageSnapping: false,
//        controller: _pageController,
//        children: _cards(context),
//      ),
      child: PageView.builder(
        //pageSnapping se le quita esa especie de magneto que tienen las imagen al situarlas
        pageSnapping: false,
        controller: _pageController,
        //especifico cuantos items va a renderizar
        itemCount: movies.length,
        itemBuilder: (context, i) {
          return _card(context, movies[i]);
        },
      ),
    );
  }

  Widget _card(BuildContext context, Movie movie) {
    //crear un id unico para el hero animation
    movie.uniqueId = '${movie.id}-poster';
    final card = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            //tag es un id unico que identifica donde esta y tiene que ser el mismo id a donde va a llegar
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                  fit: BoxFit.cover,
                  height: 110.0,
                  placeholder: AssetImage('assets/img/image-placeholder.png'),
                  image: NetworkImage(movie.getPosterImg())),
            ),
          ),
          SizedBox(
            height: 3.0,
          ),

          //verflow: TextOverflow.ellipsis agrega ... cuando el largo sobrepasa
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );

    //GestureDetector sirve para detectar evento en la tarjeta
    return GestureDetector(
      child: card,
      onTap: () {
        //en argument paso la palicula para manejar los datos en detail
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }

  List<Widget> _cards(BuildContext context) {
    return movies.map((x) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                  fit: BoxFit.cover,
                  height: 110.0,
                  placeholder: AssetImage('assets/img/image-placeholder.png'),
                  image: NetworkImage(x.getPosterImg())),
            ),
            SizedBox(
              height: 3.0,
            ),

            //verflow: TextOverflow.ellipsis agrega ... cuando el largo sobrepasa
            Text(
              x.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    }).toList();
  }
}
