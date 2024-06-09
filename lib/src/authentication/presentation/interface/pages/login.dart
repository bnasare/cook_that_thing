import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/utils/navigation.dart';
import '../../../../../shared/utils/validator.dart';
import '../../../../../shared/widgets/loading_manager.dart';
import '../../bloc/auth_mixin.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget with AuthMixin {
  static const routeName = '/LoginPage';
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool isLoading = false;
  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      await widget.loginUser(
        context: context,
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      setState(() {
        isLoading = false;
      });
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
              const SizedBox(
                height: 100.0,
              ),
              const Text(
                'Welcome Back',
                style: TextStyle(
                    color: ExtraColors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Hi! Welcome back, you've been missed",
                style: TextStyle(
                  color: ExtraColors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(
                        height: 20,
                      ),
                      //Password
                      const Text('Password',
                          style: TextStyle(
                              color: ExtraColors.black, fontSize: 15)),
                      const SizedBox(height: 7),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          _submitFormOnLogin();
                        },
                        controller: passwordTextController,
                        focusNode: _passFocusNode,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        validator: Validator.password,
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
                            fillColor: ExtraColors.lightGrey),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  _submitFormOnLogin();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                child: const Text('Sign In',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: ExtraColors.lightGrey,
                        thickness: 2,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('or sign in with',
                        style: TextStyle(
                          color: ExtraColors.darkGrey,
                          fontSize: 17,
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Divider(
                        color: ExtraColors.lightGrey,
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await widget.googleSignIn(context: context);
                  setState(() {
                    isLoading = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                child: const Text('Google',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              ),
              // Row(
              //     mainAxisSize: MainAxisSize.min,
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Flexible(
              //           fit: FlexFit.loose,
              //           child: SocialAuthButton(
              //             onPressed: () async {
              //               setState(() {
              //                 isLoading = true;
              //               });
              //               await widget.googleSignIn(context: context);
              //               setState(() {
              //                 isLoading = false;
              //               });
              //             },
              //             buttonText: 'Google',
              //             imagePath: ImageAssets.google,
              //           )),
              //       const SizedBox(width: 18),
              //       Flexible(
              //           fit: FlexFit.loose,
              //           child: SocialAuthButton(
              //               onPressed: () {
              //                 SnackBarHelper.showInfoSnackBar(
              //                     context, 'Coming Soon');
              //               },
              //               imagePath: ImageAssets.apple,
              //               buttonText: 'Apple',
              //               space: 3,
              //               imageHeight: 40,
              //               imageWidth: 40))
              //     ]),
              const SizedBox(height: 38),
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style:
                      const TextStyle(color: ExtraColors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          NavigationHelper.navigateTo(context, SignUpPage());
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
