import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/components/custom_dialogue.dart';
import 'package:pos/app/modules/register/controllers/register_controller.dart';
import 'package:pos/app/modules/register/views/register_view.dart';

class QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Map<String, String>? subTitles;
  final VoidCallback? onTap;
  final Color color;
  final Color iconquicard;
  final Color arrowColor;
  final bool isAuthorized;

  const QuickAccessCard({
    Key? key,
    required this.icon,
    required this.title,
    this.subTitles,
    this.onTap,
    this.color = Colors.blueGrey,
    this.iconquicard = Colors.white,
    this.arrowColor = Colors.white,
    this.isAuthorized = true,
  }) : super(key: key);

  void _handleTap(VoidCallback? callback) {
    if (isAuthorized) {
      callback?.call();
    } else {
      AccessDeniedDialog.show(featureName: title);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (subTitles == null || subTitles!.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color, width: 1),
        ),
        elevation: 4,
        child: ListTile(
          leading: Icon(icon, color: iconquicard),
          title: Text(
            title,
            style: TextStyle(
              color: isAuthorized ? Colors.black : Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            isAuthorized ? Icons.arrow_forward_ios : Icons.lock,
            color: isAuthorized ? arrowColor : Colors.grey,
            size: 20,
          ),
          onTap: () => _handleTap(onTap),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 1),
      ),
      elevation: 4,
      child: ExpansionTile(
        leading: Icon(icon, color: iconquicard),
        title: Text(
          title,
          style: TextStyle(
            color: isAuthorized ? Colors.black : Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          isAuthorized ? null : Icons.lock,
          color: isAuthorized ? arrowColor : Colors.grey,
          size: 20,
        ),
        children: subTitles!.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            contentPadding: const EdgeInsets.only(left: 60, right: 16),
            onTap: () => _handleTap(() {
              if (entry.value == "bottomsheet") {
                Get.put(RegisterController());
                Get.bottomSheet(
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: RegisterView(),
                  ),
                );
              } else {
                Get.toNamed(entry.value);
              }
            }),
          );
        }).toList(),
      ),
    );
  }
}
