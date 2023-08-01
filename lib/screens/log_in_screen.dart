import 'dart:convert';

import 'package:atopa_app_flutter/api/authAPI.dart';
import 'package:atopa_app_flutter/api/token.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:atopa_app_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:shared_preferences/shared_preferences.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({
    Key ? key,
  }): super(key: key);

@override
  State < LogInPage > createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(route: "login",),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset(
            'topotrans.png',
            height: 150,
          ),
          SizedBox(height: 25, ),
          CardContainer(
            color: CustomTheme.whiteTrans,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              children: [
                const SizedBox(
                    height: 10,
                  ),
                  Text(
                    t!.login,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const _SignForm(),
              ],
            ),
          ),
          SizedBox(height: 25, ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'pass-recovery');
            },
            child: Text(t.forgot),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  textStyle: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ), ),
          const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'sign-up');
              },
              child: Text(t.no_account),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            ),
          ])]),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
          persistentFooterButtons: const [
          CustomFooterBar()
        ],
    );
  }
}

class _SignForm extends StatefulWidget {
  const _SignForm({
    Key ? key
  }): super(key: key);

  @override
  State < _SignForm > createState() => _SignFormState();
}

class _SignFormState extends State<_SignForm> {
  final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  final List<GlobalKey<FormFieldState>> fieldKeys = [GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>()];
  List<bool> validados = [false, false];
  late bool _passwordVisible;
  String? name;
  String? pass;
  late bool _enableBtn = false;
  // late List < FocusNode > focusNodes = [];
  AuthAPI _authAPI = AuthAPI();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    // for (int i = 0; i < 2; i++) {
    //   FocusNode focusNode = new FocusNode();
    //   focusNode.addListener(() {
    //     if (!focusNode.hasFocus) {
    //       setState(() {
    //         _enableBtn = myFormKey.currentState!.validate();
    //       });
    //     }
    //   });
    //   focusNodes.add(focusNode);
    // }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Form(
      key: myFormKey,
      child: Column(
        children: [
          CustomInputField(
              keyField: this.fieldKeys[0], //Key(this.name ?? ''),
              initialValue: this.name,
              icono: Icons.supervised_user_circle,
              hintText : '',
              labelText: t!.username,
              helperText: t.required,
              // focusNode: this.focusNodes[0],
              validation: (value) {
                if (value == '') return t.required;
                else if (value!.length < 2) {
                  return t.min_characters(2);
                } else {
                  return null;
                }
              },
              callback: (user) {
                this.name = user;
                this.validados[0] = this.fieldKeys[0].currentState!.validate();
                int aux = this.validados.where((element) => element == false).length;
                setState(() {
                  this._enableBtn = aux == 0;
                });

              },
            ),
          CustomInputField(
              keyField: this.fieldKeys[1], //Key(this.pass ?? ''),
              initialValue: this.pass,
              hintText : '',
              labelText: t.password,
              helperText: t.required,
              // focusNode: this.focusNodes[1],
              validation: (value) {
                if (value == '') return t.required;
                else if (value!.length < 6) {
                  return t.min_characters(6);
                } else {
                  return null;
                }
              },
              callback: (user) {
                this.pass = user;
                this.validados[1] = this.fieldKeys[1].currentState!.validate();
                int aux = this.validados.where((element) => element == false).length;
                setState(() {
                  this._enableBtn = aux == 0;
                });
                

              },
              password: !_passwordVisible,
              icono: Icons.password,
              suffix: IconButton(
              icon: Icon(
                _passwordVisible
                ? Icons.visibility
                : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                      _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ),
          const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: !_enableBtn ? null : () async {
                showDialog(
                  context: context,
                  builder: (context) => Center(
                    child: CircularProgressIndicator(
                      color: CustomTheme.atopaBlue,
                    ),
                  ),
                  barrierDismissible: false);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  var req = await _authAPI.login(this.name!.trim(), this.pass!.trim());
                  if (req.statusCode == 200) {
                    Token token = Token.fromJson(jsonDecode(req.body));
                    await prefs.setString('jwt', token.token);
                    await prefs.setString('jwt-refresh', token.refresh);
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, 'years', arguments: {'menu': t.years});
                  } else {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(t.error),
                        content: Text(json.decode(req.body)['message']),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              child: Text(t.ok),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              },
              child: Text(t.go),
              style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 15.0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        textStyle:
                            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),)
        ],
      ));
  }


}