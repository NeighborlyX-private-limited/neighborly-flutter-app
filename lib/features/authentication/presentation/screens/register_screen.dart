import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../widgets/button_widget.dart';
import '../widgets/or_divider_widget.dart';
import '../widgets/register_option.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  serverClientId:
      '805628551035-m915bsicvr5c2id664e8etia8ekmvot9.apps.googleusercontent.com',
  // '805628551035-k20h8ab6vdvr8qth03hn0r53hdgh4vo4.apps.googleusercontent.com',
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
  bool _isAuthorized = false;
  String _contactText = '';
  bool _isButtonActive = true;

  late TextEditingController _controller;

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

    _googleSignIn.signInSilently();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool noConnection = false;
  bool isPhoneFilled = false;
  bool phoneAlreadyExists = false;
  bool isPhoneValid = true;

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
            size: 20,
          ),
          onTap: () {
            context.pop();
          },
        ),
        centerTitle: true,
        title: Row(
          children: [
            SizedBox(width: 100),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Sign up',
                  style: onboardingHeading1Style,
                ),
              ),
              const SizedBox(height: 40),
              BlocConsumer<RegisterBloc, RegisterState>(
                listener: (BuildContext context, RegisterState state) {
                  if (state is OAuthSuccessState) {
                    bool isSkippedTutorial =
                        ShardPrefHelper.getIsSkippedTutorial();
                    bool isViewedTutorial =
                        ShardPrefHelper.getIsViewedTutorial();
                    if (!isSkippedTutorial && !isViewedTutorial) {
                      print('OAuth Success State in regester');
                      context.go('/tutorialScreen');
                    } else {
                      context.push('/home/false');
                    }
                  }
                },
                builder: (context, state) {
                  return RegisterOption(
                    image: Image.asset('assets/google_icon.png'),
                    title: 'Continue with Google',
                    onTap: () {
                      if (!_isButtonActive) return; // Prevent multiple taps
                      setState(() {
                        _isButtonActive = false; // Disable the button
                      });
                      print('GoogleSignUpEvent press...');
                      BlocProvider.of<RegisterBloc>(context).add(
                        GoogleSignUpEvent(),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              RegisterOption(
                image: Image.asset('assets/email_icon.png'),
                title: 'Continue with Email',
                onTap: () {
                  context.push("/registerWithEmailScreen");
                },
              ),
              const SizedBox(height: 20),
              const OrDividerWidget(),
              const SizedBox(height: 20),

              /// phone number text field
              TextFieldWidget(
                border: true,
                inputType: TextInputType.phone,
                maxLength: 10,
                onChanged: (value) {
                  setState(() {
                    isPhoneFilled = _controller.text.isNotEmpty;
                  });
                },
                controller: _controller,
                isPassword: false,
                lableText: 'Enter Phone Number',
              ),

              isPhoneValid
                  ? SizedBox()
                  : Text(
                      'Please enter a valid phone number.',
                      style: TextStyle(color: Colors.red),
                    ),
              phoneAlreadyExists
                  ? const Text(
                      'Phone Number already exists. Please login.',
                      style: TextStyle(color: Colors.red),
                    )
                  : const SizedBox(),
              const SizedBox(height: 15),
              BlocConsumer<RegisterBloc, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterFailureState) {
                    if (state.error.contains('exists')) {
                      setState(() {
                        phoneAlreadyExists = true;
                      });
                    } else if (state.error.contains('internet')) {
                      setState(() {
                        noConnection = true;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  } else if (state is RegisterSuccessState) {
                    context.push('/otp/${_controller.text}/phone-register');
                  }
                },
                builder: (context, state) {
                  if (state is RegisterLoadingState) {
                    return Center(
                      child: BouncingLogoIndicator(
                        logo: 'images/logo.svg',
                      ),
                    );
                    // return const Center(
                    //   child: CircularProgressIndicator(),
                    // );
                  }
                  return ButtonContainerWidget(
                    color: AppColors.primaryColor,
                    text: 'Continue',
                    isActive: isPhoneFilled,
                    isFilled: true,
                    onTapListener: () {
                      if (!isValidPhoneNumber(_controller.text.trim())) {
                        setState(() {
                          isPhoneValid = false;
                        });
                        return;
                      }

                      BlocProvider.of<RegisterBloc>(context).add(
                        RegisterButtonPressedEvent(
                          phone: _controller.text.trim(),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 15),

              noConnection
                  ? Center(
                      child: const Text(
                        'No Internet Connection, Please try again.',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 30),
              Center(
                child: RichText(
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
                        text: 'Terms of Service.',
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
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
