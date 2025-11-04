import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/components/bouton/bouton.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/sale_historique_controller.dart';

class BilanVentesView extends GetView<SaleHistoriqueController> {
  const BilanVentesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ParagraphText(
          text: "Bilan des ventes",
          type: ParagraphType.bodyText1,
          color: Colors.white,
        ),
        backgroundColor: Colors.indigo.shade400,
        leading: BackButton(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.sales.isEmpty) {
          return Center(child: Text("Aucune vente trouvée"));
        }

        // Filtrer uniquement sur le jour sélectionné
        final filteredSales = controller.sales.where((sale) {
          final selected = controller.selectedDate.value;
          return selected != null ? isSameDay(sale.date, selected) : true;
        }).toList();

        final totalAmount =
            filteredSales.fold<double>(0, (sum, sale) => sum + sale.total);
        final totalVentes = filteredSales.length;

        return SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendrier
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() => TableCalendar(
                      firstDay: DateTime(2020),
                      lastDay: DateTime(2100),
                      focusedDay: controller.focusedDay.value,
                      selectedDayPredicate: (day) =>
                          isSameDay(day, controller.selectedDate.value),
                      onDaySelected: (selectedDay, focusedDay) {
                        controller.focusedDay.value = focusedDay;
                        controller.selectedDate.value = selectedDay;
                      },
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.indigo,
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                    )),
              ),

              SizedBox(height: 8),

              // Bouton Réinitialiser la date
              if (controller.selectedDate.value != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      controller.selectedDate.value = null;
                    },
                    icon: Icon(Icons.refresh, color: Colors.indigo),
                    label: Text(
                      "Réinitialiser",
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ),

              SizedBox(height: 16),

              // Totaux
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(
                      "N° de Ventes", "$totalVentes", Colors.orange.shade300),
                  _buildStatCard(
                      "Total de vente",
                      "${totalAmount.toStringAsFixed(0)} CFA",
                      Colors.indigo.shade300),
                ],
              ),

              SizedBox(height: 16),
              Text(
                "Détails des ventes",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),

              // Liste des ventes
              if (filteredSales.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      controller.selectedDate.value != null
                          ? "Aucune vente trouvée pour le jour sélectionné"
                          : "Aucune vente trouvée",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredSales.length,
                  itemBuilder: (context, index) {
                    final sale = filteredSales[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          "Vente par ${sale.user?.username ?? ''}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Total: ${sale.total.toStringAsFixed(0)} CFA\n"
                          "Date: ${DateFormat('dd-MM-yyyy HH:mm').format(sale.date!)}",
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                              color: Colors.indigo.shade300,
                              borderRadius: BorderRadius.circular(5)),
                          width: 70,
                          height: 40,
                          child: CustomButton(
                            text: "Réçu",
                            fontSize: 10,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      }),
    );
  }

  // Carte de statistique
  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: Get.width / 2.2,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white)),
            SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
