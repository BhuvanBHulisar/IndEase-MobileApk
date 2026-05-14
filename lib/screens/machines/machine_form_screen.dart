import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/mock_data.dart';
import '../../constants/spacing.dart';
import '../../providers/request_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input.dart';

class MachineFormScreen extends StatefulWidget {
  const MachineFormScreen({super.key, this.machineId});

  final String? machineId;

  @override
  State<MachineFormScreen> createState() => _MachineFormScreenState();
}

class _MachineFormScreenState extends State<MachineFormScreen> {
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  String _selectedType = machineTypes.first;

  bool get _isEditing => widget.machineId != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isEditing) {
      return;
    }
    final machine =
        context.read<RequestProvider>().machineById(widget.machineId!);
    if (machine != null && _nameController.text.isEmpty) {
      _nameController.text = machine.name;
      _yearController.text = machine.year.toString();
      _selectedType = machine.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final provider = context.read<RequestProvider>();
    final name = _nameController.text.trim().isEmpty
        ? 'New Machine'
        : _nameController.text.trim();
    final year = int.tryParse(_yearController.text.trim()) ?? 2020;

    if (_isEditing) {
      await provider.updateMachine(
        id: widget.machineId!,
        name: name,
        type: _selectedType,
        year: year,
      );
    } else {
      await provider.addMachine(name: name, type: _selectedType, year: year);
    }

    if (!mounted) return;
    context.go('/machines');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Machine' : 'Add Machine'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppInput(
              label: 'Machine Name',
              controller: _nameController,
              hintText: 'Main CNC Milling Unit',
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Machine Type',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<String>(
              value: machineTypes.contains(_selectedType)
                  ? _selectedType
                  : machineTypes.first,
              decoration: const InputDecoration(),
              items: machineTypes
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedType = value);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppInput(
              label: 'Year',
              controller: _yearController,
              hintText: '2005',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Save',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
