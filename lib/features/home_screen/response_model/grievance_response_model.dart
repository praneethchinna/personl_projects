class Grievance {
  final int grievanceId;
  final String name;
  final String gender;
  final String mobile;
  final String email;
  final String parliament;
  final String assembly;
  final String grievanceReason;
  final String grievanceDescription;
  final String idProofType;
  final String idProofPath;
  final String selfiePath;
  final String status;
  final String? statusReason;
  final DateTime createdAt;
  final int userId;

  Grievance({
    required this.grievanceId,
    required this.name,
    required this.gender,
    required this.mobile,
    required this.email,
    required this.parliament,
    required this.assembly,
    required this.grievanceReason,
    required this.grievanceDescription,
    required this.idProofType,
    required this.idProofPath,
    required this.selfiePath,
    required this.status,
    this.statusReason,
    required this.createdAt,
    required this.userId,
  });

  factory Grievance.fromJson(Map<String, dynamic> json) {
    return Grievance(
      grievanceId: json['grievance_id'],
      name: json['name'],
      gender: json['gender'],
      mobile: json['mobile'],
      email: json['email'],
      parliament: json['parliament'],
      assembly: json['assembly'],
      grievanceReason: json['grievance_reason'],
      grievanceDescription: json['grievance_description'],
      idProofType: json['id_proof_type'],
      idProofPath: json['id_proof_path'],
      selfiePath: json['selfie_path'],
      status: json['status'],
      statusReason: json['status_reason'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grievance_id': grievanceId,
      'name': name,
      'gender': gender,
      'mobile': mobile,
      'email': email,
      'parliament': parliament,
      'assembly': assembly,
      'grievance_reason': grievanceReason,
      'grievance_description': grievanceDescription,
      'id_proof_type': idProofType,
      'id_proof_path': idProofPath,
      'selfie_path': selfiePath,
      'status': status,
      'status_reason': statusReason,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }
}
