import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {

  static final AuthRepository _authRepository = new AuthRepository._internal();
  GoogleSignIn _googleSignIn;
  FirebaseAuth _auth;

  factory AuthRepository() {
    return _authRepository;
  }

  AuthRepository._internal() {
    _googleSignIn = GoogleSignIn();
    _auth = FirebaseAuth.instance;
  }

  Future<FirebaseUser> signInUsingGoogle() async {
    if(await _googleSignIn.isSignedIn())
      return await _auth.currentUser();
    var googleUser = await _googleSignIn.signIn();
    var googleSignInAuthentication = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
    return (await _auth.signInWithCredential(credential)).user;
  }
}