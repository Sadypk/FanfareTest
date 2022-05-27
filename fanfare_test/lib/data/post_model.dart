import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  PostModel({
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.views,
    required this.hearts,
  });

  String author;
  String description;
  String imageUrl;
  int views = 0;
  int hearts = 0;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        author: json["author"] ?? '',
        description: json["description"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
        views: json["views"] ?? 0,
        hearts: json["hearts"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "author": author,
        "description": description,
        "imageUrl": imageUrl,
        "views": views,
        "hearts": hearts,
      };
}
