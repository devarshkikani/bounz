import 'package:google_sign_in/google_sign_in.dart';

class SigninwithGoogle {
  static Future<GoogleSignInAccount?> doSigninwithGoogle() async {
    GoogleSignInAccount? _currentUser;

    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly'
      ]);
      _currentUser = await _googleSignIn.signIn();
    } on Exception catch (_) {}

    return _currentUser;
  }
}
