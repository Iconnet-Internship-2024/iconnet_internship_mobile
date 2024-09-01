class Applicant {
  final String name;
  final String placeOfBirth;
  final String dateOfBirth;
  final String gender;
  final String phoneNumber;
  final String city;
  final String address;
  final String religion;
  final String educationDegree;
  final String studentId;
  final String educationInstitution;
  final String educationMajor;
  final String educationFaculty;

  Applicant({
    required this.name,
    required this.placeOfBirth,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.city,
    required this.address,
    required this.religion,
    required this.educationDegree,
    required this.studentId,
    required this.educationInstitution,
    required this.educationMajor,
    required this.educationFaculty,
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      'place_of_birth': placeOfBirth,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'phone_number': phoneNumber,
      'city': city,
      'address': address,
      'religion': religion,
      'education_degree': educationDegree,
      'student_id': studentId,
      'education_institution': educationInstitution,
      'education_major': educationMajor,
      'education_faculty': educationFaculty,
    };
  }
}
