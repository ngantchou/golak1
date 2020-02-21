import 'package:url_launcher/url_launcher.dart';

class CallsAndMessages {
  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number");
  void whatsapp(String number, callback) async {
    var whatsappUrl = "whatsapp://send?phone=$number";
    await canLaunch(whatsappUrl) ? launch(whatsappUrl) : callback();
  }

  void sendEmail(List<String> emails, String subject, String body) async {
    var url = 'mailto:${emails.join(';')}?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
