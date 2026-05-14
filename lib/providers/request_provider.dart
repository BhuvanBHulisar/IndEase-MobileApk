import 'package:flutter/foundation.dart';
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
      final data = await ApiService.post('/jobs', {
        'machine_id': machine.id,
        'issue_description': issue,
        'urgency': urgency,
        'preferred_date': preferredDate,
        'preferred_slot': preferredSlot,
        'budget_hint': budgetHint,
      });
      await fetchRequests();
      return data['id']?.toString();
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
      await ApiService.post('/machines', {
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
      await ApiService.patch('/machines/$id', {
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
      await ApiService.post('/jobs/$requestId/accept-quote', {
        'quote_id': quote.id,
        'producer_id': quote.id,
        'quoted_cost': quote.total,
      });
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
