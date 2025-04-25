class ImageResponse {
  final bool ok;
  final Result result;

  ImageResponse({required this.ok, required this.result});

  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    return ImageResponse(
      ok: json['ok'],
      result: Result.fromJson(json['result']),
    );
  }
}

class Result {
  final List<ImageItem> items;

  Result({required this.items});

  factory Result.fromJson(Map<String, dynamic> json) {
    var items = (json['items'] as List)
        .map((i) => ImageItem.fromJson(i))
        .toList();
    return Result(items: items);
  }
}

class ImageItem {
  final String id;
  final List<Variant> variants;

  ImageItem({required this.id, required this.variants});

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    var variants = (json['variants'] as List)
        .map((v) => Variant.fromJson(v))
        .toList();
    return ImageItem(id: json['id'], variants: variants);
  }
}

class Variant {
  final int width;
  final int height;
  final String url;

  Variant({required this.width, required this.height, required this.url});

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      width: json['width'],
      height: json['height'],
      url: json['url'],
    );
  }
}