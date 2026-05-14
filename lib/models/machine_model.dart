class MachineModel {
  const MachineModel({
    required this.id,
    required this.name,
    required this.type,
    required this.year,
    this.status = 'Optimal',
  });

  final String id;
  final String name;
  final String type;
  final int year;
  final String status;

  MachineModel copyWith({
    String? id,
    String? name,
    String? type,
    int? year,
    String? status,
  }) {
    return MachineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      year: year ?? this.year,
      status: status ?? this.status,
    );
  }

  factory MachineModel.fromJson(Map<String, dynamic> json) {
    return MachineModel(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown Machine',
      type: json['machine_type'] ?? json['type'] ?? 'Unknown',
      year: int.tryParse(json['year_of_manufacture']?.toString() ?? '') ?? 0,
      status: json['status'] ?? 'Optimal',
    );
  }
}
