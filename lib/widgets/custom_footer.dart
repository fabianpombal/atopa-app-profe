import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomFooterBar extends StatelessWidget {
  const CustomFooterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Container(
      height: 80,
      color: CustomTheme.atopaGreyTrans,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () async {
            const url = 'https://www.atopa.es/pdd.html';
            if (await canLaunch(url)) {
              await launch(url, forceWebView: true);
            }
          },
          child: Text(t!.legal, style: TextStyle(fontSize: 18),)),
        InkWell(
          onTap: () async {
              const url = 'https://www.atopa.es/contacto.html';
              if (await canLaunch(url)) {
                await launch(url, forceWebView: true);
              }
            },
          child: Image.asset(
            'teavilogograndecontacto-small.jpg',
            height: 80,
          ),),
        TextButton(
          onPressed: () async {
            const url = 'https://www.atopa.es/agradecimientos.html';
            if (await canLaunch(url)) {
              await launch(url, forceWebView: true);
            }
          },
          child: Text(t.ack, style: TextStyle(fontSize: 18),))
      ]
      ));
  }
}
