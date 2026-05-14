class QuoteModel {
  const QuoteModel({
    required this.id,
    required this.requestId,
    required this.expertName,
    required this.rating,
    required this.level,
    required this.jobsDone,
    required this.diagnosisNote,
    required this.scopeOfWork,
    required this.labourCost,
    required this.partsCost,
    required this.total,
    required this.estimatedHours,
    required this.availableDate,
    required this.availableSlot,
    required this.visitType,
  });

  final String id;
  final String requestId;
  final String expertName;
  final double rating;
  final String level;
  final int jobsDone;
  final String diagnosisNote;
  final String scopeOfWork;
  final int labourCost;
  final int partsCost;
  final int total;
  final int estimatedHours;
  final String availableDate;
  final String availableSlot;
  final String visitType;

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'].toString(),
      requestId: json['request_id']?.toString() ?? '',
      expertName: json['expert_name'] ?? json['name'] ?? 'Expert',
      rating: (json['rating'] ?? 4.5).toDouble(),
      level: json['level'] ?? 'Starter',
      jobsDone: int.tryParse(json['jobs_done']?.toString() ?? '') ?? 0,
      diagnosisNote: json['diagnosis_note'] ?? '',
      scopeOfWork: json['scope_of_work'] ?? '',
      labourCost: int.tryParse(json['labour_cost']?.toString() ?? '') ?? 0,
      partsCost: int.tryParse(json['parts_cost']?.toString() ?? '') ?? 0,
      total: int.tryParse(
            json['total']?.toString() ?? json['quoted_cost']?.toString() ?? '',
          ) ??
          0,
      estimatedHours:
          int.tryParse(json['estimated_hours']?.toString() ?? '') ?? 1,
      availableDate: json['available_date'] ?? '',
      availableSlot: json['available_slot'] ?? '',
      visitType: json['visit_type'] ?? 'On-site',
    );
  }
}
