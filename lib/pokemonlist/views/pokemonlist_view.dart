import 'package:flutter/material.dart';
import 'package:pokemondex/pokemondetail/views/pokemondetail_view.dart';
import 'package:pokemondex/pokemonlist/models/pokemonlist_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  late Future<List<PokemonListItem>> _list;
  late String nextUrl;

  @override
  void initState() {
    super.initState();
    nextUrl = 'https://pokeapi.co/api/v2/pokemon';
    _list = loadData(nextUrl);
  }

  Future<List<PokemonListItem>> loadData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final PokemonListResponse data =
          PokemonListResponse.fromJson(jsonDecode(response.body));
      nextUrl = data.next ?? ''; // Set the next URL for pagination
      return data.results;
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PokemonListItem>>(
        future: _list,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Pokemon found'));
          } else {
            final List<PokemonListItem> response = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: const Text('Pokemon List'),
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: response.length,
                      itemBuilder: (context, index) {
                        final PokemonListItem pokemon = response[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Center(
                              child: Text(
                                pokemon.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Center(
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png'),
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PokemondetailView(
                                  pokemonListItem: pokemon,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (nextUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _list = loadData(nextUrl);
                          });
                        },
                        child: const Text('Load More'),
                      ),
                    ),
                ],
              ),
            );
          }
        });
  }
}
