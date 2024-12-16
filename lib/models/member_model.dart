class Member {
  final String nim;
  final String name;
  final int batchYear;
  final String faculty;
  final String studyProgram;
  final String? profileImage;
  final String? profileImageUrl;

  Member({
    required this.nim,
    required this.name,
    required this.batchYear,
    required this.faculty,
    required this.studyProgram,
    this.profileImage,
    this.profileImageUrl,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      nim: json['nim'] ?? '',
      name: json['name'] ?? '',
      batchYear: json['batch_year'] ?? 0,
      faculty: json['faculty'] ?? '',
      studyProgram: json['study_program'] ?? '',
      profileImage: json['profile_image'],
      profileImageUrl: json['profile_image_url'],
    );
  }
}
