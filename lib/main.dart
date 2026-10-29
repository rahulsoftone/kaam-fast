import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/presentations/auth/bloc/auth_bloc.dart';
import 'package:kaam_fast/presentations/customer/home/bloc/customer_home_bloc.dart';
import 'package:kaam_fast/presentations/splash_screen/bloc/splash_bloc.dart';
import 'package:kaam_fast/presentations/worker/dashboard/bloc/worker_dashboard_bloc.dart';
import 'package:kaam_fast/services/storage_service.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system navigation & status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: darkBg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize storage
  await StorageService().init();

  runApp(const KaamFastApp());
}

class KaamFastApp extends StatelessWidget {
  const KaamFastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(create: (_) => SplashBloc()),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<CustomerHomeBloc>(create: (_) => CustomerHomeBloc()),
        BlocProvider<WorkerDashboardBloc>(create: (_) => WorkerDashboardBloc()),
      ],
      child: MaterialApp.router(
        title: 'Kaam Fast',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: darkBg,
          colorScheme: const ColorScheme.dark(
            primary: primary,
            secondary: secondary,
            surface: darkSurface,
            error: kRed,
          ),
          fontFamily: GoogleFonts.outfit().fontFamily,
          appBarTheme: const AppBarTheme(
            backgroundColor: darkBg,
            elevation: 0,
            iconTheme: IconThemeData(color: kWhite),
          ),
        ),
      ),
    );
  }
}
