import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_hub/shared/data/svg_assets.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/shared/utils/validator.dart';
import 'package:recipe_hub/src/authentication/presentation/interface/pages/sign_up.dart';

import '../../../../../shared/widgets/loading_manager.dart';
import '../../bloc/auth_mixin.dart';

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
    setState(() {
      isLoading = true;
    });
    if (isValid) {
      _formKey.currentState!.save();
    }
    await widget.loginUser(
      context: context,
      email: emailTextController.text,
      password: passwordTextController.text,
    );
    setState(() {
      isLoading = false;
    });
  }

  List svgs = [
    SvgAssets.female,
    SvgAssets.book,
    SvgAssets.male,
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
                  "Sign in to continue",
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
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passFocusNode),
                          controller: emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validator.email,
                          style: const TextStyle(color: ExtraColors.white),
                          decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle:
                                  const TextStyle(color: ExtraColors.white),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ExtraColors.white)),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ExtraColors.white)),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error)),
                              focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .error))),
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
                                      BorderSide(color: ExtraColors.white)),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ExtraColors.white)),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error)),
                              focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .error))),
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
                  child: const Text('Log In',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: ExtraColors.white,
                        thickness: 2,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('OR',
                        style: TextStyle(
                          color: ExtraColors.white,
                          fontSize: 18,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Divider(
                        color: ExtraColors.white,
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.googleSignIn(context: context);
                  },
                  child: const Text('Google Sign In',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Are you new here?',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    children: [
                      TextSpan(
                        text: '  Sign up',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
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
          )
        ]),
      ),
    );
  }
}
