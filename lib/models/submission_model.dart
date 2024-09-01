// import 'dart:convert';

class Submission {
  final int id;
  final int userId;
  final int jobDivisionId;
  final int programId;
  final DateTime startDate;
  final DateTime endDate;
  final String coverLetterUrl;
  final String? proposalUrl;

  Submission({
    required this.id,
    required this.userId,
    required this.jobDivisionId,
    required this.programId,
    required this.startDate,
    required this.endDate,
    required this.coverLetterUrl,
    this.proposalUrl,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'],
      userId: json['user_id'],
      jobDivisionId: json['job_division_id'],
      programId: json['program_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      coverLetterUrl: json['cover_letter'],
      proposalUrl: json['proposal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'job_division_id': jobDivisionId,
      'program_id': programId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'cover_letter': coverLetterUrl,
      'proposal': proposalUrl,
    };
  }
}