import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/text_field_widget.dart';
import 'package:flutter/foundation.dart';
import '../widgets/button_widget.dart';
import '../widgets/or_divider_widget.dart';
import '../widgets/register_option.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  serverClientId:
      '805628551035-k20h8ab6vdvr8qth03hn0r53hdgh4vo4.apps.googleusercontent.com',

  scopes: scopes,
);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn();

      _googleSignIn.signIn().then((result) {
        result?.authentication.then((googleKey) {
          final token = googleKey.idToken.toString();
          log(token);
          print('Token: ${googleKey.idToken}');
        });
      });
    } catch (error) {
      print('Sign in error: $error');
    }
  }

  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      setState(() {
        _currentUser = account;
      });

      if (account != null) {
        // Optionally handle authorized scopes
        bool isAuthorized =
            kIsWeb ? await _googleSignIn.canAccessScopes(scopes) : true;
        setState(() {
          _isAuthorized = isAuthorized;
        });
      }
    });
    // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
    //
    // It is recommended by Google Identity Services to render both the One Tap UX
    // and the Google Sign In button together to "reduce friction and improve
    // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
    _googleSignIn.signInSilently();
  }

  // String? _pickFirstNamedContact(Map<String, dynamic> data) {
  //   final List<dynamic>? connections = data['connections'] as List<dynamic>?;
  //   final Map<String, dynamic>? contact = connections?.firstWhere(
  //     (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
  //     orElse: () => null,
  //   ) as Map<String, dynamic>?;
  //   if (contact != null) {
  //     final List<dynamic> names = contact['names'] as List<dynamic>;
  //     final Map<String, dynamic>? name = names.firstWhere(
  //       (dynamic name) =>
  //           (name as Map<Object?, dynamic>)['displayName'] != null,
  //       orElse: () => null,
  //     ) as Map<String, dynamic>?;
  //     if (name != null) {
  //       return name['displayName'] as String?;
  //     }
  //   }
  //   return null;
  // }

  // This is the on-click handler for the Sign In button that is rendered by Flutter.
  //
  // On the web, the on-click handler of the Sign In button is owned by the JS
  // SDK, so this method can be considered mobile only.
  // #docregion SignIn

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back_ios,
            size: 15,
          ),
          onTap: () {
            context.pop();
          },
        ),
        centerTitle: true,
        title: Row(
          children: [
            const SizedBox(width: 100),
            Image.asset(
              'assets/onboardingIcon.png',
              width: 25,
              height: 25,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Join Neighborly',
                style: onboardingHeading1Style,
              ),
              const SizedBox(
                height: 40,
              ),
              RegisterOption(
                image: Image.asset('assets/google_icon.png'),
                title: 'Continue with Google',
                onTap: () {
                  print('button clicked');
                  // BlocProvider.of<GoogleAuthenticationBloc>(context)
                  //     .add(const GoogleAuthenticationButtonPressedEvent());
                  _handleSignIn();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              RegisterOption(
                image: Image.asset('assets/email_icon.png'),
                title: 'Continue with Email',
                onTap: () {
                  context.push("/registerWithEmailScreen");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const OrDividerWidget(),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                border: true,
                inputType: TextInputType.phone,
                onChanged: (value) {
                  // setState(() {
                  //   isConfirmPasswordFilled =
                  //       _confirmPasswordController.text.isNotEmpty;
                  // });
                },
                controller: _controller,
                isPassword: false,
                lableText: 'Enter Phone Number',
              ),
              const SizedBox(
                height: 15,
              ),
              ButtonContainerWidget(
                color: AppColors.primaryColor,
                text: 'Continue',
                isFilled: true,
                onTapListener: () {
                  // context.push("/loginScreen");
                },
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: TextSpan(
                  text:
                      'By clicking the above button and creating an account, you have read and accepted the Terms of Service and acknowledged our Privacy Policy',
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.3,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
