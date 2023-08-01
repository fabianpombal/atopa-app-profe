import 'dart:convert';

import 'package:atopa_app_flutter/api/claseAPI.dart';
import 'package:atopa_app_flutter/api/models/clase.dart';
import 'package:atopa_app_flutter/api/models/pregunta.dart';
import 'package:atopa_app_flutter/api/testAPI.dart';
import 'package:atopa_app_flutter/api/models/test.dart';
import 'package:atopa_app_flutter/api/models/year.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
import 'package:atopa_app_flutter/providers/language_provider.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/themes/input_decorations.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TestFormScreen extends StatefulWidget {
  const TestFormScreen({
    Key ? key
  }): super(key: key);

  @override
  State < TestFormScreen > createState() => _TestFormState();
}

class _TestFormState extends State < TestFormScreen > {
  final _formKey = GlobalKey < FormState > ();
  Test ? test;
  Test ? copyTest;
  Year ? year;
  Clase ? clase;
  Map < int,
  int > ? clases;
  TestAPI _testAPI = TestAPI();
  ClaseAPI _claseAPI = ClaseAPI();
  List < Clase > ? clasesDrop;
  late bool _enableBtn = false;
  int ? lang;
  // late FocusNode focusNode;

  final List < GlobalKey < FormFieldState >> fieldKeys = [GlobalKey < FormFieldState > (), GlobalKey < FormFieldState > (), GlobalKey < FormFieldState > ()];
  List < bool > ? validados;
  List < TextEditingController > ? controllers;

  int ? rol;
  int ? evaluacion;
  bool cambio = false;
  LanguageProvider ? provLang;
  var f;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      this.rol = await prefs.getInt('rol') ?? 2;
      this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
      this.provLang = Provider.of < LanguageProvider > (context, listen: false);
      this.lang = this.provLang!.currentIndex;
      this.f = () async {
        this.lang = this.provLang!.currentIndex;
        if (mounted) {
          if (this.test!.id != null) {
            this.test!.preguntas = (await this._testAPI.getTest(this.lang!, this.test!)).preguntas;
            this.copyTest = this.test?.copy();
          }

          setState(() {

          });
        }
      };
      this.provLang!.addListener(this.f);
      Map < String, dynamic > ? args = ModalRoute.of(context) !.settings.arguments as Map < String, dynamic > ? ;
      if (args != null) {
        if (args.containsKey('year')) {
          this.year = args['year'];
        }
        if (args.containsKey('test')) {
          this.test = args['test'];
          this.copyTest = this.test?.copy();
          this._enableBtn = true;
          this.validados = [true, true, true];
        } else {
          this.test = new Test(nombre: '', estructura: null, uploaded: 0, clase: this.clase != null ? this.clase!.id! : null, downloaded: 0, closed: 0,
            followUp: 0, survey1: 0, survey2: 0, fin: 0, preguntas: [null, null, null, null, null, null], year: this.year?.id);
          this.validados = [false, false, false];
        }
        if (args.containsKey('class')) {
          this.clase = args['class'];
          this.test?.grupo_edad = this.clase?.grupo_edad;
          this.test?.clase = this.clase?.id;
        }
      } else {
        this.test = new Test(nombre: '', estructura: null, uploaded: 0, clase: this.clase != null ? this.clase!.id! : null, downloaded: 0, closed: 0,
          followUp: 0, survey1: 0, survey2: 0, fin: 0, preguntas: [null, null, null, null, null, null], year: this.year?.id);
        this.validados = [false, false, false];
      }
      this.controllers = [TextEditingController(text: this.test!.nombre)];
      await getClasesDrop();
      if (mounted)
        setState(() {});
    });

  }

  Future getClasesDrop() async {
    if (this.year != null) {
      this.clasesDrop = await _claseAPI.getClasesSearch({
        'Clase.year': this.year?.id,
        'test': true
      });
    } else {
      this.clasesDrop = await _claseAPI.getClases();
    }
    this.clases = {};
    this.clasesDrop!.forEach((element) {
      this.clases ? [element.id!] = element.grupo_edad!;
    });
  }

  @override
  void dispose() {
    this.provLang!.removeListener(this.f);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(rol: this.rol, evaluacion: this.evaluacion, ),
      body: this.clasesDrop != null ? SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(height: 10, ),
            Row(children: [BreadCrumbNavigator()],
              mainAxisAlignment: MainAxisAlignment.start, ),
            SizedBox(height: 10, ),
            CardContainer(
              color: Colors.white38,
              width: 3 * MediaQuery.of(context).size.width / 4,
              child: Column(
                children: [
                  const SizedBox(
                      height: 10,
                    ),
                    Text(
                      this.test?.id != null ? t!.edit_test : t!.new_test,
                      style : Theme.of(context).textTheme.headline5,
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              CustomInputField(
                                controller: this.controllers![0],
                                keyField: this.fieldKeys[0],
                                icono: Icons.rate_review,
                                hintText: '',
                                labelText: t.name,
                                helperText: t.required,
                                // focusNode: this.focusNode,
                                validation: (value) {
                                  if (value == null) return t.required;
                                  else if (value.length < 2) {
                                    return t.min_characters(2);
                                  } else {
                                    return null;
                                  }
                                },
                                callback: (name) {
                                  if (mounted)
                                    setState(() {
                                      this.test?.nombre = name;
                                      this.validados![0] = this.fieldKeys[0].currentState!.validate();
                                      int aux = this.validados!.where((element) => element == false).length;
                                      this._enableBtn = aux == 0;
                                    });

                                },
                              ),
                              const SizedBox(
                                  height: 20,
                                ),
                                DropdownButtonFormField(
                                  key: this.fieldKeys[1],
                                  value: this.test != null ? this.test?.estructura : null,
                                  items : [
                                    DropdownMenuItem(
                                      child: Text(t.formal, style: this.test?.estructura == 1 ? TextStyle(color: CustomTheme.atopaBlue) : null), value: 1),
                                    DropdownMenuItem(child: Text(t.informal, style: this.test?.estructura == 2 ? TextStyle(color: CustomTheme.atopaBlue) : null), value: 2),
                                  ],
                                  validator: (value) => value == null ? t.required : null,
                                  onChanged: (value) {
                                    if (mounted)
                                      setState(() {
                                        this.test?.estructura = value as int;
                                        this.validados![1] = this.fieldKeys[1].currentState!.validate();
                                        int aux = this.validados!.where((element) => element == false).length;
                                        this._enableBtn = aux == 0;
                                        this.cambio = true;
                                      });
                                    this.test?.preguntas = [null, null, null, null, null, null];

                                  },
                                  selectedItemBuilder: (BuildContext context) {
                                    return [
                                      DropdownMenuItem(
                                        child: Text(t.formal), value: 1),
                                      DropdownMenuItem(child: Text(t.informal), value: 2),
                                    ];
                                  },
                                  decoration: InputDecorations.authInputDecoration(hint: '', label: t.typeStructure, helperText: t.required, icono: Icons.format_list_bulleted),
                                ),
                                const SizedBox(
                                    height: 20,
                                  ),
                                  if (this.clase == null && this.test?.first == null) DropdownButtonFormField(
                                      key: this.fieldKeys[2],
                                      value: this.test != null ? this.test?.clase : null,
                                      items : this.clasesDrop!.map((e) {
                                        return DropdownMenuItem < int > (child: Text(e.nombre, style: this.test?.clase == e.id ? TextStyle(color: CustomTheme.atopaBlue) : null), value: e.id, );
                                      }).toList(),
                                      validator: (value) => value == null ? t.required : null,
                                      onChanged: (value) {
                                        if (mounted)
                                          setState(() {
                                            if (this.clases ? [value] != this.test?.grupo_edad) {
                                              this.cambio = true;

                                            }
                                            this.test?.grupo_edad = this.clases ? [value];
                                            this.test?.clase = value as int;
                                            this.validados![2] = this.fieldKeys[2].currentState!.validate();
                                            int aux = this.validados!.where((element) => element == false).length;
                                            this._enableBtn = aux == 0;
                                          });
                                        if (this.cambio)
                                          this.test?.preguntas = [null, null, null, null, null, null];

                                      },
                                      selectedItemBuilder: (BuildContext context) {
                                        return this.clasesDrop!.map((e) {
                                          return DropdownMenuItem < int > (child: Text(e.nombre), value: e.id, );
                                        }).toList();
                                      },
                                      decoration: InputDecorations.authInputDecoration(hint: '', label: t.class_name, helperText: t.required, icono: Icons.groups),
                                    ),
                                    const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [ElevatedButton(
                                          onPressed: () {
                                            if (this.test?.id == null) {
                                              this.test = new Test(nombre: '', estructura: null, uploaded: 0, clase: this.clase != null ? this.clase!.id! : null, downloaded: 0, closed: 0,
                                                followUp: 0, survey1: 0, survey2: 0, fin: 0, preguntas: [null, null, null, null, null, null], year: this.year?.id);
                                              this._enableBtn = false;
                                              this.validados = [false, false, false];
                                              for (int i = 0; i < this.controllers!.length; i++) {
                                                this.controllers![i].clear();
                                              }
                                            } else {
                                              this.test = this.copyTest?.copy();
                                              this._enableBtn = true;
                                              this.validados = [true, true, true];
                                              this.controllers![0].text = this.test!.nombre;
                                            }
                                            if (mounted)
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
                                      if (this.test?.id != null && !this.cambio) Column(
                                          children: [const SizedBox(
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
                                                        t.questionSel,
                                                        style: Theme.of(context).textTheme.headline6,
                                                      )
                                                    ]),
                                                  Divider(
                                                    height: 30,
                                                    color: Colors.black
                                                  ),
                                                  Column(children: [
                                                    for (int i = 0; i < this.test!.preguntas!.length; i++) Column(
                                                      children: [
                                                        Row(children: [
                                                          Flexible(child: RichText(
                                                            text: TextSpan(
                                                              style: const TextStyle(
                                                                  fontSize: 18.0,
                                                                  color: Colors.black,
                                                                ),
                                                                children: < TextSpan > [
                                                                  TextSpan(text: t.question + " " + (i + 1).toString() + " (" + (i == 0 ? 'PGP' : i == 1 ? 'PGN' : i == 2 ? 'PPP' : i == 3 ? 'PPN' : i == 4 ? 'AAP' : 'AAN') + ")" + ": ", style: const TextStyle(fontWeight: FontWeight.bold)),
                                                                  TextSpan(text: this.test!.preguntas![i] is Pregunta ? this.test!.preguntas![i].pregunta : ''),
                                                                ],
                                                            )))
                                                        ]),
                                                        SizedBox(height: 8, )
                                                      ], ),
                                                  ], ),
                                                ]),

                                            )], ),
                                        const SizedBox(
                                            height: 20,
                                          ),
                                          ElevatedButton(
                                            onPressed: !this._enableBtn ? null : () {
                                              this.provLang!.removeListener(this.f);
                                              Navigator.pushNamed(context, 'new-questions',
                                                arguments: {
                                                  'test': this.test,
                                                  'menu': (this.test?.id == null || this.cambio) ? t.add_questions : t.edit_questions
                                                }).then((value) async {
                                                this.provLang!.addListener(this.f);
                                                this.lang = this.provLang!.currentIndex;
                                                this.test = await this._testAPI.getTest(this.lang!, this.test!);
                                                this.copyTest = this.test?.copy();
                                                this._enableBtn = true;
                                                this.cambio = false;
                                                this.validados = [true, true, true];
                                                if (mounted)
                                                  setState(() {

                                                  });
                                                // Navigator.pop(context);
                                              });
                                            },
                                            child: Text((this.test?.id == null || this.cambio) ? t.add_questions : t.edit_questions),
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
                                              height: 40,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                if (this.test?.id != null && !this.cambio) ElevatedButton(
                                                    onPressed: !this._enableBtn ? null : () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => Center(
                                                          child: CircularProgressIndicator(
                                                            color: CustomTheme.atopaBlue,
                                                          ),
                                                        ),
                                                        barrierDismissible: false);
                                                      Map < String, Object ? > jsonOriginal = this.copyTest!.toJson();
                                                      Map < String, dynamic > body = {};
                                                      this.test?.toJson().forEach((key, value) {
                                                        if (jsonOriginal[key] != value) {
                                                          if (key != 'preguntas')
                                                            body[key] = value;
                                                        }
                                                      });
                                                      if (body.isNotEmpty) {
                                                        Response value = await _testAPI.updateTest(body, this.test!.id!);
                                                        Navigator.pop(context);
                                                        if (value.statusCode == 200) {
                                                          this.provLang!.removeListener(this.f);
                                                          Navigator.pop(context);
                                                        } else if (value.statusCode == 400) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) => AlertDialog(
                                                              title: Text(t.errorTestUp),
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

                                                      } else {
                                                        Navigator.pop(context);
                                                        this.provLang!.removeListener(this.f);
                                                        Navigator.pop(context);
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
                                                        this.provLang!.removeListener(this.f);
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
                          ),
                      ),
                    ),
                ])
            ),
            SizedBox(height: 40, ),
          ])
        )) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(
          child: CircularProgressIndicator(),
        )],
      ),
      persistentFooterButtons: const [
        CustomFooterBar()
      ],
    );
  }
}