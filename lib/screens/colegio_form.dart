import 'dart:convert';

import 'package:atopa_app_flutter/api/colegioAPI.dart';
import 'package:atopa_app_flutter/api/models/colegio.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:atopa_app_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ColegioFormScreen extends StatelessWidget {
  const ColegioFormScreen({
    Key ? key
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(route: "login", ),
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
              SizedBox(height: 20, ),
              CardContainer(
                color: CustomTheme.whiteTrans,
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  children: [
                    const SizedBox(
                        height: 10,
                      ),
                      Text(
                        t!.signup_school,
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

class _SignFormState extends State < _SignForm > {
  final GlobalKey < FormState > myFormKey = GlobalKey < FormState > ();
  ColegioAPI _colegioAPI = ColegioAPI();
  Colegio ? colegio;
  late bool _enableBtn = false;

  final List<GlobalKey<FormFieldState>> fieldKeys = [GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>(),];
  List<bool>? validados;
  List<TextEditingController>? controllers;

  @override
  void initState() {
    super.initState();
    this.colegio = new Colegio(nombre: '', email: '', localidad: '', fecha_inicio: null);
    this.validados = [false, false, false, true];
    this.controllers = [TextEditingController(text: this.colegio!.nombre),TextEditingController(text: this.colegio!.email),TextEditingController(text:this.colegio!.localidad),
    TextEditingController(text:this.colegio!.fecha_inicio),];
  }

  @override
  Widget build(BuildContext context) {

    var t = AppLocalizations.of(context);
    return Form(
      key: myFormKey,
      child: Column(
        children: [
          CustomInputField(
            controller: this.controllers![0],
            keyField: this.fieldKeys[0],
            icono : Icons.school,
            hintText: '',
            labelText: t!.name,
            helperText: t.required,
            validation: (value) {
              if (value == '') return t.required;
              else if (value!.length < 2) {
                return t.min_characters(2);
              } else {
                return null;
              }
            },
            callback: (name) {
              setState(() {
                this.colegio?.nombre = name;
                this.validados![0] = this.fieldKeys[0].currentState!.validate();
                int aux = this.validados!.where((element) => element == false).length;
                this._enableBtn = aux == 0;
              });
              

            },
          ),
          const SizedBox(
              height: 20,
            ),
            CustomInputField(
              controller: this.controllers![1],
              keyField: this.fieldKeys[1],
              icono : Icons.alternate_email,
              hintText: '',
              labelText: t.email,
              helperText: t.required,
              inputType: TextInputType.emailAddress,
              validation: (value) {
                final regex = RegExp(r'[a-zA-Z0-9_.-]+@[a-zA-Z0-9_.-]+\.[a-zA-Z]+');
                if (value == '') return t.required;
                else if (!regex.hasMatch(value!)) {
                  return t.validEmail;
                } else {
                  return null;
                }
              },
              callback: (email) {
                setState(() {
                  this.colegio?.email = email;
                  this.validados![1] = this.fieldKeys[1].currentState!.validate();
                  int aux = this.validados!.where((element) => element == false).length;
                  this._enableBtn = aux == 0;
                });
                

              },
            ),
            const SizedBox(
                height: 20,
              ),
              CustomInputField(
                controller: this.controllers![2],
                keyField: this.fieldKeys[2],
                icono : Icons.location_city,
                hintText: '',
                labelText: t.city,
                helperText: t.required,
                validation: (value) {
                  if (value == '') return t.required;
                  else if (value!.length < 2) {
                    return t.min_characters(2);
                  } else {
                    return null;
                  }
                },
                callback: (loc) {
                  setState(() {
                    this.colegio?.localidad = loc;
                    this.validados![2] = this.fieldKeys[2].currentState!.validate();
                    int aux = this.validados!.where((element) => element == false).length;
                    this._enableBtn = aux == 0;
                  });
                  

                },
              ),
              const SizedBox(
                  height: 20,
                ),
                CustomInputField(
                  controller: this.controllers![3],
                  keyField: this.fieldKeys[3],
                  icono : Icons.date_range,
                  hintText: 'dd-mm',
                  labelText: t.initial_date,
                  helperText: '',
                  validation: (value) {
                    final regex = RegExp(r'[0-9]{2}-[0-9]{2}');
                    if (value == '') return null;
                    else if (!regex.hasMatch(value!)) {
                      return t.validInitialDate;
                    } else {
                      DateFormat format = DateFormat('dd-MM-yyyy');
                      try {
                        String md = value + '-2022';
                        format.parseStrict(md);
                      } catch (error) {
                        return t.validInitialDate;
                      }
                      
                      return null;
                    }
                  },
                  callback: (fec) {
                    setState(() {
                      this.colegio?.fecha_inicio = fec;
                      this.validados![3] = this.fieldKeys[3].currentState!.validate();
                      int aux = this.validados!.where((element) => element == false).length;
                      this._enableBtn = aux == 0;
                    });
                    

                  },
                ),
                const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [ElevatedButton(
                      onPressed: () {
                        this.colegio = new Colegio(nombre: '', email: '', localidad: '', fecha_inicio: null);
                        this._enableBtn = false;
                        this.validados = [false, false, false, true];
                        for (int i = 0; i < this.controllers!.length; i++) {
                          this.controllers![i].clear();
                        }
                        setState(() {

                          });
                      },
                      child: Text(t.clean),
                        style: ElevatedButton.styleFrom(
                          primary: CustomTheme.atopaBlueDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 15.0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            textStyle:
                            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                    ), ], ),
                  const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: !this._enableBtn ? null : () async {
                            showDialog(
                              context: context,
                              builder: (context) => Center(
                                child: CircularProgressIndicator(
                                  color: CustomTheme.atopaBlue,
                                ),
                              ),
                              barrierDismissible: false);
                            Response value = await _colegioAPI.newColegio(this.colegio!);
                            Navigator.pop(context);
                            if (value.statusCode == 200) {
                              Navigator.pop(context);
                            } else if (value.statusCode == 400) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(t.errorSchoolCreate),
                                    content: Text(json.decode(value.body)['message']),
                                    actions: < Widget > [
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
                          child: Text(t.save),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 15.0,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                textStyle:
                                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                        ),
                        const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(t.close),
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
                          ),

                      ], ),
        ],
      ));
  }
}