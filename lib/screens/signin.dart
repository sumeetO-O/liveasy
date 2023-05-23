import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/screens/otp.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'globals.dart' as globals;

class SignIn extends StatefulWidget {
  static String verificationId = '';
  static bool isLoading = false;

  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? mobNum = '';
  bool _hasTenNo = false;
  bool hasError = false;
  Widget loader = Transform.scale(
      scale: 0.7,
      child: const CircularProgressIndicator(
          strokeWidth: 1,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
  Widget subTxt = const Text('CONTINUE',
      style: TextStyle(
          fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white));

  void submit(context) async {
    var appSignatureID = await SmsAutoFill().getAppSignature;
    Map sendOtpData = {
      "mobile": mobNum,
      "appSignatureID": appSignatureID,
    };
    debugPrint("sendOtpData: $sendOtpData");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Otp()));
    setState(() {
      SignIn.isLoading = false;
    });
  }

  void _continue() async {
    if (_hasTenNo) {
      debugPrint('U clicked continue and submitted number is +91$mobNum');
      setState(() {
        SignIn.isLoading = true;
      });
      globals.mobNum = mobNum;
      await FirebaseAuth.instance.verifyPhoneNumber(
        //If you see anywhere await, go on top and change the function to async
        phoneNumber: '+91$mobNum',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            hasError = true;
            SignIn.isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint('Verification ID: $verificationId');
          debugPrint('Resend Token: $resendToken');
          SignIn.verificationId = verificationId;

          submit(context);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      debugPrint('Seems like firebase got skippd');
    } else {
      setState(() {
        hasError = true;
        SignIn.isLoading = false;
      });
    }
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
                    debugPrint('U clicked back on otp screen');
                  },
                  icon: const Icon(
                    IconData(0xf71e,
                        fontFamily: CupertinoIcons.iconFont,
                        fontPackage: CupertinoIcons.iconFontPackage),
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.17, 20, 0),
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        "Please enter your mobile number",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 30),
                      child: Text(
                        "You’ll receive a 4 digit code \n to verify next.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Color.fromRGBO(106, 108, 123, 1),
                        ),
                      ),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      maxLength: 10,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Mobile Number",
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Color.fromRGBO(106, 108, 123, 1),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 15, top: 8),
                          child: Wrap(
                            children: [
                              Image.asset(
                                "assets/india.png",
                                width: 30,
                                height: 30,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 20, top: 4),
                                child: Text(
                                  "+91   -",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(47, 48, 55, 1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: hasError
                              ? const BorderSide(
                                  color: Colors.redAccent, width: 2)
                              : const BorderSide(
                                  color: Color.fromRGBO(47, 48, 55, 1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: hasError
                              ? const BorderSide(
                                  color: Colors.redAccent, width: 2)
                              : const BorderSide(
                                  color: Color.fromRGBO(47, 48, 55, 1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: hasError
                              ? const BorderSide(
                                  color: Colors.redAccent, width: 2)
                              : const BorderSide(
                                  color: Color.fromRGBO(47, 48, 55, 1)),
                        ),
                      ),
                      onChanged: (value) {
                        mobNum = value;
                        debugPrint(
                            'Length of Mobile Number: ${mobNum!.length}');
                        if (mobNum!.length == 10) {
                          setState(() {
                            _hasTenNo = true;
                            hasError = false;
                          });
                          FocusManager.instance.primaryFocus!.unfocus();
                        } else {
                          setState(() {
                            _hasTenNo = false;
                          });
                        }
                      },
                      onSubmitted: (value) {
                        debugPrint('Entered Mobile Number: $value');
                        debugPrint('Status: $_hasTenNo');
                        if (_hasTenNo) {
                          debugPrint('U clicked continue');
                          globals.mobNum = mobNum;
                        } else {
                          setState(() {
                            hasError = true;
                          });
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 58,
                        child: TextButton(
                          onPressed: _continue,
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
                          child: (SignIn.isLoading) ? loader : subTxt,
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
