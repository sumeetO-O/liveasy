import 'package:flutter/material.dart';
import 'package:liveasy/main.dart';
import 'globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 30),
                  const Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        "You are logged In",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.phone_android),
                    title: const Text('Phone Number'),
                    subtitle: Text('${FirebaseAuth.instance.currentUser!.phoneNumber}'),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.language_outlined),
                    title: const Text('Language Selected'),
                    subtitle: Text('${globals.language}'),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.manage_accounts),
                    title: const Text('Profile Details'),
                    subtitle: Text('${globals.profile}'),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      debugPrint("User Logged Out --------- Firstly ------------------------------------------------------------------------------------------------------");
                      await FirebaseAuth.instance.signOut();
                      Fluttertoast.showToast(
                        msg: "Logged Out Successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.deepPurple,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                      return runApp(const MyApp());
                    },
                    child: const Text('Logout'),
                  ),
                  const SizedBox(height: 30),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}