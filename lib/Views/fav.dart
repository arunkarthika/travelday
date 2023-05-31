import 'dart:convert';

import 'package:flutter/material.dart';

import '../Modal/favourite.dart';

import 'package:dio/dio.dart';

import '../Services/ApiServices.dart';

class FavoriteListScreen extends StatefulWidget {
  @override
  _FavoriteListScreenState createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
 FavouriteList movies = FavouriteList();

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

   Future<FavouriteList> fetchMovies() async {
    Dio dio = Dio();

    dio.options.headers['content-Type'] = 'application/json';
    //dio.options.headers["authorization"] = "Token ${token}";
    Response response = await dio.get(ApiService.baseUrl+"favarite_location",
      /*data: {
              //"tripDate": date
              //"date" :date
            },
            options: Options(
              //headers: {"Token": "$token"},
            )*/
    );
    print("data coming");
    print(response.data);
    print(response.requestOptions.baseUrl);


    if (response.statusCode == 200) {
      movies=FavouriteList.fromJson(response.data);
      setState(() {

      });
      return FavouriteList.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  void addToFavorites(Datum movie) {
    setState(() {
      movies.data!.data!.add(movie);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: movies.data ==null?Center(child: CircularProgressIndicator()):ListView.builder(
        itemCount:movies.data ==null?0:movies.data!.data!.length,
        itemBuilder: (context, index) {
          final movie = movies.data!.data![index];
          final isFavorite = movies.data!.data!.contains(movie);

          return ListTile(
            title: Text(movie.name??''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text(movie.place.toString()),
                SizedBox(height: 10,),

                // Text(movie.createAt.toString()),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                // addToFavorites(movie);
              },
            ),
          );
        },
      ),
    );
  }
}
