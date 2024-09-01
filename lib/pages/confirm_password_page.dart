import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';

import '../widgets/auth/custom_elevated_button.dart';
import '../widgets/auth/custom_text_form_field.dart';

class ConfirmPasswrdPage extends StatefulWidget {
  const ConfirmPasswrdPage({super.key});

  @override
  State<ConfirmPasswrdPage> createState() => _ConfirmPasswrdPageState();
}

class _ConfirmPasswrdPageState extends State<ConfirmPasswrdPage> {
  late TextEditingController passwordController;

  late TextEditingController confirmPasswordController;
  @override
  void initState() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Reset Password',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 200,
            ),
            Form(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CustomTextFormField(
                    hintText: '***********',
                    labelText: 'Password',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    hintText: '***********',
                    labelText: 'Confirm Password',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    onPressed: () async {
                      await context.read<AuthCubit>().updatePassword(
                            passwordController: passwordController,
                            context: context,
                            confirmPasswordController:
                                confirmPasswordController,
                          );
                    },
                    child: const Text(
                      'SUBMIT',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
