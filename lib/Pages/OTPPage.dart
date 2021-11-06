import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fooddeliveryapp/Firebase/FBAuth.dart';
import 'package:fooddeliveryapp/Icons_illustrations/Icons_illustrations.dart';
import 'package:fooddeliveryapp/Pages/MainPage.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPPage extends StatefulWidget {
  final String phoneNumber;
  final String userName;
  final String routes;

  OTPPage(this.phoneNumber, this.userName, this.routes);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  final _auth = FBAuth();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  String _verificationCode;

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    );

    return Scaffold(
      key: _globalKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Column(
            children: [
              Container(
                height: 250,
                width: 250,
                child: SvgPicture.asset(otp),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "OTP Verification",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.green,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                " We Sent Verification Code to ${widget.phoneNumber}",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff707070),
                  fontFamily: "Montserrat",
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Fill This Boxes with your Verification Code we Sent",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff707070),
                    fontFamily: "Montserrat",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: PinPut(
                  fieldsCount: 6,
                  withCursor: true,
                  textStyle:
                      const TextStyle(fontSize: 25.0, color: Colors.black),
                  eachFieldWidth: 40.0,
                  eachFieldHeight: 55.0,
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: pinPutDecoration,
                  selectedFieldDecoration: pinPutDecoration,
                  followingFieldDecoration: pinPutDecoration,
                  pinAnimationType: PinAnimationType.fade,
                  autofocus: true,
                  onSubmit: (pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode, smsCode: pin))
                          .then((value) {
                        if (value.user != null) {
                          _auth.saveUserData(widget.userName,
                              widget.phoneNumber, widget.routes);
                          print("go to Home");
                          Navigator.pushNamedAndRemoveUntil(
                              context, MainPage.id, (route) => false);
                        }
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      _showSnackBar("Invalid OTP");
                    }
                  }


                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              await _auth.saveUserData(
                  widget.userName, widget.phoneNumber, widget.routes);
              print("logged in Successfully");
              Navigator.pushNamedAndRemoveUntil(
                  context, MainPage.id, (route) => false);
            }

          });
        },
        verificationFailed: (FirebaseException e) {
          
        },
        codeSent: (String verificationID, int resendToken) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }

  void _showSnackBar(String text) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Container(
        height: 50,
        child: Center(
          child: Text(
            '$text',
            style: const TextStyle(fontSize: 20, color: Color(0xffFFDB84)),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
