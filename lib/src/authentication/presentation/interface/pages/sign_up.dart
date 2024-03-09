import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_hub/shared/data/svg_assets.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/shared/utils/validator.dart';
import 'package:recipe_hub/src/authentication/presentation/interface/pages/login.dart';

import '../../../../../shared/widgets/loading_manager.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/SignUpPage';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final fullNameTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
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
  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  List svgs = [
    SvgAssets.male,
    SvgAssets.female,
    SvgAssets.book,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoadingManager(
        isLoading: isLoading,
        child: Stack(children: [
          Swiper(
            duration: 800,
            autoplayDelay: 8000,
            itemBuilder: (BuildContext context, int index) {
              return SvgPicture.asset(
                svgs[index],
                fit: BoxFit.fill,
              );
            },
            autoplay: true,
            itemCount: svgs.length,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 120.0,
                ),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                      color: ExtraColors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Sign up to continue",
                  style: TextStyle(
                    color: ExtraColors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: fullNameTextController,
                          keyboardType: TextInputType.name,
                          validator: Validator.name,
                          style: const TextStyle(color: ExtraColors.white),
                          decoration: const InputDecoration(
                              hintText: 'Full name',
                              hintStyle: TextStyle(color: ExtraColors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ExtraColors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ExtraColors.white),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ExtraColors.white),
                              )),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passFocusNode),
                          controller: emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validator.email,
                          style: const TextStyle(color: ExtraColors.white),
                          decoration: const InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: ExtraColors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ExtraColors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ExtraColors.white),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ExtraColors.white),
                              )),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        //Password
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
                          maxLines: 1,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: ExtraColors.white,
                                  )),
                              hintText: 'Password',
                              hintStyle:
                                  const TextStyle(color: ExtraColors.white),
                              contentPadding:
                                  const EdgeInsets.only(top: 10, left: 10),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ExtraColors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ExtraColors.white),
                              ),
                              focusedErrorBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ExtraColors.white),
                              )),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _submitFormOnLogin();
                  },
                  child: const Text('Sign Up',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Already a user?',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    children: [
                      TextSpan(
                        text: '  Sign in',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            NavigationHelper.navigateTo(
                                context, const LoginPage());
                          },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
