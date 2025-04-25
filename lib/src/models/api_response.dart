import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse {
  final bool ok;
  final Result result;

  ApiResponse({required this.ok, required this.result});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);
}

@JsonSerializable()
class Result {
  final List<ImageItem> items;
  @JsonKey(name: 'continuationToken')
  final String? continuationToken;

  Result({required this.items, this.continuationToken});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
}

@JsonSerializable()
class ImageItem {
  final String id;
  final List<Variant> variants;

  ImageItem({required this.id, required this.variants});

  factory ImageItem.fromJson(Map<String, dynamic> json) => _$ImageItemFromJson(json);
}

@JsonSerializable()
class Variant {
  final int width;
  final int height;
  final String url;

  Variant({required this.width, required this.height, required this.url});

  factory Variant.fromJson(Map<String, dynamic> json) => _$VariantFromJson(json);
}