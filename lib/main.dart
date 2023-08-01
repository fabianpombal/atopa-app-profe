import 'package:atopa_app_flutter/app_navigator_observer.dart';
import 'package:atopa_app_flutter/providers/language_provider.dart';
import 'package:atopa_app_flutter/screens/class_form.dart';
import 'package:atopa_app_flutter/screens/class_screen.dart';
import 'package:atopa_app_flutter/screens/colegio_edit_form.dart';
import 'package:atopa_app_flutter/screens/colegio_form.dart';
import 'package:atopa_app_flutter/screens/log_in_screen.dart';
import 'package:atopa_app_flutter/screens/pass_recovery_screen.dart';
import 'package:atopa_app_flutter/screens/preguntas_screen.dart';
import 'package:atopa_app_flutter/screens/results_complete.dart';
import 'package:atopa_app_flutter/screens/results_student_screen.dart';
import 'package:atopa_app_flutter/screens/sign_in_screen.dart';
import 'package:atopa_app_flutter/screens/sign_up_screen.dart';
import 'package:atopa_app_flutter/screens/student_form.dart';
import 'package:atopa_app_flutter/screens/student_screen.dart';
import 'package:atopa_app_flutter/screens/survey1.dart';
import 'package:atopa_app_flutter/screens/survey2.dart';
import 'package:atopa_app_flutter/screens/survey3.dart';
import 'package:atopa_app_flutter/screens/teacher_form.dart';
import 'package:atopa_app_flutter/screens/test_form.dart';
import 'package:atopa_app_flutter/screens/test_preguntas_form.dart';
import 'package:atopa_app_flutter/screens/tests_screen.dart';
import 'package:atopa_app_flutter/screens/vis_page.dart';
import 'package:atopa_app_flutter/screens/year_screen.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {

  Locale _locale = Locale('es', '');

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider())
      ],
      child: MaterialApp(
        locale: _locale,
        navigatorObservers: [AppNavigatorObserver()],
        // navigatorKey: navigatorKey,
        title: 'Atopa',
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          // 'en' is the language code. We could optionally provide a 
          // a country code as the second param, e.g. 
          // Locale('en', 'US'). If we do that, we may want to
          // provide an additional app_en_US.arb file for
          // region-specific translations.
          const Locale('es', ''),
          const Locale('gl', ''),
        ],
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.lightTheme,
        home: SignInScreen(),
        onGenerateRoute: (RouteSettings settings) {
          print('build route for ${settings.name}');
          var routes = <String, WidgetBuilder>{
            'main': (ctx) => const SignInScreen(),
            'log-in': (ctx) => const LogInPage(),
            'sign-up': (ctx) => const SignUpScreen(),
            'years': (ctx) => const YearScreen(),
            'pass-recovery': (ctx) => const PassRecoveryScreen(),
            'tests': (ctx) => const TestScreen(),
            'new-test': (ctx) => const TestFormScreen(),
            'new-questions': (ctx) => const TestPreguntasFormScreen(),
            'classes': (ctx) => const ClassScreen(),
            'new-class': (ctx) => const ClassFormScreen(),
            'students': (ctx) => const StudentScreen(),
            'new-student': (ctx) => const StudentFormScreen(),
            'results-graph': (ctx) => const VisPage(),
            'new-colegio': (ctx) => const ColegioFormScreen(),
            'results-student': (ctx) => const ResultsStudentScreen(),
            'results-complete': (ctx) => const ResultsCompleteScreen(),
            'teacher-form': (ctx) => const TeacherForm(),
            'colegio-form': (ctx) => const ColegioEditForm(),
            'preguntas': (ctx) => const PreguntasScreen(),
            'survey1': (ctx) => Survey1(),
            'survey2': (ctx) => Survey2(),
            'survey3': (ctx) => Survey3(),
          };
          WidgetBuilder builder = routes[settings.name]!;
          return MaterialPageRoute(builder: (ctx) => builder(ctx), settings: settings);
        },
      ),
    );
  }
}
