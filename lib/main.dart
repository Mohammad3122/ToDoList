import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practice_bloc/splash_screen.dart';
import 'package:practice_bloc/todo_feature/logic/bloc/bloc/todo_bloc.dart';
import 'package:practice_bloc/todo_feature/model/todo_model.dart';
import 'package:practice_bloc/tools/router/app_router.dart';
import 'package:practice_bloc/tools/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(TodoModelAdapter());

  runApp(BlocProvider(
    create: (context) => TodoBloc(),
    child: MyApp(
      appRouter: AppRouter(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fa')],
        onGenerateRoute: appRouter.onGenerateRout,
        // home: const ShowTodoScreen(),
        initialRoute: SplashScreen.screenId,
        theme: CustomTheme.lightTheme,
      ),
    );
  }
}
