import 'dart:typed_data';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:pos/app/models/sale.dart';

class PrintService {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  Future<void> printSale(Sale sale) async {
    try {
      bool? isConnected = await bluetooth.isConnected;
      if (isConnected == true) {
        await bluetooth.disconnect();
      }
      List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
      if (devices.isEmpty) {
        throw Exception("Aucune imprimante Bluetooth trouvée !");
      }
      await bluetooth.connect(devices.first);
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];
      bytes += generator.text(
        'RECU DE VENTE',
        styles: PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            fontType: PosFontType.fontA),
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
        "Paiement:${sale.paymentMethod.toString()}",
        styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            fontType: PosFontType.fontB),
      );
      bytes += generator.hr();
      for (var sold in sale.soldArticles) {
        bytes += generator.text(
          "${(sold.article?.label ?? '').padRight(10)}  X${sold.quantity}  ${(sold.quantity * sold.article!.unit_price!).toStringAsFixed(0)}",
          styles: PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              fontType: PosFontType.fontB),
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
            fontType: PosFontType.fontB),
      );
      bytes += generator.feed(1);
      bytes += generator.text(
        "Merci pour votre achat !",
        styles: PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            fontType: PosFontType.fontA),
      );
      bytes += generator.feed(2);
      bytes += generator.cut();
      await bluetooth.writeBytes(Uint8List.fromList(bytes));
    } catch (e) {
      throw Exception("Erreur d’impression: $e");
    }
  }
}
