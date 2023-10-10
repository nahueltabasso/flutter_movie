import 'package:flutter/material.dart';
import 'package:movie/providers/movies_provider.dart';
import 'package:movie/search/search_delegate.dart';
import 'package:movie/widgets/card_swiper.dart';
import 'package:movie/widgets/movie_slider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final movieProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cine'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          // Tarjetas principales
          CardSwiper(movies: movieProvider.onDisplayMovies),
          
          // Listado horizontal de peliculas
          MovieSlider(movies: movieProvider.popularMovies, title: 'Populares!',
            onNextPage: () => movieProvider.getPopularMovies() 
          ,)
        ],
      ),
      )
    );
  }
}