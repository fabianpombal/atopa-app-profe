import 'package:atopa_app_flutter/api/authAPI.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/themes/input_decorations.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:atopa_app_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PassRecoveryScreen extends StatelessWidget {
  const PassRecoveryScreen({Key? key}) : super(key: key);

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
                    t!.recover,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const _SignForm(),
              ],
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
  AuthAPI _authAPI = AuthAPI();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    var t = AppLocalizations.of(context);
    return Form(
        key: myFormKey,
        child: Column(
          children: [
            TextFormField(
            autocorrect: false,
            obscureText: false,
            controller: emailController,
            keyboardType: TextInputType.name,
            style: TextStyle(fontSize: 18),
            decoration: InputDecorations.authInputDecoration(
              hint: '',
              label: 'Nombre de usuario',
              icono: Icons.supervised_user_circle),
          ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            ElevatedButton(
              onPressed: () async {
                // showDialog(
                //   context: context,
                //   builder: (context) => Center(
                //     child: CircularProgressIndicator(
                //       color: CustomTheme.atopaBlue,
                //     ),
                //   ),
                //   barrierDismissible: false);
              },
              child: Text('Entrar'),
              style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 15.0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        textStyle:
                            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),),
                        const SizedBox(
                                                    width: 20,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(t!.close),
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.red,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        elevation: 15.0,
                                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                          textStyle:
                                                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                                      ),
                                                  ),]),
          ],
        ));
  }
}
