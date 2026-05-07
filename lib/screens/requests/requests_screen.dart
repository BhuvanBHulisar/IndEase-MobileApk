import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/spacing.dart';
import '../../models/request_model.dart';
import '../../providers/request_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/request_card.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  int _selectedIndex = 0;
  static const _filters = ['All', 'Pending', 'Active', 'Completed'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestProvider>();
    final filteredRequests = _applyFilter(provider.requests);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Requests',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: List<Widget>.generate(_filters.length, (index) {
              final isSelected = _selectedIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? Colors.teal
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      _filters[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.teal : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: RefreshIndicator(
              onRefresh: provider.refreshRequests,
              child: filteredRequests.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 120),
                        EmptyState(
                          icon: Icons.inbox_rounded,
                          title: 'No requests here yet',
                          subtitle:
                              'Your filtered requests will appear here once they match this stage.',
                        ),
                      ],
                    )
                  : ListView.separated(
                      itemCount: filteredRequests.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final request = filteredRequests[index];
                        return RequestCard(
                          request: request,
                          onTap: () => context.push('/requests/${request.id}'),
                          onPrimaryAction: () =>
                              _handlePrimaryAction(context, request),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  List<RequestModel> _applyFilter(List<RequestModel> requests) {
    switch (_selectedIndex) {
      case 1:
        return requests
            .where((request) =>
                request.status == 'broadcast' ||
                request.status == 'quote_submitted' ||
                request.status == 'quote_approved')
            .toList();
      case 2:
        return requests
            .where((request) =>
                request.status == 'en_route' ||
                request.status == 'in_progress' ||
                request.status == 'pending_confirmation')
            .toList();
      case 3:
        return requests
            .where((request) =>
                request.status == 'completed' || request.status == 'cancelled')
            .toList();
      default:
        return requests;
    }
  }

  void _handlePrimaryAction(BuildContext context, RequestModel request) {
    final provider = context.read<RequestProvider>();

    switch (request.status) {
      case 'broadcast':
        provider.cancelRequest(request.id);
        break;
      case 'quote_submitted':
        context.push('/requests/${request.id}/quotes');
        break;
      case 'en_route':
      case 'in_progress':
        context.push('/chat/${request.id == '2' ? '2' : '1'}');
        break;
      case 'pending_confirmation':
        provider.confirmCompletion(request.id);
        break;
      case 'completed':
        context.push('/requests/${request.id}');
        break;
    }
  }
}
