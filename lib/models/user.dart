class AppUser {
  final String memberNumber;
  final String fullName;
  final String? phone;
  final String? address;
  final int? preferredBranchId;

  AppUser({
    required this.memberNumber,
    required this.fullName,
    this.phone,
    this.address,
    this.preferredBranchId,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        memberNumber: (json['member_number'] ?? '').toString(),
        fullName: (json['full_name'] ?? '').toString(),
        phone: json['phone']?.toString(),
        address: json['address']?.toString(),
        preferredBranchId: (json['preferred_branch_id'] as num?)?.toInt(),
      );
}
