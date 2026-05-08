import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/request_provider.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({super.key, required this.requestId});
  final String requestId;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RequestProvider>();
    final request = provider.requestById(requestId);
    final quotes = provider.quotesForRequest(requestId);
    final quote = quotes.isNotEmpty ? quotes.first : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(children: [
                _row('Machine', request?.machineName ?? '-'),
                _row('Expert', quote?.expertName ?? '-'),
                _row('Service', 'Machine Repair & Maintenance'),
                const Divider(height: 24),
                _row('Base Cost', '₹${quote?.total ?? 0}'),
                _row('Platform Fee (5%)', '₹${((quote?.total ?? 0) * 0.05).toStringAsFixed(0)}'),
                _row('GST (18% on fee)', '₹${((quote?.total ?? 0) * 0.05 * 0.18).toStringAsFixed(0)}'),
              ]),
            ),
            const Spacer(),
            // Total payable
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF00685F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TOTAL PAYABLE',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('₹${((quote?.total ?? 0) * 1.059).toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00685F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => context.go('/payment/$requestId/success'),
                child: const Text('Pay Now', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    ),
  );
}
