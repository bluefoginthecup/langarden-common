// lib/auth/profile_update_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final User user; // 현재 로그인한 사용자를 전달합니다.
  const ProfileUpdateScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // 비밀번호 변경을 위한 컨트롤러들
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();


  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // 초기 이메일은 FirebaseAuth에서 가져오고, 나머지 정보는 Firestore에서 로드합니다.
    _emailController.text = widget.user.email ?? '';
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _phoneController.text = data['phone'] ?? '';
          _nameController.text = data['name'] ?? '';
        });
      }
    } catch (e) {
      print("사용자 프로필 로드 오류: $e");
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newEmail = _emailController.text.trim();
      final user = widget.user;

      // 이메일이 변경되었으면 verifyBeforeUpdateEmail 사용
      if (newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);
        // 사용자에게 새 이메일로 전송된 확인 메일을 확인하라고 안내할 수 있습니다.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('새 이메일로 확인 메일이 전송되었습니다. 확인 후 이메일이 업데이트됩니다.')),
        );
      }

      // Firestore의 사용자 프로필 업데이트
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'email': newEmail,
        'phone': _phoneController.text.trim(),
        'name': _nameController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 비밀번호 변경 처리
      final currentPassword = _currentPasswordController.text.trim();
      final newPassword = _newPasswordController.text.trim();
      if (currentPassword.isNotEmpty && newPassword.isNotEmpty) {
        // 재인증: 현재 이메일과 현재 비밀번호로 재인증 진행
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        // 비밀번호 업데이트
        await user.updatePassword(newPassword);
        print("비밀번호 업데이트 성공");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필이 업데이트되었습니다.')),
      );

      Navigator.pop(context); // 업데이트 후 이전 화면으로 돌아갑니다.
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '예기치 못한 오류가 발생했습니다.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원정보 수정'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: '전화번호',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            // 비밀번호 변경 입력란
            Text('비밀번호 변경 (선택)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: '현재 비밀번호',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: '새 비밀번호 (6자 이상)',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _updateProfile,
              child: Text('프로필 업데이트'),
            ),
          ],
        ),
      ),
    );
  }
}
