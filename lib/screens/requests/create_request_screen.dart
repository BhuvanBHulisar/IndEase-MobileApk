import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/spacing.dart';
import '../../models/machine_model.dart';
import '../../providers/request_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_input.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  int _step = 0;
  MachineModel? _selectedMachine;
  final _issueController = TextEditingController();
  final _budgetController = TextEditingController();
  String _urgency = 'Normal';
  DateTime? _preferredDate;
  String _slot = 'Morning';
  bool _showAnalysis = false;

  @override
  void dispose() {
    _issueController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final machines = context.watch<RequestProvider>().machines;
    if (_selectedMachine == null && machines.isNotEmpty) {
      _selectedMachine = machines.first;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List<Widget>.generate(6, (index) {
                final active = index <= _step;
                return Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active ? AppColors.primary : Colors.white,
                          border: Border.all(
                            color: active ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: active ? Colors.white : AppColors.textSecondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (index != 5)
                        Expanded(
                          child: Container(
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            color: index < _step
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildStepContent(context, machines),
            const SizedBox(height: AppSpacing.xl),
            if (_showAnalysis)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'AI Analysis Complete',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text('Machine Type: CNC Machine'),
                    SizedBox(height: 6),
                    Text('Detected Issue: Bearing failure'),
                    SizedBox(height: 6),
                    Text('Confidence: 87%'),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            if (_step > 0 && !_showAnalysis)
              Expanded(
                child: AppButton(
                  label: 'Back',
                  onPressed: () => setState(() => _step -= 1),
                  variant: AppButtonVariant.outline,
                ),
              ),
            if (_step > 0 && !_showAnalysis) const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppButton(
                label: _step == 5 ? 'Submit Request' : 'Continue',
                onPressed: _showAnalysis ? null : _next,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, List<MachineModel> machines) {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Step 1: Select machine',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacing.md),
            ...machines.map(
              (machine) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMachine = machine),
                  child: AppCard(
                    child: Row(
                      children: [
                        Icon(
                          _selectedMachine?.id == machine.id
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                machine.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${machine.type} • ${machine.year}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      case 1:
        return AppInput(
          label: 'Step 2: Issue description',
          controller: _issueController,
          hintText: 'Describe what\'s wrong...',
          maxLines: 5,
        );
      case 2:
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mock upload complete')),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              border: Border.all(color: AppColors.border),
              color: Colors.white,
            ),
            child: const Column(
              children: [
                Icon(Icons.videocam_rounded, size: 42, color: AppColors.primary),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Tap to upload video (optional)',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        );
      case 3:
        final options = [
          ('Low', 'Within a week', AppColors.success),
          ('Normal', '2–3 days', AppColors.warning),
          ('Critical', 'Factory stopped', AppColors.error),
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Step 4: Urgency',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacing.md),
            ...options.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () => setState(() => _urgency = option.$1),
                  child: AppCard(
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 14, color: option.$3),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.$1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option.$2,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_urgency == option.$1)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      case 4:
        final slots = ['Morning', 'Afternoon', 'Evening', 'Any time'];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Step 5: Preferred date',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.xs),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() => _preferredDate = picked);
                }
              },
              child: Container(
                width: double.infinity,
                height: AppSpacing.inputHeight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _preferredDate == null
                            ? 'Pick a date'
                            : DateFormat('d MMM').format(_preferredDate!),
                        style: TextStyle(
                          color: _preferredDate == null
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(Icons.calendar_month_rounded),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Time slot',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slots
                  .map(
                    (slot) => ChoiceChip(
                      label: Text(slot),
                      selected: _slot == slot,
                      onSelected: (_) => setState(() => _slot = slot),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      default:
        return AppInput(
          label: 'Step 6: Budget hint',
          controller: _budgetController,
          hintText: 'e.g. ₹2,000 – ₹5,000 (optional)',
        );
    }
  }

  Future<void> _next() async {
    if (_step < 5) {
      setState(() => _step += 1);
      return;
    }

    final provider = context.read<RequestProvider>();
    setState(() => _showAnalysis = true);

    final newId = await provider.createRequest(
      machine: _selectedMachine ?? provider.machines.first,
      issue: _issueController.text.trim().isEmpty
          ? 'General maintenance issue reported'
          : _issueController.text.trim(),
      urgency: _urgency,
      preferredDate: _preferredDate == null
          ? DateFormat('d MMM').format(
              DateTime.now().add(const Duration(days: 1)),
            )
          : DateFormat('d MMM').format(_preferredDate!),
      preferredSlot: _slot,
      budgetHint: _budgetController.text.trim(),
    );

    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (newId == null) {
      setState(() => _showAnalysis = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to submit request.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.go('/requests');
  }
}
