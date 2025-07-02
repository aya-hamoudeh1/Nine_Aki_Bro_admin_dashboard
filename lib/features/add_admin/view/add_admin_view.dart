import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/components/custom_circle_pro_ind.dart';
import '../../../core/components/custom_elevated_button.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/functions/navigate_without_back.dart';
import '../../../core/functions/show_msg.dart';
import '../../auth/view/login_view.dart';
import '../cubit/add_admin_cubit.dart';

class AddAdminView extends StatefulWidget {
  const AddAdminView({super.key});

  @override
  State<AddAdminView> createState() => _AddAdminViewState();
}

class _AddAdminViewState extends State<AddAdminView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AddAdminCubit(),
        child: BlocConsumer<AddAdminCubit, AddAdminState>(
          listener: (context, state) {
            if (state is AddAdminSuccess) {
              navigateWithoutBack(context, const LoginView());
            }
            if (state is AddAdminError) {
              showMsg(context, state.messageError);
            }
          },
          builder: (context, state) {
            AddAdminCubit cubit = context.read<AddAdminCubit>();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  state is AddAdminLoading
                      ? const CustomCircleProgressIndicator()
                      : Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            /// Email
                            CustomTextField(
                              controller: _emailController,
                              labelText: 'Email',
                            ),
                            const SizedBox(height: 20),

                            /// Password
                            CustomTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              isPassword: true,
                            ),
                            const SizedBox(height: 20),

                            /// Add Button
                            CustomElevatedButton(
                              child: const Text('Add'),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.createAnAccount({
                                    "email": _emailController.text,
                                    "password": _passwordController.text,
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
            );
          },
        ),
      ),
    );
  }
}
