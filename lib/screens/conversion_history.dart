import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:langvify/providers/premium_provider.dart';
import 'package:langvify/widgets/show_premium_panel.dart';
import 'package:langvify/widgets/user_history.dart';

/// Displays conversion history for premium users, or the premium
/// activation panel for non-premium users.
class HistoryConversions extends StatefulWidget {
  const HistoryConversions({super.key});

  @override
  State<HistoryConversions> createState() => _HistoryConversionsState();
}

class _HistoryConversionsState extends State<HistoryConversions> {
  @override
  void initState() {
    super.initState();
    // Check premium status once on init — NOT on every build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PremiumProvider>(context, listen: false).checkPremiumStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPremiumProvider = Provider.of<PremiumProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History Conversions',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            )),
      ),
      body: isPremiumProvider.isPremium
          ? const UserHistory()
          : const ShowPremiumPanel(),
    );
  }
}
