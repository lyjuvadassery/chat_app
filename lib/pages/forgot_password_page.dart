import 'package:firebase_chat_app/helpers/app_utils.dart';
import 'package:firebase_chat_app/services/auth_service.dart';
import 'package:firebase_chat_app/helpers/color_theme.dart';
import 'package:firebase_chat_app/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _emailFieldController = TextEditingController();

  AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailFieldController.dispose();
    super.dispose();
  }

  _resetPassword() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
    }
    _authService.resetPassword(
      _emailFieldController.text.trim(),
    );

    AppUtils.showToast('Check your email for steps to reset your password');

    await Future.delayed(Duration(seconds: 3));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Spacer(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailFieldController,
                          style: simpleTextStyle(),
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)
                                ? null
                                : "Enter a valid email address";
                          },
                          cursorColor: ColorTheme.darkGrey,
                          decoration: textFieldInputDecoration("Email address"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  InkWell(
                    onTap: _resetPassword,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ColorTheme.primaryColor,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Reset Password',
                        style: solidButtonTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  )
                ],
              ),
            ),
    );
    ;
  }
}
