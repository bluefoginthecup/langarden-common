// lib/auth/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:langarden_common/auth/sign_up_screen.dart';


class AuthScreen extends StatefulWidget {
  final void Function(User user) onAuthSuccess;

  const AuthScreen({Key? key, required this.onAuthSuccess}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // 공통 컨트롤러
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 회원가입 시 추가 입력필드
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // 공통 함수: 사용자 프로필을 Firestore에 저장 (문서가 없으면)
  Future<void> saveUserProfile(User user, {String? phone, String? name}) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      await userDoc.set({
        'email': user.email,
        'name': name ?? user.displayName ?? '',
        'phone': phone ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> _registerWithEmail() async {
    try {
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final User? user = userCredential.user;
      if (user != null) {
        print("✅ 이메일 회원가입 성공: ${user.email}");
        // 추가 정보 저장 (Firestore 이용)
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'phone': _phoneController.text.trim(),
          'name': _nameController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        widget.onAuthSuccess(user);
      }
    } catch (e) {
      print("❌ 이메일 회원가입 오류: $e");
      // 오류 처리
    }
  }


  Future<void> _signInWithEmail() async {
    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final User? user = userCredential.user;
      if (user != null) {
        print("✅ 이메일 로그인 성공: ${user.email}");
        await saveUserProfile(user);
        widget.onAuthSuccess(user);
      }
    } catch (e) {
      print("❌ 이메일 로그인 오류: $e");
      // 에러 메시지 AlertDialog 등으로 사용자에게 알리기 가능
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // 로그인 취소
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        print("✅ Google 로그인 성공: ${user.displayName}");
        // 사용자 프로필 저장 (전화번호는 추가 입력받지 않았다면 빈 문자열)
        await saveUserProfile(user);
        widget.onAuthSuccess(user);
      }
    } catch (e) {
      print("❌ Google 로그인 오류: $e");
    }
  }

  Future<void> _signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
      );
      final userCredential =
      await _auth.signInWithCredential(oauthCredential);
      final User? user = userCredential.user;
      if (user != null) {
        print("✅ Apple 로그인 성공: ${user.displayName}");
        await saveUserProfile(user);
        widget.onAuthSuccess(user);
      }
    } catch (e) {
      print("❌ Apple 로그인 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("회원가입 / 로그인")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 구글 및 애플 로그인 버튼은 그대로 둘 수 있습니다.
            ElevatedButton(
              onPressed: () async {
                print("Google 로그인 버튼 클릭됨");
                await _signInWithGoogle();
              },
              child: Text("Google 로그인"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _signInWithApple,
              child: Text("Apple 로그인"),
            ),
            SizedBox(height: 20),
            // 이메일/비밀번호 로그인 섹션
            Text("로그인", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "이메일",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "비밀번호",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _signInWithEmail,
              child: Text("이메일 로그인"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(
                      onSignUpSuccess: (User user) {
                        widget.onAuthSuccess(user);
                      },
                    ),
                  ),
                );
              },
              child: Text("회원가입"),
            ),
          ],
        ),
      ),
    );
  }
}
