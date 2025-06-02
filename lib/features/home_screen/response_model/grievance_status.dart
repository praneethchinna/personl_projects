class GrievanceStatus {
  final String reason;
  final int id;
  final int grievanceId;
  final String status;
  final DateTime updatedAt;

  GrievanceStatus({
    required this.reason,
    required this.id,
    required this.grievanceId,
    required this.status,
    required this.updatedAt,
  });

  factory GrievanceStatus.fromJson(Map<String, dynamic> json) {
    return GrievanceStatus(
      reason: json['reason'],
      id: json['id'],
      grievanceId: json['grievance_id'],
      status: json['status'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'id': id,
      'grievance_id': grievanceId,
      'status': status,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
