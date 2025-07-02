class CategoryModel {
  final String categoryId;
  final String title;
  final String imgUrl;

  CategoryModel({
    required this.categoryId,
    required this.title,
    required this.imgUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['category_id'],
      title: json['name'],
      imgUrl: json['imageUrl'],
    );
  }
}