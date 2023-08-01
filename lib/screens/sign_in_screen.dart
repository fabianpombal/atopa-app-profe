import 'package:atopa_app_flutter/api/authAPI.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({
    Key ? key
  }): super(key: key);
      
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    AuthAPI _authAPI = AuthAPI();
    return Scaffold(
      appBar: CustomAppBar(route:"login"),
      body: FutureBuilder < bool > (
        future: _authAPI.checkLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.popAndPushNamed(context,"years", arguments: {'menu': t!.years});
              });
              return Container();
            } else {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.popAndPushNamed(context,"log-in");
              });
              return Container();
            }
          } else {
            return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Center(
                    child: CircularProgressIndicator(),
                  )],
                );
          }
        },
      ),
      persistentFooterButtons: const [
          CustomFooterBar()
        ],
      );
  }
}
