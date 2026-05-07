class RequestModel {
  const RequestModel({
    required this.id,
    required this.machineId,
    required this.machineName,
    required this.machineType,
    required this.issue,
    required this.status,
    required this.updatedAt,
    this.expertName,
    this.urgency = 'Normal',
    this.preferredDate = '2 May',
    this.preferredSlot = 'Morning',
    this.budgetHint = '₹2,000 – ₹5,000',
    this.aiMachineType = 'CNC Machine',
    this.aiIssue = 'Bearing failure detected',
    this.aiConfidence = 0.87,
  });

  final String id;
  final String machineId;
  final String machineName;
  final String machineType;
  final String issue;
  final String status;
  final String updatedAt;
  final String? expertName;
  final String urgency;
  final String preferredDate;
  final String preferredSlot;
  final String budgetHint;
  final String aiMachineType;
  final String aiIssue;
  final double aiConfidence;

  RequestModel copyWith({
    String? id,
    String? machineId,
    String? machineName,
    String? machineType,
    String? issue,
    String? status,
    String? updatedAt,
    String? expertName,
    String? urgency,
    String? preferredDate,
    String? preferredSlot,
    String? budgetHint,
    String? aiMachineType,
    String? aiIssue,
    double? aiConfidence,
  }) {
    return RequestModel(
      id: id ?? this.id,
      machineId: machineId ?? this.machineId,
      machineName: machineName ?? this.machineName,
      machineType: machineType ?? this.machineType,
      issue: issue ?? this.issue,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      expertName: expertName ?? this.expertName,
      urgency: urgency ?? this.urgency,
      preferredDate: preferredDate ?? this.preferredDate,
      preferredSlot: preferredSlot ?? this.preferredSlot,
      budgetHint: budgetHint ?? this.budgetHint,
      aiMachineType: aiMachineType ?? this.aiMachineType,
      aiIssue: aiIssue ?? this.aiIssue,
      aiConfidence: aiConfidence ?? this.aiConfidence,
    );
  }
}
