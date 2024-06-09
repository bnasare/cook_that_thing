import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/utils/navigation.dart';
import '../../../../../shared/utils/validator.dart';
import '../../../../../shared/presentation/widgets/loading_manager.dart';
import '../../bloc/auth_mixin.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget with AuthMixin {
  static const routeName = '/SignUpPage';
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final fullNameTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isAgreedToTerms = true;
  var _obscureText = true;

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    _passFocusNode.dispose();
    fullNameTextController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  void _submitFormOnSignUp() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      await widget.signUpUser(
        context: context,
        email: emailTextController.text,
        password: passwordTextController.text,
        name: fullNameTextController.text,
      );
      emailTextController.clear();
      passwordTextController.clear();
      fullNameTextController.clear();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 100.0),
              const Text(
                'Create Account',
                style: TextStyle(
                    color: ExtraColors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Fill your details to create your account",
                style: TextStyle(
                  color: ExtraColors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30.0),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Name',
                          style: TextStyle(
                              color: ExtraColors.black, fontSize: 15)),
                      const SizedBox(height: 7),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: fullNameTextController,
                        keyboardType: TextInputType.name,
                        validator: Validator.name,
                        style: const TextStyle(color: ExtraColors.black),
                        decoration: const InputDecoration(
                          hintText: 'John Doe',
                          hintStyle: TextStyle(color: ExtraColors.darkGrey),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20.0),
                          filled: true,
                            fillColor: ExtraColors.lightGrey
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Email',
                          style: TextStyle(
                              color: ExtraColors.black, fontSize: 15)),
                      const SizedBox(height: 7),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
                        controller: emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validator.email,
                        style: const TextStyle(color: ExtraColors.black),
                        decoration: const InputDecoration(
                            hintText: 'example@gmail.com',
                            hintStyle: TextStyle(color: ExtraColors.darkGrey),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20.0),
                            filled: true,
                            fillColor: ExtraColors.lightGrey),
                      ),
                      const SizedBox(height: 20),
                      //Password
                      const Text('Password',
                          style: TextStyle(
                              color: ExtraColors.black, fontSize: 15)),
                      const SizedBox(height: 7),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          _submitFormOnSignUp();
                        },
                        controller: passwordTextController,
                        focusNode: _passFocusNode,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        validator: Validator.password,
                        maxLines: 1,
                        style: const TextStyle(color: ExtraColors.black),
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: ExtraColors.darkGrey,
                              )),
                          hintText: '●●●●●●●',
                          hintStyle:
                              const TextStyle(color: ExtraColors.darkGrey),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          filled: true,
                            fillColor: ExtraColors.lightGrey
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _isAgreedToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _isAgreedToTerms = value!;
                                });
                              },
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Agree to ',
                                style: const TextStyle(
                                  color: ExtraColors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ])
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _isAgreedToTerms ? _submitFormOnSignUp : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Theme.of(context).colorScheme.primaryContainer;
                      }
                      return Theme.of(context).colorScheme.primary;
                    },
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: _isAgreedToTerms
                          ? ExtraColors.white
                          : ExtraColors.darkGrey),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style:
                      const TextStyle(color: ExtraColors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          NavigationHelper.navigateTo(context, LoginPage());
                        },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
