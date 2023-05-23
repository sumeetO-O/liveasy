import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:liveasy/screens/profile.dart';
import 'package:liveasy/screens/signin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'globals.dart' as globals;

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String currentText = "";
  bool hasError = false;
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenOtp();
  }

  listenOtp() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    errorController.close();
    TextEditingController().dispose();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/group_three.png"),
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 10),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    debugPrint('U clicked cross');
                  },
                  icon: const Icon(
                    IconData(0xf4fd,
                        fontFamily: CupertinoIcons.iconFont,
                        fontPackage: CupertinoIcons.iconFontPackage),
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    10, MediaQuery.of(context).size.height * 0.17, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Verify Phone",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 30),
                      child: Text(
                        "Code is sent to ${globals.mobNum}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Color.fromRGBO(106, 108, 123, 1),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: PinFieldAutoFill(
                        currentCode: currentText,
                        codeLength: 6,
                        onCodeSubmitted: (code) {},
                        onCodeChanged: (code) {
                          if (code!.length == 6) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            currentText = code;
                            textEditingController.text = currentText;
                          }
                        },
                      ),
                    ),
                    PinCodeTextField(
                      appContext: context,
                      keyboardType: TextInputType.number,
                      useHapticFeedback: true,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(0),
                        borderWidth: hasError ? 2 : 0,
                        errorBorderColor: Colors.redAccent,
                        fieldHeight: 50,
                        fieldWidth: 50,
                        inactiveFillColor: Colors.blue.shade50,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      enablePinAutofill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      onCompleted: (v) {
                        debugPrint("Completed with $v");
                        debugPrint('OTP u entered: $currentText');
                      },
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                        });
                        debugPrint('OTP u r typing : $currentText');
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Didn't receive the code?",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(106, 108, 123, 1)),
                          ),
                          TextButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                //If you see anywhere await, go on top and change the function to async
                                phoneNumber: '+91${globals.mobNum}',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed:
                                    (FirebaseAuthException e) {},
                                codeSent:
                                    (String verificationId, int? resendToken) {
                                  debugPrint(
                                      'Verification ID: $verificationId');
                                  debugPrint('Resend Token: $resendToken');
                                  SignIn.verificationId = verificationId;
                                  Fluttertoast.showToast(
                                      msg: "OTP Resent Successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      fontSize: 14.0);
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                              );
                            },
                            child: const Text("Request Again",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromRGBO(6, 29, 40, 1))),
                          )
                        ]),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 58,
                        child: TextButton(
                          onPressed: () async {
                            debugPrint(
                                'U clicked verify and the current text is of length: ${currentText.length}');
                            if (currentText.length != 6) {
                              debugPrint('OTP length is not 6');
                              errorController.add(ErrorAnimationType
                                  .shake); // Triggering error shake animation
                              setState(() {
                                hasError = true;
                              });
                            } else {
                              setState(() {
                                hasError = false;
                              });
                              debugPrint('Succesfully sent, calling firebase');
                              // Firebase call ------------
                              final FirebaseAuth auth = FirebaseAuth.instance;
                              debugPrint('Ur entered OTP is: $currentText');
                              try {
                                // Create a PhoneAuthCredential with the code
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: SignIn.verificationId,
                                        smsCode: currentText);

                                // Sign the user in (or link) with the credential
                                await auth.signInWithCredential(credential);

                                // If everything is alright then go to profile page
                                // ignore: use_build_context_synchronously
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Profile()),
                                    (route) => false);
                              } catch (e) {
                                debugPrint('WRONG OTP => Error: $e');
                                errorController.add(ErrorAnimationType
                                    .shake); // Triggering error shake animation
                                setState(() {
                                  hasError = true;
                                });
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(46, 59, 98, 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                          child: const Text(
                            "VERIFY AND CONTINUE",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
