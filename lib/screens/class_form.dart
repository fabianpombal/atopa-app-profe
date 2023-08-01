import 'dart:convert';
import 'dart:typed_data';

import 'package:atopa_app_flutter/api/alumnoAPI.dart';
import 'package:atopa_app_flutter/api/claseAPI.dart';
import 'package:atopa_app_flutter/api/models/alumno.dart';
import 'package:atopa_app_flutter/api/models/clase.dart';
import 'package:atopa_app_flutter/api/models/year.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/themes/input_decorations.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/widgets.dart';
import 'dart:html'
as html;
import 'package:http/http.dart'
as http;
import 'dart:js'
as js;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClassFormScreen extends StatefulWidget {
  const ClassFormScreen({
    Key ? key
  }): super(key: key);

  @override
  State < ClassFormScreen > createState() => _ClassFormState();
}

class _ClassFormState extends State < ClassFormScreen > {
  final _formKey = GlobalKey < FormState > ();
  Clase ? clase;
  Clase ? copyClase;
  Year ? year;
  List < Alumno > ? alumnos;
  ClaseAPI _claseAPI = ClaseAPI();
  AlumnoAPI _alumnoAPI = AlumnoAPI();
  // late FocusNode focusNode;
  late bool _enableBtn = false;
  bool import = false;

  List < int > ? _selectedFile;
  Uint8List ? _bytesData;

  final List<GlobalKey<FormFieldState>> fieldKeys = [GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>()];
  List<bool>? validados;
  List<TextEditingController>? controllers;

  int? rol;
  int? evaluacion;

  @override
  void initState() {
    super.initState();
    // focusNode = new FocusNode();
    // focusNode.addListener(() {
    //   if (!focusNode.hasFocus) {
    //     setState(() {
    //       _enableBtn = _formKey.currentState!.validate();
    //     });
    //   }
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      this.rol = await prefs.getInt('rol') ?? 2;
      this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
      Map < String, dynamic > ? args = ModalRoute.of(context) !.settings.arguments as Map < String, dynamic > ? ;
      if (args != null) {
        if (args.containsKey('import')) {
          this.import = args['import'];
        }
        if (args.containsKey('year')) {
          this.year = args['year'];
        }
        if (args.containsKey('class')) {
          this.clase = args['class'];
          this.copyClase = this.clase?.copy();
          this._enableBtn = true;
          this.validados = [true, true];
        } else {
          this.clase = new Clase(nombre: '', grupo_edad: null, modify: 1, year: this.year?.id, alumnos : []);
          this.validados = [false, false];
        }
      } else {
          this.clase = new Clase(nombre: '', grupo_edad: null, modify: 1, year: this.year?.id, alumnos : []);
          this.validados = [false, false];
      }
      this.controllers = [TextEditingController(text: this.clase!.nombre)];
      await getAlumnosOptions();
      setState(() {});
    });

  }

  Future getAlumnosOptions() async {
    this.alumnos = await _alumnoAPI.getAlumnosSearch({
      'clase': null,
      'year': this.year!.id
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(rol: this.rol, evaluacion: this.evaluacion,),
      body: this.alumnos != null ? SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(height: 10, ),
            Row(children: [BreadCrumbNavigator()],
              mainAxisAlignment: MainAxisAlignment.start, ),
            SizedBox(height: 10, ),
            CardContainer(
              color: Colors.white38,
              width: 2 * MediaQuery.of(context).size.width / 3,
              child: Column(
                children: [
                  const SizedBox(
                      height: 10,
                    ),
                    Text(
                      clase?.id != null ? t!.edit_class : t!.create_class,
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
                                icono: Icons.groups,
                                hintText : '',
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
                                  setState(() {
                                    this.clase?.nombre = name;
                                    this.validados![0] = this.fieldKeys[0].currentState!.validate();
                                    int aux = this.validados!.where((element) => element == false).length;
                                    this._enableBtn = aux == 0;
                                  });
                                  
                                },
                              ),
                              const SizedBox(
                                  height: 20,
                                ),
                                DropdownButtonFormField<int>(
                                  key: this.fieldKeys[1],
                                  value: this.clase != null ? this.clase?.grupo_edad : null,
                                  items : [
                                    DropdownMenuItem(
                                      child: Text(t.group1, style: this.clase?.grupo_edad == 1 ? TextStyle(color: CustomTheme.atopaBlue) : null), value: 1),
                                    DropdownMenuItem(child: Text(t.group2, style: this.clase?.grupo_edad == 2 ? TextStyle(color: CustomTheme.atopaBlue) : null), value: 2),
                                    DropdownMenuItem(child: Text(t.group3, style: this.clase?.grupo_edad == 3 ? TextStyle(color: CustomTheme.atopaBlue) : null), value: 3),
                                    DropdownMenuItem(child: Text(t.group4, style: this.clase?.grupo_edad == 4 ? TextStyle(color: CustomTheme.atopaBlue) : null), value: 4),
                                  ],
                                  selectedItemBuilder: (BuildContext context){
                                    return [
                                    DropdownMenuItem(
                                      child: Text(t.group1), value: 1),
                                    DropdownMenuItem(child: Text(t.group2), value: 2),
                                    DropdownMenuItem(child: Text(t.group3), value: 3),
                                    DropdownMenuItem(child: Text(t.group4), value: 4),
                                  ];
                                  },
                                  validator: (value) => value == null ? t.required : null,
                                  onChanged: (value) async {
                                    setState(() {
                                      this.clase?.grupo_edad = value as int;
                                      this.validados![1] = this.fieldKeys[1].currentState!.validate();
                                      int aux = this.validados!.where((element) => element == false).length;
                                      this._enableBtn = aux == 0;
                                    });
                                  },
                                  decoration: InputDecorations.authInputDecoration(hint: '', label: t.age_group, helperText: t.required, icono: Icons.punch_clock),

                                ),
                                const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [ElevatedButton(
                                      onPressed: () {
                                        if (this.clase?.id == null) {
                                          this.clase = new Clase(nombre: '', grupo_edad: null, modify: 1, year: this.year?.id, alumnos : []);
                                          this._enableBtn = false;
                                          this.validados = [false, false];
                                          for (int i = 0; i < this.controllers!.length; i++) {
                                            this.controllers![i].clear();
                                          }
                                        } else {
                                          this.clase = this.copyClase?.copy();
                                          print(this.clase!.grupo_edad);
                                          this._enableBtn = true;
                                          this.validados = [true, true];
                                          this.controllers![0].text = this.clase!.nombre;

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
                                  if (!this.import) MultipleSearchSelection < Alumno > (
                                    items: this.alumnos!,
                                    initialPickedItems: this.clase?.alumnos,
                                    fieldToCheck : (a) {
                                      return a.nombre + " " + a.apellidos;
                                    },
                                    itemBuilder: (alumno) {
                                      return Padding(
                                        padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 20.0,
                                                  horizontal: 12,
                                                ),
                                                child: Text(alumno.nombre + " " + alumno.apellidos),
                                            ),
                                          ),
                                      );
                                    },
                                    pickedItemBuilder: (alumno) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: CustomTheme.atopaGreyDark),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                            child: Text(alumno.nombre + " " + alumno.apellidos, style: TextStyle(fontSize: 15), ),
                                        ),
                                      );
                                    },
                                    onTapShowedItem: () {},
                                    onPickedChange: (items) {
                                      this.clase?.alumnos = items;
                                    },
                                    onItemAdded: (item) {},
                                    onItemRemoved: (item) {},
                                    sortShowedItems: true,
                                    sortPickedItems: true,
                                    noResultsWidget: Text(t.noStudents, style: TextStyle(fontSize: 15)),
                                      searchFieldInputDecoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.only(
                                            left: 6,
                                          ),
                                          hintText: t.search,
                                          hintStyle: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        // border: OutlineInputBorder(
                                        //   borderSide: BorderSide.none,
                                        //   borderRadius:
                                        //   BorderRadius.circular(20),
                                        // ),
                                      ),
                                      onTapSelectAll: () => print('select all tapped'),
                                      selectAllButton: ElevatedButton(
                                        onPressed: () {
                                        },
                                        child: Text(t.select_all),
                                          style: ElevatedButton.styleFrom(
                                            primary: CustomTheme.atopaBlue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            elevation: 15.0,
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                              textStyle:
                                              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                          ),
                                      ),
                                      onTapClearAll: () => print('clear all tapped'),
                                      clearAllButton: ElevatedButton(
                                        onPressed: () {

                                        },
                                        child: Text(t.clean_all),
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
                                      fuzzySearch: FuzzySearch.jaro,
                                      padding: const EdgeInsets.all(20),
                                        itemsVisibility: ShowedItemsVisibility.alwaysOn,
                                        title: Text(
                                          t.students,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        showSelectAllButton: true,
                                        titlePadding: const EdgeInsets.symmetric(vertical: 10),
                                          searchItemTextContentPadding:
                                          const EdgeInsets.symmetric(horizontal: 10),
                                            maximumShowItemsHeight: 200,
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
                                          if (this.clase?.id != null) {
                                            print(this.clase?.toJson());
                                            Map < String, Object ? > jsonOriginal = this.copyClase!.toJson();
                                            Map < String, dynamic > body = {};
                                            this.clase?.toJson().forEach((key, value) {
                                              if (key != "alumnos") {
                                                if (jsonOriginal[key] != value) {
                                                  body[key] = value;
                                                }
                                              } else {
                                                body[key] = value;
                                              }

                                            });
                                            if (body.isNotEmpty) {
                                              Response value = await _claseAPI.updateClase(body, this.clase!.id!);
                                              Navigator.pop(context);
                                              
                                                if (value.statusCode == 200) {
                                                  if (this.import) {
                                                    int newId = int.parse(json.decode(value.body)['id']);
                                                    await startWebFilePicker(newId, t);
                                                  } else {
                                                    Navigator.pop(context);
                                                  }
                                                  
                                                } else if (value.statusCode == 400) {
                                                  String msg = json.decode(value.body)['message'];
                                                  var blob = html.Blob([msg], 'text/plain', 'native');
                                                  js.context.callMethod("webSaveAs", [blob, "alumnos-no-añadidos-" + this.clase!.nombre + ".txt"]);

                                                  showDialog(
                                                    context: context,
                                                    builder: (ctx) => AlertDialog(
                                                      title: Text(t.errorClassUp),
                                                        content: Text(msg),
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
                                            Response value = await _claseAPI.newClase(this.clase!);
                                            Navigator.pop(context);
                                              if (value.statusCode == 200) {
                                                if (this.import) {
                                                  int newId = int.parse(json.decode(value.body)['id']);
                                                  await startWebFilePicker(newId, t);
                                                } else {
                                                    Navigator.pop(context);
                                                  }
                                              } else if (value.statusCode == 400) {
                                                String msg = json.decode(value.body)['message'];
                                              var blob = html.Blob([msg], 'text/plain', 'native');
                                              js.context.callMethod("webSaveAs", [blob, "alumnos-no-añadidos-" + this.clase!.nombre + ".txt"]);
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text(t.errorClassCreate),
                                                      content: Text(msg),
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
                                            
                                          }
                                        },
                                        child: Text(!this.import ? t.save: t.import_save),
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

  startWebFilePicker(int id, var t) async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = ".xlsx,.xls";
    uploadInput.multiple = false;
    uploadInput.draggable = true;
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.length == 1) {
        final file = files[0];
        final reader = new html.FileReader();
        reader.onLoadEnd.listen((e) {
          _handleResult(reader.result!, id, t);
        });
        reader.readAsDataUrl(file);
      }
    });
  }

  void _handleResult(Object result, int id, var t) async {
    _bytesData = Base64Decoder().convert(result.toString().split(",").last);
    _selectedFile = _bytesData;

    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: CustomTheme.atopaBlue,
        ),
      ),
      barrierDismissible: false);
    StreamedResponse res = await _alumnoAPI.uploadExcel(this._selectedFile!, id);
    Navigator.pop(context);
    if (res.statusCode == 200) {
      Navigator.pop(context);
    } else {
      Response response = await http.Response.fromStream(res);
      String msg = json.decode(response.body)['message'];
      var blob = html.Blob([msg], 'text/plain', 'native');
      js.context.callMethod("webSaveAs", [blob, "alumnos-no-importados.txt"]);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(t!.errorUp),
            content: Text(msg),
            actions: < Widget > [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                    child: Text(t!.ok),
                ),
              ),
            ],
        ),
      );
      
    }
  }
}