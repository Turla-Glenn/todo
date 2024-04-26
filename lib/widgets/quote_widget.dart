import 'package:flutter/material.dart';
import '../services/quote_service.dart';

class QuoteWidget extends StatefulWidget {
  final QuoteService quoteService;

  QuoteWidget({required this.quoteService});

  @override
  _QuoteWidgetState createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  late Future<String> _quoteFuture;

  @override
  void initState() {
    super.initState();
    _quoteFuture = widget.quoteService.fetchDailyQuote();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _quoteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Failed to load quote');
        } else {
          return Center(
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),

              ),
              child: Text(
                snapshot.data.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
    );
  }
}
