class CategoryModel {
  final int id;
  final int branchId;
  final String title;
  final String subtitle;
  final String? imagePath;

  CategoryModel({
    required this.id,
    required this.branchId,
    required this.title,
    required this.subtitle,
    this.imagePath,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as int,
        branchId: json['branch_id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
        subtitle: json['subtitle'] as String? ?? '',
        imagePath: json['image_path'] as String?,
      );
}
