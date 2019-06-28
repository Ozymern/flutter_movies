import 'package:flutter/material.dart';
import 'package:movie_encyclopedia/src/models/actor_model.dart';
import 'package:movie_encyclopedia/src/models/movie_model.dart';
import 'package:movie_encyclopedia/src/provider/movie_provider.dart';

class MovieDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //recibo la pelicula
    final Movie movie = ModalRoute.of(context).settings.arguments;
    //CustomScrollView permite crear efectos
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _createAppBar(movie),
        //ListViewno es más que una opción SliverListpara transformarla en una Widgetpara que sea utilizable junto con otros widgets como Row/ Container.
        //
        //La mayoría de las veces, usar ListView.
        //
        //Pero si desea un comportamiento de desplazamiento avanzado, como animaciones de la barra de aplicaciones con desplazamiento; necesitarás usar un CustomScrollView. Lo que te obligará a usar en SliverListlugar de ListView.
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: 10.0,
          ),
          _posterTitle(movie, context),
          _description(movie),
          _description(movie),
          _description(movie),
          _description(movie),
          _createCast(movie),
        ]))
      ],
    ));
  }

  Widget _createActorPageView(List<ActorModel> actors) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemBuilder: (context, i) => _actorCard(actors[i]),
        itemCount: actors.length,
      ),
    );
  }

  Widget _actorCard(ActorModel actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
                height: 150.0,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/img/image-placeholder.png'),
                image: NetworkImage(actor.getActorImg())),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget _createCast(Movie movie) {
    final movieProvider = MovieProvider();

    return FutureBuilder(
        future: movieProvider.getCast(movie.id.toString()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return _createActorPageView(snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        });
  }

  Widget _description(Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _posterTitle(Movie movie, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            //es el mismo tag de del hero del HomePage
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          //Widget para que se adapte a todo el espacio restante
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                movie.title,
                style: Theme.of(context).textTheme.title,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                movie.originalTitle,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.star_border,
                  ),
                  Text(
                    movie.voteAverage.toString(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _createAppBar(Movie movie) {
    //SliverAppBar permite moverse conforme el scroll
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigo,
      expandedHeight: 200.0,
      floating: false,
      //para que se mantenga visible cuando se empiece hacer el scroll
      pinned: true,
      //flexibleSpace para adaptar un widget en la caja
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
            fadeInDuration: Duration(microseconds: 250),
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/img/loading.gif'),
            image: NetworkImage(movie.getBackgroundImg())),
      ),
    );
  }
}
