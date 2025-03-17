// lib/screens/auth/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
final void Function(User user) onSignUpSuccess;

const SignUpScreen({Key? key, required this.onSignUpSuccess}) : super(key: key);

@override
_SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
final FirebaseAuth _auth = FirebaseAuth.instance;

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
final TextEditingController _nameController = TextEditingController();

Future<void> _registerWithEmail() async {
if (_phoneController.text.trim().isEmpty || _nameController.text.trim().isEmpty) {
showDialog(
context: context,
builder: (context) => AlertDialog(
title: Text('회원가입 오류'),
content: Text('전화번호와 이름을 모두 입력해주세요.'),
actions: [
TextButton(
onPressed: () => Navigator.pop(context),
child: Text('확인'),
)
],
),
);
return;
}
try {
final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
email: _emailController.text.trim(),
password: _passwordController.text.trim(),
);
final User? user = userCredential.user;
if (user != null) {
await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
'email': user.email,
'phone': _phoneController.text.trim(),
'name': _nameController.text.trim(),
'createdAt': FieldValue.serverTimestamp(),
}); // 이메일 인증 메일 전송
await user.sendEmailVerification();
// 사용자에게 이메일 인증을 요청하는 다이얼로그 표시
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text("이메일 인증"),
    content: Text("회원가입이 완료되었습니다.\n\n이메일로 전송된 인증 메일을 확인하신 후, 인증이 완료되면 로그인을 진행해주세요."),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context); // 다이얼로그 닫기
          // 인증이 완료되지 않았으므로 사용자를 강제로 로그아웃 처리합니다.
          FirebaseAuth.instance.signOut();
        },
        child: Text("확인"),
      ),
    ],
  ),
);
  // widget.onAuthSuccess(user); 를 호출하지 않음
  // 사용자가 인증 후에 별도로 로그인을 진행하도록 유도합니다.
}
}catch (e) {
showDialog(
context: context,
builder: (context) => AlertDialog(
title: Text('이메일 회원가입 오류'),
content: Text(e.toString()),
actions: [
TextButton(
onPressed: () => Navigator.pop(context),
child: Text('확인'),
)
],
),
);
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('회원가입')),
body: SingleChildScrollView(
padding: const EdgeInsets.all(16.0),
child: Column(
children: [
TextField(
controller: _emailController,
decoration: const InputDecoration(
labelText: '이메일',
border: OutlineInputBorder(),
),
keyboardType: TextInputType.emailAddress,
),
const SizedBox(height: 10),
TextField(
controller: _passwordController,
decoration: const InputDecoration(
labelText: '비밀번호 (6자 이상)',
border: OutlineInputBorder(),
),
obscureText: true,
),
const SizedBox(height: 10),
TextField(
controller: _phoneController,
decoration: const InputDecoration(
labelText: '전화번호',
border: OutlineInputBorder(),
),
keyboardType: TextInputType.phone,
),
const SizedBox(height: 10),
TextField(
controller: _nameController,
decoration: const InputDecoration(
labelText: '이름',
border: OutlineInputBorder(),
),
),
const SizedBox(height: 20),
ElevatedButton(
onPressed: _registerWithEmail,
child: const Text('회원가입'),
),
],
),
),
);
}
}
