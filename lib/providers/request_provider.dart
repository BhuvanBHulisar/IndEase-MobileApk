import 'package:flutter/foundation.dart';
import '../constants/api.dart';
import '../models/machine_model.dart';
import '../models/quote_model.dart';
import '../models/request_model.dart';
import '../services/api_service.dart';

class RequestProvider extends ChangeNotifier {
  List<MachineModel> _machines = [];
  List<RequestModel> _requests = [];
  final Map<String, List<QuoteModel>> _quotesByRequest = {};
  bool _isLoading = false;
  String? _error;

  List<MachineModel> get machines => List.unmodifiable(_machines);
  List<RequestModel> get requests => List.unmodifiable(_requests);
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get activeRequestsCount => _requests
      .where((r) => r.status != 'completed' && r.status != 'cancelled')
      .length;

  MachineModel? machineById(String id) {
    try {
      return _machines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  RequestModel? requestById(String id) {
    try {
      return _requests.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  List<QuoteModel> quotesForRequest(String requestId) {
    return List.unmodifiable(_quotesByRequest[requestId] ?? []);
  }

  Future<void> fetchMachines() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await ApiService.get('/machines') as List;
      _machines = data.map((j) => MachineModel.fromJson(j)).toList();
    } catch (e) {
      _error = e.toString();
      print('[RequestProvider] Fetching machines failed. Loading local mock machines.');
      _machines = const [
        MachineModel(id: 'm1', name: 'Main CNC Spindle', type: 'CNC', year: 2021, status: 'Optimal'),
        MachineModel(id: 'm2', name: 'Hydraulic Press HP-4', type: 'Hydraulic Press', year: 2019, status: 'Needs Service'),
        MachineModel(id: 'm3', name: 'Emergency Generator', type: 'Generator', year: 2022, status: 'Optimal'),
      ];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRequests() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await ApiService.get('/jobs/my') as List;
      _requests = data.map((j) => RequestModel.fromJson(j)).toList();
    } catch (e) {
      _error = e.toString();
      print('[RequestProvider] Fetching requests failed. Loading local mock requests.');
      _requests = const [
        RequestModel(
          id: 'req_1',
          machineId: 'm1',
          machineName: 'Main CNC Spindle',
          machineType: 'CNC',
          issue: 'Spindle vibrating excessively, making high pitched noise.',
          status: 'in_progress',
          expertName: 'Rajesh K.',
          urgency: 'Critical',
          preferredDate: '24 May',
          preferredSlot: 'Morning',
          budgetHint: '₹3,000',
          updatedAt: '2h ago',
        ),
        RequestModel(
          id: 'req_2',
          machineId: 'm2',
          machineName: 'Hydraulic Press HP-4',
          machineType: 'Hydraulic Press',
          issue: 'Pressure drop in cylinder, possible seal leak.',
          status: 'broadcast',
          urgency: 'Normal',
          preferredDate: '25 May',
          preferredSlot: 'Afternoon',
          budgetHint: '₹5,000',
          updatedAt: '1d ago',
        ),
      ];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchQuotesForRequest(String requestId) async {
    try {
      final data = await ApiService.get('/jobs/$requestId/quotes') as List;
      _quotesByRequest[requestId] =
          data.map((j) => QuoteModel.fromJson(j)).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print('[RequestProvider] Fetching quotes failed. Loading local mock quotes.');
      _quotesByRequest[requestId] = [
        QuoteModel(
          id: 'q1',
          requestId: requestId,
          expertName: 'Rajesh K.',
          rating: 4.8,
          level: 'Expert',
          jobsDone: 142,
          diagnosisNote: 'Vibration is due to worn-out spindle bearings. Needs replacement.',
          scopeOfWork: 'Dismantle spindle housing, remove old bearings, install premium bearings, align and test run.',
          labourCost: 1500,
          partsCost: 1800,
          total: 3300,
          estimatedHours: 3,
          availableDate: '26 May',
          availableSlot: 'Morning',
          visitType: 'On-site',
        ),
        QuoteModel(
          id: 'q2',
          requestId: requestId,
          expertName: 'Suresh M.',
          rating: 4.5,
          level: 'Pro',
          jobsDone: 89,
          diagnosisNote: 'Spindle imbalance or bearing wear.',
          scopeOfWork: 'On-site inspection, bearing cleaning and lubrication, parts replacement if needed.',
          labourCost: 1200,
          partsCost: 2000,
          total: 3200,
          estimatedHours: 4,
          availableDate: '26 May',
          availableSlot: 'Afternoon',
          visitType: 'On-site',
        ),
      ];
      notifyListeners();
    }
  }

  Future<void> refreshRequests() => fetchRequests();

  Future<String?> createRequest({
    required MachineModel machine,
    required String issue,
    required String urgency,
    required String preferredDate,
    required String preferredSlot,
    required String budgetHint,
  }) async {
    try {
      final data = await ApiService.post(ApiConstants.broadcast, {
        'machine_id': machine.id,
        'machineId': machine.id,
        'issue_description': issue,
        'issueDescription': issue,
        'urgency': urgency,
        'priority': urgency.toLowerCase(),
        'urgency_level': urgency.toLowerCase(),
        'urgencyLevel': urgency.toLowerCase(),
        'preferred_date': preferredDate,
        'preferredDate': preferredDate,
        'preferred_slot': preferredSlot,
        'preferred_time_slot': preferredSlot,
        'preferredTimeSlot': preferredSlot,
        'budget_hint': budgetHint,
        'consumer_budget_hint': budgetHint,
        'consumerBudgetHint': budgetHint,
      });
      await fetchRequests();
      return data['id']?.toString() ?? data['job']?['id']?.toString();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> addMachine({
    required String name,
    required String type,
    required int year,
  }) async {
    try {
      await ApiService.post(ApiConstants.machines, {
        'name': name,
        'machine_type': type,
        'year_of_manufacture': year,
      });
      await fetchMachines();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateMachine({
    required String id,
    required String name,
    required String type,
    required int year,
  }) async {
    try {
      await ApiService.put('${ApiConstants.machines}/$id', {
        'name': name,
        'machine_type': type,
        'year_of_manufacture': year,
      });
      await fetchMachines();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> approveQuote(String requestId, QuoteModel quote) async {
    try {
      await ApiService.post(
        ApiConstants.approveQuote(requestId, quote.id),
        {},
      );
      await fetchRequests();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> confirmCompletion(String requestId) async {
    try {
      await ApiService.patch('/jobs/$requestId/confirm-complete', {});
      await fetchRequests();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> cancelRequest(String requestId) async {
    try {
      await ApiService.patch('/jobs/$requestId/cancel', {});
      await fetchRequests();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
