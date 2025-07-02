import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_admin_panel/features/auth/view/login_view.dart';
import 'core/helpers/my_observer.dart';
import 'core/theme/theme.dart';
import 'features/products/cubit/products_cubit.dart';

void main() {
  runApp(const MyApp());
  Bloc.observer = MyObserver();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsCubit()..getCategories()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nine Aki Bro Admin Dashboard',
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        home: const LoginView(),
      ),
    );
  }
}
