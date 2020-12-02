import 'package:covidapp/sceens/reset_password_screen.dart';
import 'package:covidapp/sceens/signup.dart';
import 'package:covidapp/sceens/verify_email_screen.dart';
import 'package:covidapp/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false, obscurePassword = true;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  String email, password;
  final AuthService authentication = AuthService();

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'В пароле должно быть более 8 символов';
    } else {
      return null;
    }
  }

  String emailValidator(String value) {
    if (value == null) {
      return 'Введите электронную почту';
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return 'Проверьте правильность ввода электронной почты';
      } else {
        return null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Form(
          key: loginFormKey,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.16),
                    Center(
                      child: Text(
                        'Войти',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.email,
                            size: 20,
                          ),
                          labelText: 'электронная почта'),
                      onChanged: (value) {
                        email = value;
                      },
                      validator: emailValidator,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            child: Icon(
                              obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20.0,
                              color: Colors.grey,
                            ),
                          ),
                          labelText: 'пароль'),
                      validator: pwdValidator,
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: obscurePassword,
                    ),
                    SizedBox(height: 20),
                    Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ResetPasswordScreen()));
                            },
                            child: Text('Забыли пароль?'))),
                    SizedBox(height: 20),
                    MaterialButton(
                        color: Colors.amber,
                        minWidth: 250,
                        elevation: 10,
                        height: size.width / 10,
                        child: Text(
                          'Войти',
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 18),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () async {
                          if (loginFormKey.currentState.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            dynamic result =
                                await authentication.signIn(email, password);
                            if (result == null) {
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerifyEmailScreen(),
                                ),
                              );
                            }
                          }
                        }),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text('Не имеете аккаунта?',
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text(' Зарегистрироваться',
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 15)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
