import 'dart:io';
import 'dart:typed_data';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:pos/app/data/components/text/text.dart';
import 'package:pos/app/data/database/model_repository/configuration_repository.dart';
import 'package:pos/app/models/sale.dart';
import 'package:image/image.dart' as img;

class PrintService {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final configRepo = CompanyRepository();
  Future<BluetoothDevice?> choosePrinter(BuildContext context) async {
    List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
    if (devices.isEmpty) {
      throw Exception("Aucune imprimante Bluetooth trouvée !");
    }

    return await showDialog<BluetoothDevice>(
      context: context,
      builder: (context) => SimpleDialog(
        title: ParagraphText(
          text: "Choisir une imprimante",
          type: ParagraphType.bodyText1,
        ),
        children: devices.map((device) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, device),
            child: Text(
              device.name ?? device.address ?? "",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }

  String truncateLabel(String label, {int maxLength = 15}) {
    if (label.length <= maxLength) return label;
    return label.substring(0, maxLength - 3) + '...';
  }

  Future<void> printSale(Sale sale, BuildContext context) async {
    try {
      final printer = await choosePrinter(context);
      if (printer == null) return;
      bool? isConnected = await bluetooth.isConnected;
      if (isConnected == true) await bluetooth.disconnect();
      await bluetooth.connect(printer);
      final config = await configRepo.getCompany();
      final profile = await CapabilityProfile.load();
      final paperSize = PaperSize.mm80;
      final generator = Generator(paperSize, profile);
      List<int> bytes = [];
      if (config?.logoPath != null && config!.logoPath!.isNotEmpty) {
        try {
          final file = File(config.logoPath!);
          if (await file.exists()) {
            final Uint8List logoBytes = await file.readAsBytes();
            final img.Image? logoImage = img.decodeImage(logoBytes);
            if (logoImage != null) {
              final img.Image resizedLogo =
                  img.copyResize(logoImage, width: 60, height: 60);
              bytes += generator.imageRaster(resizedLogo);
            }
          }
        } catch (e) {}
      }
      bytes += generator.feed(1);
      bytes += generator.text(
        'RECU DE VENTE',
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          fontType: PosFontType.fontB,
        ),
      );
      bytes += generator.hr(ch: '=', linesAfter: 0);
      bytes += generator.text(
        "Vendeur: ${sale.user?.username ?? ''}",
        styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            fontType: PosFontType.fontB),
      );
      bytes += generator.feed(1);
      bytes += generator.text(
        "Date:${DateFormat('dd/MM/yyyy HH:mm').format(sale.date!)}",
        styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            fontType: PosFontType.fontB),
      );
      bytes += generator.feed(1);
      bytes += generator.text(
        "Paiement: ${sale.paymentMethod ?? ''}",
        styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            fontType: PosFontType.fontB),
      );
      bytes += generator.hr();
      for (var sold in sale.soldArticles) {
        final label = truncateLabel(sold.article?.label ?? '');
        final quantity = sold.quantity;
        final total = (sold.quantity * (sold.article?.unit_price ?? 0))
            .toStringAsFixed(0);
        bytes += generator.text(
          "$label  X$quantity  $total",
          styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            fontType: PosFontType.fontB,
          ),
        );
        bytes += generator.feed(1);
      }
      bytes += generator.hr(ch: '-', linesAfter: 0);
      bytes += generator.text(
        "TOTAL: ${sale.total.toStringAsFixed(0)} CFA",
        styles: PosStyles(
          bold: true,
          align: PosAlign.right,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          fontType: PosFontType.fontB,
        ),
      );
      bytes += generator.feed(1);
      bytes += generator.text(
        "Merci pour votre achat !",
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          fontType: PosFontType.fontB,
        ),
      );
      bytes += generator.feed(1);
      bytes += generator.text(
        "Contact: ${config?.phone ?? ''}",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          fontType: PosFontType.fontB,
        ),
      );
      bytes += generator.feed(2);
      bytes += generator.cut();
      await bluetooth.writeBytes(Uint8List.fromList(bytes));
    } catch (e) {
      throw Exception("Erreur d’impression: $e");
    }
  }
}
