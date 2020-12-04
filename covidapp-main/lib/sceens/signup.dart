import 'package:covidapp/sceens/home_screen.dart';
import 'package:covidapp/sceens/verify_email_screen.dart';
import 'package:covidapp/services/auth.dart';
import 'package:covidapp/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  String email, password, firstName, lastName;
  var phoneNumber;
  final AuthService authentication = AuthService();

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  String nameValidator(String value) {
    if (value.length < 2) {
      return 'Введите своё имя';
    } else {
      return null;
    }
  }

  String phoneValidator(String value) {
    if (value.length < 10) {
      return 'Введите номер мобильного телефона';
    } else {
      return null;
    }
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Неверный адрес почты';
    } else if (regex == null) {
      return 'Введите электронную почту';
    } else {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
              padding: EdgeInsets.all(10),
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment(-0.9, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.keyboard_backspace),
                    ),
                  ),
                  SizedBox(height: size.height * 0.1),
                  Center(
                    child: Text(
                      'Зарегистрироваться',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: size.height * 0.07),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Имя'),
                            validator: nameValidator,
                            onChanged: (value) {
                              firstName = value;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Фамилия'),
                            validator: nameValidator,
                            onChanged: (value) {
                              lastName = value;
                            },
                            obscureText: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          size: 30,
                        ),
                        labelText: 'Номер телефона'),
                    onChanged: (value) {
                      phoneNumber = value;
                    },
                    validator: phoneValidator,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          size: 30,
                        ),
                        labelText: 'Электронная почта'),
                    onChanged: (value) {
                      email = value;
                    },
                    validator: emailValidator,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, size: 30),
                        labelText: 'Пароль'),
                    validator: pwdValidator,
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                  ),
                  SizedBox(height: 25),
                  MaterialButton(
                      color: Colors.red[200],
                      minWidth: 250,
                      elevation: 2,
                      height: size.width / 10,
                      child: Text(
                        'Зарегистрироваться',
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
                          var test =
                              await authentication.register(email, password);
                          if (test == null) {
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            await DatabaseService(userEmail: email)
                                .setUserData(
                                    email, firstName, lastName, phoneNumber)
                                .then((value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen())));
                            setState(() {
                              isLoading = true;
                            });
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
