import 'dart:convert';

MovieVideoModel movieVideoModelFromJson(String str) => MovieVideoModel.fromJson(json.decode(str));

String movieVideoModelToJson(MovieVideoModel data) => json.encode(data.toJson());

class MovieVideoModel {
  int id;
  List<VideoResult> results;

  MovieVideoModel({
    required this.id,
    required this.results,
  });

  factory MovieVideoModel.fromJson(Map<String, dynamic> json) => MovieVideoModel(
    id: json["id"],
    results: List<VideoResult>.from(json["results"].map((x) => VideoResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class VideoResult {
  String iso6391;
  String iso31661;
  String name;
  String key;
  DateTime publishedAt;
  String site;
  int size;
  String type;
  bool official;
  String id;

  VideoResult({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.publishedAt,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.id,
  });

  factory VideoResult.fromJson(Map<String, dynamic> json) => VideoResult(
    iso6391: json["iso_639_1"],
    iso31661: json["iso_3166_1"],
    name: json["name"],
    key: json["key"],
    publishedAt: DateTime.parse(json["published_at"]),
    site: json["site"],
    size: json["size"],
    type: json["type"],
    official: json["official"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "iso_639_1": iso6391,
    "iso_3166_1": iso31661,
    "name": name,
    "key": key,
    "published_at": publishedAt.toIso8601String(),
    "site": site,
    "size": size,
    "type": type,
    "official": official,
    "id": id,
  };
}
