import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dio/dio.dart';

part 'demo.g.dart';

final data = {
  "total": "14006",
  "page": 1,
  "pages": 701,
  "tv_shows": [
    {"id": 35624, "name": "The Flash", "permalink": "the-flash"}
  ]
};

@RestApi()
abstract class DemoClient {
  factory DemoClient(Dio dio, {String baseUrl}) = _DemoClient;

  @GET('/demo')
  Future<Result> getData();
}

@JsonSerializable()
class Result {
  String total;
  int page;
  int pages;
  List<Tv> tv_shows;

  Result({this.total, this.page, this.pages, this.tv_shows});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Tv {
  int id;
  String name;
  String permalink;

  Tv({this.id, this.name, this.permalink});
  factory Tv.fromJson(Map<String, dynamic> json) => _$TvFromJson(json);
  Map<String, dynamic> toJson() => _$TvToJson(this);
}
