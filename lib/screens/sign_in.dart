import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:heroicons/heroicons.dart';
import 'package:plant_app/statics_var.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/utils/dimensions.dart';
import 'package:plant_app/widgets/text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();
  bool obscureText = false;

  Future<void> signInWithEmail() async {
    try {
      final email = textEditingControllerEmail.text.trim();
      final password = textEditingControllerPassword.text.trim();
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      if (res.session != null) {
       Navigator.pushNamed(context, '/launch');

   
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger(
        child: SnackBar(
          content: Text(
            "Sign In to Pantify App Failed :( \n try again later :)",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    textEditingControllerEmail.dispose();
    textEditingControllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Hi!  Welcome Back , you\'ve been missed',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 8),
                      AppTextField(
                        controller: textEditingControllerEmail,
                        label: 'Email',
                        hint: 'you@example.com',

                        leadingHeroIcon: HeroIcons.envelope,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!v.contains('@') || !v.contains('.')) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 8),
                      AppTextField(
                        controller: textEditingControllerPassword,
                        label: 'Password',
                        hint: '********',

                        leadingHeroIcon: HeroIcons.lockClosed,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Password is required';
                          }
                          if (v.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: primaryColor,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    width: width(context),
                    child: FilledButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await signInWithEmail();
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: quaternaryColor, fontSize: 16),
                      ),
                    ),
                  ),

                  SignWith(title: 'Or Sign In With'),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialMediaSignIn(iconPath: 'apple-logo.png'),
                      SocialMediaSignIn(iconPath: 'google.png'),
                      SocialMediaSignIn(iconPath: 'facebook.png'),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/signUp');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: "SignUp ",
                            style: TextStyle(
                              color: primaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignWith extends StatelessWidget {
  final String title;
  const SignWith({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(thickness: 1, color: placeholdColor, endIndent: 10),
        ),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        Expanded(
          child: Divider(thickness: 1, color: placeholdColor, indent: 10),
        ),
      ],
    );
  }
}

class SocialMediaSignIn extends StatelessWidget {
  final String iconPath;
  const SocialMediaSignIn({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: placeholdColor),
      ),
      child: Image.asset('images/icons/$iconPath', fit: BoxFit.cover),
    );
  }
}
