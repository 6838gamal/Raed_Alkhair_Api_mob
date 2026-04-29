class Branch {
  final int id;
  final String name;
  final bool isActive;

  Branch({required this.id, required this.name, required this.isActive});

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        isActive: json['is_active'] as bool? ?? true,
      );
}
