import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth/auth_cubit.dart';

import '../widgets/auth/auth_template.widget.dart';
import '../widgets/auth/custom_text_form_field.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'SignUpPAge';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplateWidget(
      onSignUp: () async {
        await context.read<AuthCubit>().signUp(
            context: context,
            emailController: emailController,
            nameController: nameController,
            passwordController: passwordController);
      },
      body: Column(
        children: [
          CustomTextFormField(
            controller: nameController,
            hintText: 'Nada Mostafa',
            labelText: 'Full Name',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextFormField(
            controller: emailController,
            hintText: 'ex@gmail.com',
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextFormField(
            controller: passwordController,
            hintText: '***********',
            labelText: 'Password',
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextFormField(
            controller: confirmPasswordController,
            hintText: '***********',
            labelText: 'Confirm Password',
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
        ],
      ),
    );
  }
}
