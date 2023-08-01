import 'dart:convert';

import 'package:atopa_app_flutter/api/authAPI.dart';
import 'package:atopa_app_flutter/api/colegioAPI.dart';
import 'package:atopa_app_flutter/api/models/colegio.dart';
import 'package:atopa_app_flutter/api/models/user.dart';
import 'package:atopa_app_flutter/api/token.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/themes/input_decorations.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:atopa_app_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key ? key,
  }): super(key: key);

  @override
  State < SignUpScreen > createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State < SignUpScreen > {

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
                height: 110,
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
                        t!.signup,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      _SignForm(),
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
  late bool _passwordVisible;
  late bool _passwordVisible2;
  User ? user;
  late bool _enableBtn = false;
  // late List < FocusNode > focusNodes = [];
  final GlobalKey < FormState > myFormKey = GlobalKey < FormState > ();
  AuthAPI _authAPI = AuthAPI();
  ColegioAPI _colegioAPI = ColegioAPI();
  List < DropdownMenuItem < int >> ? colegiosDrop;
  List < Colegio > ? colegios;

  final List < GlobalKey < FormFieldState >> fieldKeys = [GlobalKey < FormFieldState > (), GlobalKey < FormFieldState > (), GlobalKey < FormFieldState > (), GlobalKey < FormFieldState > (),
    GlobalKey < FormFieldState > (), GlobalKey < FormFieldState > (), GlobalKey < FormFieldState > (), GlobalKey < FormFieldState > (), GlobalKey < FormFieldState > ()
  ];
  List < bool > validados = [false, false, false, false, true, false, false, false, false, false, false];
  List < TextEditingController > ? controllers;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _passwordVisible2 = false;
    this.user = new User(nombre: '', apellidos: '', DNI: null, colegio: null, rol: null, evaluacion: 1,
      email: '', username: '', validado: 0, password: '', password2: '');
    this.controllers = [TextEditingController(text: this.user!.nombre), TextEditingController(text: this.user!.apellidos), TextEditingController(text: this.user!.email),
      TextEditingController(text: this.user!.DNI), TextEditingController(text: this.user!.username),
      TextEditingController(text: this.user!.password), TextEditingController(text: this.user!.password2)
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getColegiosDrop();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getColegiosDrop() async {
    this.colegios = await _colegioAPI.getColegios();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Form(
      key: myFormKey,
      child: this.colegios != null ? Column(
        children: [
          DropdownButtonFormField < int > (
            key: this.fieldKeys[0],
            isExpanded: true,
            value: this.user != null ? this.user?.colegio : null,
            items : this.colegios!.map((e) {
              return DropdownMenuItem < int > (child: Text(e.nombre, style: this.user?.colegio == e.id ? TextStyle(color: CustomTheme.atopaBlue) : null), value: e.id, );
            }).toList(),
            validator: (value) => value == null ? t!.required : null,
            onChanged: (value) async {
              setState(() {
                this.user?.colegio = value;
                this.validados[0] = this.fieldKeys[0].currentState!.validate();
                int aux = this.validados.where((element) => element == false).length;
                this._enableBtn = aux == 0;
              });

            },
            selectedItemBuilder: (BuildContext context) {
              return this.colegios!.map((e) {
                return DropdownMenuItem < int > (child: Text(e.nombre), value: e.id, );
              }).toList();
            },
            decoration: InputDecorations.authInputDecoration(hint: '', label: t!.school, helperText: t.required, icono: Icons.school),
          ),
          const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'new-colegio').then((value) async {
                  await getColegiosDrop();
                  setState(() {

                  });
                });
              },
              child: Text(t.no_school),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
                height: 20,
              ),
              CustomInputField(
                controller: this.controllers![0],
                keyField: this.fieldKeys[1],
                icono: Icons.person,
                hintText: '',
                labelText: t.name,
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
                  controller: this.controllers![1],
                  keyField: this.fieldKeys[2],
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
                    controller: this.controllers![2],
                    keyField: this.fieldKeys[3],
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
                      controller: this.controllers![3],
                      keyField: this.fieldKeys[4],
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
                      DropdownButtonFormField < int > (
                        key: this.fieldKeys[5],
                        isExpanded: true,
                        value: this.user != null ? this.user?.rol : null,
                        items : [
                          DropdownMenuItem(
                            child: Text(t.teacher, style: this.user?.rol == 2 ? TextStyle(color: CustomTheme.atopaBlue) : null), value: 2),
                          DropdownMenuItem(child: Text(t.admin, style: this.user?.rol == 3 ? TextStyle(color: CustomTheme.atopaBlue) : null), value: 3),
                        ],
                        selectedItemBuilder: (BuildContext context) {
                          return [
                            DropdownMenuItem(
                              child: Text(t.teacher), value: 2),
                            DropdownMenuItem(child: Text(t.admin), value: 3),
                          ];
                        },
                        validator: (value) => value == null ? t.required : null,
                        onChanged: (value) async {
                          setState(() {
                            this.user?.rol = value;
                            this.validados[5] = this.fieldKeys[5].currentState!.validate();
                            int aux = this.validados.where((element) => element == false).length;
                            this._enableBtn = aux == 0;

                          });

                        },
                        decoration: InputDecorations.authInputDecoration(hint: '', label: t.role, helperText: t.required, icono: Icons.face),
                      ),
                      const SizedBox(
                          height: 20,
                        ),
                        CustomInputField(
                          controller: this.controllers![4],
                          keyField: this.fieldKeys[6],
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
                            this.validados[6] = this.fieldKeys[6].currentState!.validate();
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
                            controller: this.controllers![5],
                            keyField: this.fieldKeys[7],
                            hintText: '',
                            labelText: t.password,
                            helperText: t.required,
                            // focusNode: this.focusNodes[5],
                            validation: (value) {
                              if (value == '') return t.required;
                              else if (value!.length < 6) {
                                return t.min_characters(6);
                              } else {
                                return null;
                              }
                            },
                            callback: (user) {
                              this.user?.password = user;
                              this.validados[7] = this.fieldKeys[7].currentState!.validate();
                              int aux = this.validados.where((element) => element == false).length;
                              setState(() {
                                this._enableBtn = aux == 0;
                              });
                            },
                            password: !_passwordVisible,
                            icono: Icons.password,
                            suffix: IconButton(
                              icon: Icon(
                                _passwordVisible ?
                                Icons.visibility :
                                Icons.visibility_off,
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
                              height: 20,
                            ),
                            CustomInputField(
                              controller: this.controllers![6],
                              keyField: this.fieldKeys[8],
                              hintText: '',
                              labelText: t.password2,
                              helperText: t.required,
                              // focusNode: this.focusNodes[6],
                              validation: (value) {
                                if (value == '') return t.required;
                                else if (value! != this.user?.password) {
                                  return t.pass_diff;
                                } else {
                                  return null;
                                }
                              },
                              callback: (user) {
                                this.user?.password2 = user;
                                this.validados[8] = this.fieldKeys[8].currentState!.validate();
                                int aux = this.validados.where((element) => element == false).length;
                                setState(() {
                                  this._enableBtn = aux == 0;
                                });
                              },
                              password: !_passwordVisible2,
                              icono: Icons.password,
                              suffix: IconButton(
                                icon: Icon(
                                  _passwordVisible2 ?
                                  Icons.visibility :
                                  Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible2 = !_passwordVisible2;
                                  });
                                },
                              ),
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
                              Column(children: [
                                Column(children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Flexible(child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                        ),
                                        children: < TextSpan > [
                                          TextSpan(text: t.address),
                                          TextSpan(text: " " + this.user!.nombre + " " + this.user!.apellidos + " "),
                                          TextSpan(text: t.textResponsible),
                                        ],
                                    )), ), ], )
                                ], ),
                                SizedBox(height: 5,),
                                Column(
                                  children: [
                                    Row(children: [
                                      Checkbox(
                                        value: this.validados[9],
                                        onChanged: (bool ? value) {
                                          setState(() {
                                            this.validados[9] = value!;
                                            int aux = this.validados.where((element) => element == false).length;
                                            setState(() {
                                              this._enableBtn = aux == 0;
                                            });
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
                                              TextSpan(text: t.accept)
                                            ],
                                        )))
                                    ]),
                                    SizedBox(height: 18, )
                                  ], ),
                                Column(
                                  children: [
                                    Row(children: [
                                      Checkbox(
                                        value: this.validados[10],
                                        onChanged: (bool ? value) {
                                          setState(() {
                                            this.validados[10] = value!;
                                            int aux = this.validados.where((element) => element == false).length;
                                            setState(() {
                                              this._enableBtn = aux == 0;
                                            });
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
                                              TextSpan(text: t.readTerms),
                                            ],
                                        ))),
                                        InkWell(
                                        child: Text(t.terms, style:TextStyle(fontSize: 18, color: CustomTheme.atopaBlue)),
                                        onTap: () => launch('https://www.atopa.es/pdd.html')
                                    ),
                                    ]),
                                    SizedBox(height: 18, )
                                  ], ),
                              ]),
                              const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [ElevatedButton(
                                    onPressed: () {
                                      this.user = new User(nombre: '', apellidos: '', DNI: null, colegio: null, rol: null,
                                        evaluacion: 1, email: '', username: '', password: '', password2: '');
                                      _passwordVisible = false;
                                      _passwordVisible2 = false;
                                      for (int i = 0; i < this.controllers!.length; i++) {
                                        this.controllers![i].clear();
                                      }
                                      this.validados = [false, false, false, false, true, false, false, false, false, false, false];
                                      this._enableBtn = false;
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
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          var req = await _authAPI.signUp(this.user!);
                                          if (req.statusCode == 200) {
                                            var req2 = await _authAPI.login(this.user!.username, this.user!.password!);
                                            if (req2.statusCode == 200) {
                                              Token token = Token.fromJson(jsonDecode(req2.body));
                                              await prefs.setString('jwt', token.token);
                                              await prefs.setString('jwt-refresh', token.refresh);
                                              Navigator.pop(context);
                                              Navigator.popAndPushNamed(context, 'years', arguments: {
                                                'menu': t.years
                                              });
                                            } else {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: Text(t.error),
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
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text(t.errorSignup),
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