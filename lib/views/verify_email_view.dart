import 'package:flutter/material.dart';
import 'package:lab4/constants/routes.dart';
import 'package:lab4/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email'),),
      body: Column(children: [
          const Text('We have sent you an email verification!'),
          const Text("If you haven't received a verification email yet, press this button"),
          TextButton(onPressed: () async {
            await AuthService.firebase().sendEmailVerification();
          },
          child: const Text('Send email verification'),
          ),
          TextButton(onPressed: () async {
              await AuthService.firebase().logOut();

              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);

          }, child: const Text('Restart'),)
        ],
      ),
    ); 
  }
}