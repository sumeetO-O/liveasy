import 'package:flutter/material.dart';
import 'package:liveasy/screens/home.dart';
import 'globals.dart' as globals;

enum ProfileType { shipper, transporter }

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileType? _character = ProfileType.shipper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Please select your profile",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                InkWell(
                  onTap: () {
                    setState(() {
                      _character = ProfileType.shipper;
                    });
                    debugPrint("Status of Profile: ${_character.toString().split('.').last}");
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Transform.scale(
                          scale: 0.8,
                          child: Container(
                                  width: 38,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: const Color.fromRGBO(46, 59, 98, 1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Visibility(
                                    maintainAnimation: true,
                                    maintainSize: true,
                                    maintainState: true,
                                    visible: (_character == ProfileType.shipper)? true : false,
                                    child: Container(
                                      width: 27,
                                      height: 27,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: const Color.fromRGBO(46, 59, 98, 1),
                                      ),
                                    ),
                                  )
                                ),
                        ),
                        const SizedBox(width: 20),
                        const SizedBox(
                          height: 45,
                          width: 45,
                          child: FittedBox(
                              fit: BoxFit.cover,
                              child: ImageIcon(AssetImage("assets/home.png"))),
                        ),
                        const SizedBox(width: 20),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Shipper",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 160,
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(106, 108, 123, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                InkWell(
                  onTap: () {
                    setState(() {
                      _character = ProfileType.transporter;
                    });
                    debugPrint("Status of Profile: ${_character.toString().split('.').last}");
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Transform.scale(
                          scale: 0.8,
                          child: Container(
                                  width: 38,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: const Color.fromRGBO(46, 59, 98, 1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Visibility(
                                    maintainAnimation: true,
                                    maintainSize: true,
                                    maintainState: true,
                                    visible: (_character == ProfileType.transporter)? true : false,
                                    child: Container(
                                      width: 27,
                                      height: 27,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: const Color.fromRGBO(46, 59, 98, 1),
                                      ),
                                    ),
                                  )
                                ),
                        ),
                        const SizedBox(width: 20),
                        const SizedBox(
                          height: 45,
                          width: 45,
                          child: FittedBox(
                              fit: BoxFit.cover,
                              child: ImageIcon(AssetImage("assets/truck.png"))),
                        ),
                        const SizedBox(width: 20),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Transporter",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 160,
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(106, 108, 123, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: TextButton(
                        onPressed: () {
                          globals.profile = _character.toString().split('.').last;
                          debugPrint('Profile_Selected: ${_character.toString().split('.').last}');
                          Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) => const Home()), (route) => false);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(46, 59, 98, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                        child: const Text(
                          "CONTINUE",
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
        ),
      ),
    );
  }
}





