import 'package:atopa_app_flutter/api/authAPI.dart';
import 'package:atopa_app_flutter/api/models/user.dart';
import 'package:atopa_app_flutter/api/models/year.dart';
import 'package:atopa_app_flutter/api/yearAPI.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class YearScreen extends StatefulWidget {
  const YearScreen({
    Key ? key
  }): super(key: key);

  @override
  YearScreenState createState() => YearScreenState();
}

class YearScreenState extends State < YearScreen > {
  late Future < List < Year >> futureData;
  YearAPI _yearAPI = YearAPI();
  AuthAPI _authAPI = AuthAPI();
  User? user;
  int? rol;
  int? evaluacion;

  @override
  void initState() {
    super.initState();
    futureData = _yearAPI.getYears();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      this.user = await this._authAPI.getLoggedIn();
      this.rol = await prefs.getInt('rol') ?? 2;
      this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
      setState(() {
        
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(rol: this.rol, evaluacion: this.evaluacion,),
      body: FutureBuilder < List < Year >> (
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List < Year > data = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10, ),
                  Row(children:[BreadCrumbNavigator()],
                  mainAxisAlignment: MainAxisAlignment.start,),
                  SizedBox(height: 10, ),
                  Center(
                    child: ExpansionPanelList(
                      elevation: 3,
                      // Controlling the expansion behavior
                      expansionCallback: (index, isExpanded) {
                        setState(() {
                          data[index].isExpanded = !isExpanded;
                        });
                      },
                      animationDuration: Duration(milliseconds: 600),
                      children: data
                      .map(
                        (item) => ExpansionPanel(
                          canTapOnHeader: true,
                          backgroundColor:
                          item.isExpanded == true ? CustomTheme.atopaBlueLight : Colors.white,
                          headerBuilder: (_, isExpanded) => Container(
                            padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            child: Text(
                              item.school_year,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          body: Container(
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: CustomTheme.atopaGreyDark, width: 2),
                                bottom: BorderSide(color: CustomTheme.atopaGreyDark, width: 1))
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            child: Column(children: [Center(child: Row(
                              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                              crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                              children: [
                                ElevatedButton(
                                  child: Text(t!.students),
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'students',
                                      arguments: {
                                        'year': item,
                                        'menu': t.students + " " + item.school_year
                                      }).then((value) async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        this.user = await this._authAPI.getLoggedIn();
                                        this.rol = await prefs.getInt('rol') ?? 2;
                                        this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
                                        setState(() {
                                          
                                        });
                                      });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    elevation: 15.0,
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                      textStyle:
                                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                  ),
                                ),
                                SizedBox(width: 50),
                                ElevatedButton(
                                  child: Text(t.classes),
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'classes',
                                      arguments: {
                                        'year': item,
                                        'menu': t.classes + " " + item.school_year
                                      }).then((value) async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        this.user = await this._authAPI.getLoggedIn();
                                        this.rol = await prefs.getInt('rol') ?? 2;
                                        this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
                                        setState(() {
                                          
                                        });
                                      });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    elevation: 15.0,
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                      textStyle:
                                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                  ),
                                ),
                                SizedBox(width: 50),
                                ElevatedButton(
                                  child: Text(t.tests),
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'tests',
                                      arguments: {
                                        'year': item,
                                        'menu': t.tests + " " + item.school_year
                                      }).then((value) async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        this.user = await this._authAPI.getLoggedIn();
                                        this.rol = await prefs.getInt('rol') ?? 2;
                                        this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
                                        setState(() {
                                          
                                        });
                                      });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    elevation: 15.0,
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                      textStyle:
                                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                  ),
                                )
                              ]))])),
                          isExpanded: item.isExpanded!,
                        ),
                      )
                      .toList(),
                    )
                  ),
                  SizedBox(height: 40, ),
                ], )
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Center(
              child: CircularProgressIndicator(),
            )],
          );
        },
      ),
      persistentFooterButtons: const [
          CustomFooterBar()
        ],
    );
  }
}