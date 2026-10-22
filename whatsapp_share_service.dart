import 'package:share_plus/share_plus.dart';

class WhatsAppShareService {
  static Future<void> shareFile(String filePath, String text) async {
    await Share.shareXFiles([XFile(filePath)], text: text);
  }
}
