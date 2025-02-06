class PokemonListResponse {
  final List<PokemonListItem> results;
  final String? next;

  PokemonListResponse({required this.results, this.next});

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    return PokemonListResponse(
      results: (json['results'] as List)
          .map((item) => PokemonListItem.fromJson(item))
          .toList(),
      next: json['next'],
    );
  }
}

class PokemonListItem {
  final String name;
  final String url;

  PokemonListItem({required this.name, required this.url});

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    return PokemonListItem(
      name: json['name'],
      url: json['url'],
    );
  }
}

class PokemonDetail {
  final String name;
  final List<String> types;
  final String imageUrl;
  final String status;

  PokemonDetail(
      {required this.name,
      required this.types,
      required this.imageUrl,
      required this.status});

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    List<String> types = [];
    for (var type in json['types']) {
      types.add(type['type']['name']);
    }
    return PokemonDetail(
      name: json['name'],
      types: types,
      imageUrl: json['sprites']['front_default'],
      status: json['stats'][0]['base_stat'].toString(), // แสดง stat พื้นฐาน
    );
  }
}
