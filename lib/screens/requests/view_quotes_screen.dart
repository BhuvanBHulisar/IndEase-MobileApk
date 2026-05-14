import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/spacing.dart';
import '../../providers/request_provider.dart';
import '../../widgets/quote_card.dart';

class ViewQuotesScreen extends StatefulWidget {
  const ViewQuotesScreen({super.key, required this.requestId});

  final String requestId;

  @override
  State<ViewQuotesScreen> createState() => _ViewQuotesScreenState();
}

class _ViewQuotesScreenState extends State<ViewQuotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<RequestProvider>()
          .fetchQuotesForRequest(widget.requestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestProvider>();
    final quotes = provider.quotesForRequest(widget.requestId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expert Quotes (${quotes.length})'),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : quotes.isEmpty
              ? const Center(
                  child: Text(
                    'No quotes received yet.\nCheck back soon.',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: quotes.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final quote = quotes[index];
                    return QuoteCard(
                      quote: quote,
                      onApprove: () async {
                        await context
                            .read<RequestProvider>()
                            .approveQuote(widget.requestId, quote);
                        if (context.mounted) {
                          context.go('/payment/${widget.requestId}');
                        }
                      },
                      onAskQuestion: () =>
                          context.push('/chat/${quote.id}'),
                    );
                  },
                ),
    );
  }
}
