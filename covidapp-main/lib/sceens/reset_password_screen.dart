import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Form(
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
                      'Password Reset',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: size.height * 0.07),
                  SizedBox(height: 25),
                  MaterialButton(
                      color: Colors.amber,
                      minWidth: 250,
                      elevation: 2,
                      height: size.width / 10,
                      child: Text(
                        'Password Reset',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 18),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      onPressed: () async {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
