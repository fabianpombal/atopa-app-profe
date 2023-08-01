import 'package:atopa_app_flutter/api/authAPI.dart';
import 'package:atopa_app_flutter/main.dart';
import 'package:atopa_app_flutter/providers/language_provider.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? route;
  final int? rol;
  final int? evaluacion;
  CustomAppBar({
    Key ? key, String? route, int? rol, int? evaluacion
  }): preferredSize = Size.fromHeight(70),this.route = route,this.rol = rol,this.evaluacion = evaluacion, super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    final languageProvider = Provider.of < LanguageProvider > (context);
    AuthAPI _authAPI = AuthAPI();
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [Image.asset(
                  'topotrans.png',
                  height: 70,
                  fit: BoxFit.fitHeight,
                  ),
                  Text("ATOPA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (this.route != 'login' && this.evaluacion == 1) ElevatedButton(
                                  child: Text(t!.survey),
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'survey1',
                                      arguments: {
                                        'menu': t.survey
                                      });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: CustomTheme.atopaBlueDark,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    elevation: 15.0,
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                      textStyle:
                                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                  ),
                                ),
                  if (this.route != 'login' && this.evaluacion == 1)
                  SizedBox(width: 40,),
                  if (this.route != 'login') ElevatedButton(
                                  child: Text(t!.account),
                                  onPressed: () {
                                    if (this.route != 'account')
                                    Navigator.pushNamed(context, 'teacher-form',
                                      arguments: {
                                        'menu': t.account
                                      });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: CustomTheme.atopaBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    elevation: 15.0,
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                      textStyle:
                                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                  ),
                                ),
                  SizedBox(width: 40,),
                  if (this.route != 'login' && this.rol == 3) ElevatedButton(
                                  child: Text(t!.myschool),
                                  onPressed: () {
                                    if (this.route != 'school')
                                    Navigator.pushNamed(context, 'colegio-form',
                                      arguments: {
                                        'menu': t.myschool
                                      });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: CustomTheme.atopaBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    elevation: 15.0,
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                      textStyle:
                                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                  ),
                                ),
                  if (this.route != 'login' && this.rol == 3)
                  SizedBox(width: 40,),
                  Icon(Icons.language),
                  SizedBox(width: 5,),
                  DropdownButton < int > (
                    value: languageProvider.currentIndex,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    dropdownColor: CustomTheme.atopaBlue,
                    items: [
                      DropdownMenuItem(child: Text(t!.spanish), value: 0),
                      DropdownMenuItem(
                        child: Text(t.galician), value: 1),
                    ],
                    onChanged: (int ? newValue) {
                      languageProvider.currentIndex = newValue!;
                      MyApp.of(context)!.setLocale(Locale.fromSubtags(languageCode: newValue == 0 ? 'es' : 'gl'));
                    },

                  ),
                  SizedBox(width: 50,),
                  if (this.route != "login") IconButton(
                    onPressed: () async {
                      _authAPI.logout();
                      Navigator.popAndPushNamed(context, 'log-in');
                    },
                    icon: Icon(Icons.logout))
                ], )

            ]
          ),
      ),
      toolbarHeight: 88,
    );
  }
}