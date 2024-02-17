import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SigninwithAppleService {
  static Future doAppleSignIn() async {
    dynamic credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.vernost.bounzRewards',
          redirectUri: Uri.parse(
            'https://bounz-14253.firebaseapp.com/__/auth/handler',
          ),
        ),
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } on Exception catch (_) {}

    return credential;
  }
}
