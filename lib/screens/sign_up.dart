import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:plant_app/screens/sign_in.dart';
import 'package:plant_app/statics_var.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/widgets/text_form_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerName = TextEditingController();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();
  bool obscureText = false;
  bool isChecked = false;
  bool isSubmitting = false;

  Future<void> signUpNewUser() async {
    try {
      setState(() => isSubmitting = true);

      final name = textEditingControllerName.text.trim();
      final email = textEditingControllerEmail.text.trim();
      final password = textEditingControllerPassword.text;

      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name, 'role': 'customer'},
      );

      if (!mounted) return;

      final user = res.user;
      final session = res.session;

      if (user != null && session != null) {
        await supabase.from('users').upsert({
          'id': user.id,
          'email': user.email ?? email,
          'full_name': name,
          'role': 'customer',
        }, onConflict: 'id');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            session == null
                ? 'Signup successful. Please check your email to confirm your account.'
                : 'Signup successful. You are can now signin to plantify',
          ),
        ),
      );

      Navigator.pushNamed(context, '/signIn');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign up failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  void dispose() {
    textEditingControllerName.dispose();
    textEditingControllerEmail.dispose();
    textEditingControllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Header(
                  title: 'Create Account',
                  subtitle:
                      'Fill your information below or register\nwith your social account',
                ),
                FormContent(
                  textEditingControllerName: textEditingControllerName,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                  title: 'Name',
                  hint: 'Ex. John Doe',
                  icon: HeroIcons.user,
                  keyboardType: TextInputType.name,
                ),
                FormContent(
                  textEditingControllerName: textEditingControllerEmail,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!v.contains('@') || !v.contains('.')) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  title: 'Email',
                  hint: 'you@example.com',
                  icon: HeroIcons.envelope,
                  keyboardType: TextInputType.emailAddress,
                ),
                FormContent(
                  textEditingControllerName: textEditingControllerPassword,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  title: 'Password',
                  hint: '********',
                  isPassword: true,
                  icon: HeroIcons.lockClosed,
                ),

                FormField<bool>(
                  validator: (value) {
                    if (isChecked == false) {
                      return "please agree on Terms First";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,

                          title: RichText(
                            text: TextSpan(
                              text: "Agree with ",
                              style: Theme.of(context).textTheme.bodySmall,
                              children: [
                                TextSpan(
                                  text: "Terms & Conditions",
                                  style: TextStyle(
                                    color: primaryColor,
                                    decoration: TextDecoration.underline,
                                    decorationColor: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          value: state.value ?? false,

                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                            state.didChange(value ?? false);
                          },
                        ),
                        if (state.hasError)
                          Padding(
                            padding: EdgeInsetsGeometry.all(10),
                            child: Text(
                              state.errorText!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            final valid =
                                formKey.currentState?.validate() ?? false;
                            if (!valid) return;
                            await signUpNewUser();
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: quaternaryColor, fontSize: 16),
                    ),
                  ),
                ),
                SignWith(title: 'Or Sign Up With'),

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
                    Navigator.pushNamed(context, '/signIn');
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: "SignIn ",
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
    );
  }
}

class FormContent extends StatelessWidget {
  const FormContent({
    super.key,
    required this.textEditingControllerName,
    required this.title,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
  });

  final TextEditingController textEditingControllerName;
  final String title;
  final String hint;
  final HeroIcons icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        SizedBox(height: 8),
        AppTextField(
          controller: textEditingControllerName,
          label: title,
          hint: hint,
          isPassword: isPassword,
          leadingHeroIcon: icon,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          validator: validator,
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  final String title;
  final String subtitle;
  const Header({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
