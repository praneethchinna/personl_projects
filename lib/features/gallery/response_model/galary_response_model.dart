class GalleryResponseModel {
  List<Images> images;

  GalleryResponseModel({required this.images});

  factory GalleryResponseModel.fromJson(Map<String, dynamic> json) {
    return GalleryResponseModel(
      images: List<Images>.from(json["images"].map((x) => Images.fromJson(x))),
    );
  }
}

class Images {
  String name;
  String url;

  Images({required this.name, required this.url});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      name: json["name"],
      url: json["url"],
    );
  }
}
