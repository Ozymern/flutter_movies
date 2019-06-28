import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_encyclopedia/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  CardSwiper({@required this.movies});

  @override
  Widget build(BuildContext context) {
    //cambiar las dimensiones de las tarjetas dependiendo del dispositivo
    //mediaquery da informacion de las dimensiones del dispositivo
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      //es necesario darle las dimensiones al swiper
      /* usar todo el ancho posible*/
      /*    width: double.infinity,
      height: _screenSize.height * 0.5,*/
      child: Swiper(
        layout: SwiperLayout.STACK,
        //agrego el 70% de la pantalla
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          //crear un id unico para el hero animation
          movies[index].uniqueId = '${movies[index].id}-card';
          //agrego borde redondiados a la tarjeta
          return Hero(
            tag: movies[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              /* child: Image.network(
                "http://via.placeholder.com/350x150",
                fit: BoxFit.cover,
              ),*/
              child: GestureDetector(
                onTap: () {
                  //en argument paso la palicula para manejar los datos en detail
                  Navigator.pushNamed(context, 'detail',
                      arguments: movies[index]);
                },
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/image-placeholder.png'),
                  fit: BoxFit.cover,
                  image: NetworkImage(movies[index].getPosterImg()),
                ),
              ),
            ),
          );
        },
        // los puntitos que estan abajos de la imagen
        itemCount: movies.length,
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );
  }
}
