import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/root_shell.dart';

void main() {
  runApp(const SchoolActivityMediatorApp());
}

class SchoolActivityMediatorApp extends StatelessWidget {
  const SchoolActivityMediatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'الوسيط المدرسي والأنشطة',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return Directionality(textDirection: TextDirection.rtl, child: child!);
        },
        home: const RootShell(),
      ),
    );
  }
}
