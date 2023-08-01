import 'dart:convert';

import 'package:atopa_app_flutter/api/authAPI.dart';
import 'package:atopa_app_flutter/api/colegioAPI.dart';
import 'package:atopa_app_flutter/api/models/colegio.dart';
import 'package:atopa_app_flutter/api/models/preferencias.dart';
import 'package:atopa_app_flutter/api/models/user.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:atopa_app_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TeacherForm extends StatefulWidget {
  const TeacherForm({
    Key ? key,
  }): super(key: key);

  @override
  State < TeacherForm > createState() => _TeacherFormState();
}

class _TeacherFormState extends State < TeacherForm > {
  int? rol;
  int? evaluacion;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      this.rol = await prefs.getInt('rol') ?? 2;
      this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
      setState(() {});
    });

  }
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(rol: this.rol, evaluacion: this.evaluacion,route: 'account',),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(height: 10, ),
            Row(children: [BreadCrumbNavigator()],
              mainAxisAlignment: MainAxisAlignment.start, ),
            SizedBox(height: 10, ),
            CardContainer(
              color: CustomTheme.whiteTrans,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(
                      height: 10,
                    ),
                    Text(
                      t!.edit_account,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    _SignForm(),
                ],
              ),
            ),
          ])),
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
  // late bool _passwordVisible;
  // late bool _passwordVisible2;
  User ? user;
  User ? copyUser;
  Preferencias ? preferencias;
  Preferencias ? copyPreferencias;
  late bool _enableBtn = false;
  // late List < FocusNode > focusNodes = [];
  final GlobalKey < FormState > myFormKey = GlobalKey < FormState > ();
  AuthAPI _authAPI = AuthAPI();
  ColegioAPI _colegioAPI = ColegioAPI();
  List < DropdownMenuItem < int >> ? colegiosDrop;

  final List < GlobalKey < FormFieldState >> fieldKeys = [GlobalKey < FormFieldState > (), GlobalKey < FormFieldState > (), GlobalKey < FormFieldState > (), GlobalKey < FormFieldState > (),
    GlobalKey < FormFieldState > ()];
  List < bool > validados = [true, true, true, true, true];
  List < TextEditingController > ? controllers;

  @override
  void initState() {
    super.initState();
    // _passwordVisible = false;
    // _passwordVisible2 = false;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await getColegiosDrop();
      this.user = await this._authAPI.getLoggedIn();
      this.preferencias = await this._authAPI.getPreferencias(this.user!.user!);
      setState(() {
        
        this.copyUser = this.user?.copy();
        this.copyPreferencias = this.preferencias?.copy();
        this._enableBtn = true;
        this.validados = [true, true, true, true, true];

        this.controllers = [TextEditingController(text: this.user!.nombre), TextEditingController(text: this.user!.apellidos), TextEditingController(text: this.user!.email),
          TextEditingController(text: this.user!.DNI), TextEditingController(text: this.user!.username),
        ];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getColegiosDrop() async {
    List < Colegio > colegios = [];
    colegios = await _colegioAPI.getColegios();
    this.colegiosDrop = [];
    colegios.forEach((element) {
      this.colegiosDrop!.add(DropdownMenuItem(child: Text(element.nombre), value: element.id, ));
    });
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Form(
      key: myFormKey,
      child: this.user != null ? Column(
        children: [
          CustomInputField(
            controller: this.controllers![0],
            keyField: this.fieldKeys[0],
            icono: Icons.person,
            hintText: '',
            labelText: t!.name,
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
            callback: (name) {
              this.user?.nombre = name;
              this.validados[0] = this.fieldKeys[0].currentState!.validate();
              int aux = this.validados.where((element) => element == false).length;
              setState(() {
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
              icono: Icons.person_outline,
              hintText: '',
              labelText: t.surnames,
              helperText: t.required,
              // focusNode: this.focusNodes[1],
              validation: (value) {
                if (value == '') return t.required;
                else if (value!.length < 2) {
                  return t.min_characters(2);
                } else {
                  return null;
                }
              },
              callback: (apellidos) {
                this.user?.apellidos = apellidos;
                this.validados[1] = this.fieldKeys[1].currentState!.validate();
                int aux = this.validados.where((element) => element == false).length;
                setState(() {
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
                icono: Icons.alternate_email,
                hintText: '',
                labelText: t.email,
                helperText: t.required,
                // focusNode: this.focusNodes[2],
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
                  this.user?.email = email;
                  this.validados[2] = this.fieldKeys[2].currentState!.validate();
                  int aux = this.validados.where((element) => element == false).length;
                  setState(() {
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
                  icono: Icons.card_membership,
                  hintText: '',
                  labelText: t.dni,
                  helperText: '',
                  // focusNode: this.focusNodes[3],
                  validation: (value) {
                    if (value == null || value == '') return null;
                    else if (value.length < 9 && value.length > 0) {
                      return t.min_characters(9);
                    } else {
                      return null;
                    }
                  },
                  callback: (dni) {
                    this.user?.DNI = dni;
                    this.validados[3] = this.fieldKeys[3].currentState!.validate();
                    int aux = this.validados.where((element) => element == false).length;
                    setState(() {
                      this._enableBtn = aux == 0;
                    });
                  },
                ),
                const SizedBox(
                    height: 20,
                  ),
                  CustomInputField(
                    controller: this.controllers![4],
                    keyField: this.fieldKeys[4],
                    icono: Icons.supervised_user_circle,
                    hintText: '',
                    labelText: t.username,
                    helperText: t.required,
                    // focusNode: this.focusNodes[4],
                    validation: (value) {
                      if (value == '') return t.required;
                      else if (value!.length < 2) {
                        return t.min_characters(2);
                      } else {
                        return null;
                      }
                    },
                    callback: (user) {
                      this.user?.username = user;
                      this.validados[4] = this.fieldKeys[4].currentState!.validate();
                      int aux = this.validados.where((element) => element == false).length;
                      setState(() {
                        this._enableBtn = aux == 0;
                      });
                    },
                  ),
                  const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Row(children: [
                          Switch(
                            value: this.user!.evaluacion == 1 ? true: false,
                            onChanged: (bool ? value) {
                              setState(() {
                                this.user!.evaluacion = value! ? 1 : 0;
                              });
                            },
                          ),
                          SizedBox(width: 30),
                          Flexible(child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                                children: < TextSpan > [
                                  TextSpan(text: t.survey_accept)
                                ],
                            )))
                        ]),
                        SizedBox(height: 18, )
                      ], ),
                      const SizedBox(
                    height: 20,
                  ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: CustomTheme.atopaGrey, width: 1),
                      ),
                      // width: (2 * MediaQuery.of(context).size.width) / 3,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child:
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                            crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                            children: [
                              Text(
                                t.apartados,
                                style: Theme.of(context).textTheme.headline6,
                              )
                            ]),
                          Divider(
                            height: 30,
                            color: Colors.black
                          ),
                          Column(children: [
                            Column(
                              children: [
                                Row(children: [
                                  Checkbox(
                                    value: this.preferencias!.sp == 1 ? true: false,
                                    onChanged: (bool ? value) {
                                      setState(() {
                                        this.preferencias!.sp = value! ? 1 : 0;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 30),
                                  Flexible(child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                      children: < TextSpan > [
                                        TextSpan(text: t.spPref1, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: t.spPref2),
                                      ],
                                  )))
                                  ]),
                                SizedBox(height: 18, )
                              ], ),
                              Column(
                              children: [
                                Row(children: [
                                  Checkbox(
                                    value: this.preferencias!.ep == 1 ? true: false,
                                    onChanged: (bool ? value) {
                                      setState(() {
                                        this.preferencias!.ep = value! ? 1 : 0;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 30),
                                  Flexible(child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                      children: < TextSpan > [
                                        TextSpan(text: t.epPref1, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: t.epPref2),
                                      ],
                                  )))
                                  ]),
                                SizedBox(height: 18, )
                              ], ),
                              Column(
                              children: [
                                Row(children: [
                                  Checkbox(
                                    value: this.preferencias!.ip == 1 ? true: false,
                                    onChanged: (bool ? value) {
                                      setState(() {
                                        this.preferencias!.ip = value! ? 1 : 0;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 30),
                                  Flexible(child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                      children: < TextSpan > [
                                        TextSpan(text: t.ipPref1, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: t.ipPref2),
                                      ],
                                  )))
                                  ]),
                                SizedBox(height: 18, )
                              ], ),
                              Column(
                              children: [
                                Row(children: [
                                  Checkbox(
                                    value: this.preferencias!.pp == 1 ? true: false,
                                    onChanged: (bool ? value) {
                                      setState(() {
                                        this.preferencias!.pp = value! ? 1 : 0;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 30),
                                  Flexible(child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                      children: < TextSpan > [
                                        TextSpan(text: t.ppPref1, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: t.ppPref2),
                                      ],
                                  )))
                                  ]),
                                SizedBox(height: 18, )
                              ], ),
                              Column(
                              children: [
                                Row(children: [
                                  Checkbox(
                                    value: this.preferencias!.ipp == 1 ? true: false,
                                    onChanged: (bool ? value) {
                                      setState(() {
                                        this.preferencias!.ipp = value! ? 1 : 0;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 30),
                                  Flexible(child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                      children: < TextSpan > [
                                        TextSpan(text: t.ippPref1, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: t.ippPref2),
                                      ],
                                  )))
                                  ]),
                                SizedBox(height: 18, )
                              ], ),
                              Column(
                              children: [
                                Row(children: [
                                  Checkbox(
                                    value: this.preferencias!.ic == 1 ? true: false,
                                    onChanged: (bool ? value) {
                                      setState(() {
                                        this.preferencias!.ic = value! ? 1 : 0;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 30),
                                  Flexible(child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                      children: < TextSpan > [
                                        TextSpan(text: t.icPref1, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: t.icPref2),
                                      ],
                                  )))
                                  ]),
                                SizedBox(height: 18, )
                              ], ),
                              Column(
                              children: [
                                Row(children: [
                                  Checkbox(
                                    value: this.preferencias!.data == 1 ? true: false,
                                    onChanged: (bool ? value) {
                                      setState(() {
                                        this.preferencias!.data = value! ? 1 : 0;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 30),
                                  Flexible(child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                      children: < TextSpan > [
                                        TextSpan(text: t.dataPref1, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: t.dataPref2),
                                      ],
                                  )))
                                  ]),
                                SizedBox(height: 18, )
                              ], ),
                          ], ),
                        ]),

                    ),
                    SizedBox(height: 40, ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [ElevatedButton(
                        onPressed: () {
                          this.user = this.copyUser!.copy();
                          this.preferencias = this.copyPreferencias!.copy();
                          // _passwordVisible = false;
                          // _passwordVisible2 = false;
                          this.validados = [true, true, true, true, true];
                          this._enableBtn = true;
                          this.controllers![0].text = this.user!.nombre;
                          this.controllers![1].text = this.user!.apellidos;
                          this.controllers![2].text = this.user!.email;
                          this.controllers![3].text = this.user!.DNI!;
                          this.controllers![4].text = this.user!.username;

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
                        height: 25,
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

                              Map < String, Object ? > jsonOriginal = this.copyUser!.toJson();
                              Map < String, dynamic > body = {};
                              this.user?.toJson().forEach((key, value) {
                                if (jsonOriginal[key] != value) {
                                  body[key] = value;
                                }
                              });
                              if (body.isNotEmpty) {

                                var req = await _authAPI.updateProfesor(body, this.user!.profesor!);
                                if (req.statusCode == 200) {
                                  Map < String, Object ? > jsonOriginal = this.copyPreferencias!.toJson();
                                  Map < String, dynamic > body = {};
                                  this.preferencias?.toJson().forEach((key, value) {
                                    if (jsonOriginal[key] != value) {
                                      body[key] = value;
                                    }
                                  });
                                  if (body.isNotEmpty) {

                                    var req = await _authAPI.updatePreferencias(body, this.user!.profesor!);
                                    Navigator.pop(context);
                                    if (req.statusCode == 200) {
                                      Navigator.pop(context);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text(t.errorPrefUp),
                                            content: Text(json.decode(req.body)['message']),
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
                                  } else {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(t.errorUserUp),
                                        content: Text(json.decode(req.body)['message']),
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
                              } else {
                                Map < String, Object ? > jsonOriginal = this.copyPreferencias!.toJson();
                                  Map < String, dynamic > body = {};
                                  this.preferencias?.toJson().forEach((key, value) {
                                    if (jsonOriginal[key] != value) {
                                      body[key] = value;
                                    }
                                  });
                                  if (body.isNotEmpty) {

                                    var req = await _authAPI.updatePreferencias(body, this.user!.profesor!);
                                    Navigator.pop(context);
                                    if (req.statusCode == 200) {
                                      Navigator.pop(context);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text(t.errorPrefUp),
                                            content: Text(json.decode(req.body)['message']),
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
                                  } else {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
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
                            ), ),
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
                        ]),
        ],
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(
          child: CircularProgressIndicator(),
        )],
      )
    );
  }
}