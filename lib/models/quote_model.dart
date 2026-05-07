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
}
