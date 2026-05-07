import 'dart:async';

import 'package:flutter/foundation.dart';

import '../constants/mock_data.dart';
import '../models/machine_model.dart';
import '../models/quote_model.dart';
import '../models/request_model.dart';

class RequestProvider extends ChangeNotifier {
  final List<MachineModel> _machines = List<MachineModel>.from(mockMachines);
  final List<RequestModel> _requests = List<RequestModel>.from(mockRequests);
  final Map<String, List<QuoteModel>> _quotesByRequest =
      Map<String, List<QuoteModel>>.from(mockQuotesByRequest);

  List<MachineModel> get machines => List<MachineModel>.unmodifiable(_machines);
  List<RequestModel> get requests => List<RequestModel>.unmodifiable(_requests);

  int get activeRequestsCount => _requests
      .where(
        (request) => request.status != 'completed' && request.status != 'cancelled',
      )
      .length;

  MachineModel? machineById(String id) {
    try {
      return _machines.firstWhere((machine) => machine.id == id);
    } catch (_) {
      return null;
    }
  }

  RequestModel? requestById(String id) {
    try {
      return _requests.firstWhere((request) => request.id == id);
    } catch (_) {
      return null;
    }
  }

  List<QuoteModel> quotesForRequest(String requestId) {
    return List<QuoteModel>.unmodifiable(
      _quotesByRequest[requestId] ?? mockQuotesByRequest['1'] ?? const [],
    );
  }

  Future<void> refreshRequests() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  void addMachine({
    required String name,
    required String type,
    required int year,
  }) {
    _machines.add(
      MachineModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        type: type,
        year: year,
      ),
    );
    notifyListeners();
  }

  void updateMachine({
    required String id,
    required String name,
    required String type,
    required int year,
  }) {
    final index = _machines.indexWhere((machine) => machine.id == id);
    if (index == -1) {
      return;
    }

    _machines[index] = _machines[index].copyWith(
      name: name,
      type: type,
      year: year,
    );
    notifyListeners();
  }

  void cancelRequest(String requestId) {
    _updateRequestStatus(requestId, 'cancelled');
  }

  void confirmCompletion(String requestId) {
    _updateRequestStatus(requestId, 'completed');
  }

  void approveQuote(String requestId, QuoteModel quote) {
    final index = _requests.indexWhere((request) => request.id == requestId);
    if (index == -1) {
      return;
    }

    _requests[index] = _requests[index].copyWith(
      status: 'in_progress',
      expertName: quote.expertName,
      updatedAt: 'Just now',
    );
    notifyListeners();
  }

  String createRequest({
    required MachineModel machine,
    required String issue,
    required String urgency,
    required String preferredDate,
    required String preferredSlot,
    required String budgetHint,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    _requests.insert(
      0,
      RequestModel(
        id: id,
        machineId: machine.id,
        machineName: machine.name,
        machineType: machine.type,
        issue: issue,
        status: 'broadcast',
        updatedAt: 'Just now',
        urgency: urgency,
        preferredDate: preferredDate,
        preferredSlot: preferredSlot,
        budgetHint: budgetHint.isEmpty ? 'Not specified' : budgetHint,
      ),
    );
    notifyListeners();
    return id;
  }

  void _updateRequestStatus(String requestId, String status) {
    final index = _requests.indexWhere((request) => request.id == requestId);
    if (index == -1) {
      return;
    }

    _requests[index] = _requests[index].copyWith(
      status: status,
      updatedAt: 'Just now',
    );
    notifyListeners();
  }
}
