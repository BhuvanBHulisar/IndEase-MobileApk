import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/spacing.dart';
import '../../providers/request_provider.dart';
import '../../widgets/quote_card.dart';

class ViewQuotesScreen extends StatelessWidget {
  const ViewQuotesScreen({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestProvider>();
    final quotes = provider.quotesForRequest(requestId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expert Quotes (${quotes.length}/${quotes.length})'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: quotes.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final quote = quotes[index];
          return QuoteCard(
            quote: quote,
            onApprove: () {
              context.read<RequestProvider>().approveQuote(requestId, quote);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Expert confirmed! Proceeding to payment...'),
                ),
              );
              context.go('/requests');
            },
            onAskQuestion: () => context.push('/chat/1'),
          );
        },
      ),
    );
  }
}
