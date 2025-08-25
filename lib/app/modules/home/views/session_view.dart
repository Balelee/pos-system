import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/models/session.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';

class SessionView extends GetView<HomeController> {
  const SessionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.orange.shade500,
        title: const ParagraphText(
          text: 'Session des caissiers',
          type: ParagraphType.bodyText1,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final sessions = controller.sessionCashier;
        if (sessions.isEmpty) {
          return const Center(
            child: Text("Aucune session trouvée"),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final Session session = sessions[index];
            return Card(
              child: ListTile(
                title: Text(
                  session.user.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Connecté: ${session.loginTimeFormatted}"),
                    Text(
                      "Déconnecté: ${session.logoutTimeFormatted ?? 'En ligne'}",
                      style: TextStyle(
                        color: session.logoutTimeFormatted == null
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
