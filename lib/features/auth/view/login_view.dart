import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/components/custom_circle_pro_ind.dart';
import '../../../core/components/custom_elevated_button.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/functions/build_appbar.dart';
import '../../../core/functions/navigate_without_back.dart';
import '../../../core/functions/show_msg.dart';
import '../../home/view/home_view.dart';
import '../cubit/login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            navigateWithoutBack(context, const HomeView());
          }
          if (state is LoginError) {
            showMsg(context, state.messageError);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: buildCustomAppBar(
              context,
              'Login As An Admin',
              isBackButton: false,
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/logos/logo.png',
                                height: 250,
                              ),
                              const SizedBox(height: 40),
                              CustomTextField(
                                controller: _emailController,
                                labelText: 'Email',
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: _passwordController,
                                isPassword: true,
                                obscureText: _obscurePassword,
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                labelText: 'Password',
                              ),
                              const SizedBox(height: 20),
                              CustomElevatedButton(
                                width: double.infinity,
                                height: 50,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<LoginCubit>().login({
                                      "email": _emailController.text,
                                      "password": _passwordController.text,
                                    });
                                  }
                                },
                                child: const Text('Login'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// Show loading overlay
                if (state is LoginLoading)
                  Container(
                    color: Colors.black.withAlpha(128),
                    child: const Center(child: CustomCircleProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
