import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_saas_app/constants/colors.dart';
import 'package:ai_saas_app/providers/premium_providers.dart';
import 'package:ai_saas_app/widgets/show_premium_pannel.dart';
import 'package:ai_saas_app/widgets/user_history.dart';

class HistoryConversions extends StatelessWidget {
  const HistoryConversions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Conversion History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: mainColor,
      ),
      body: Consumer<PremiumProvider>(
        builder: (context, premiumProvider, child) {
          if (premiumProvider.isPremium) {
            return const UserHistory();
          }
          return const ShowPremiumPannel();
        },
      ),
    );
  }
}
