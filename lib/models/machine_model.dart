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
}
