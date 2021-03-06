import 'package:camunda_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? username = "";
  String? password = "";
  String basicAuth = "init";

  final storage = const FlutterSecureStorage();

  Future<void> _getLoggedUser() async {
    final _username = await storage.read(key: 'username');
    final _password = await storage.read(key: 'password');
    setState(() {
      username = _username;
      password = _password;
      basicAuth = 'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    });
  }

  @override
  void initState() {
    super.initState();
    _getLoggedUser().then((value) => {
          if (username != null && username != "")
            {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()))
            }
        });
  }

  //editing controllers
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //username field
    final userNameField = TextFormField(
      autofocus: false,
      controller: userNameController,
      keyboardType: TextInputType.name,

      // validator: null,
      onSaved: (value) {
        userNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle_rounded),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "UserName",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,

      // validator: null,
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    // Button

    final loginButton = Material(
      elevation: 5,
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () =>
            {login(userNameController.text, passwordController.text)},
        child: const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  SizedBox(
                    height: 120,
                    child: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 45),
                  userNameField,
                  const SizedBox(height: 45),
                  passwordField,
                  const SizedBox(height: 45),
                  loginButton
                ])),
          ),
        ),
      )),
    );
  }

  void login(String username, String password) async {
    {
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      var response = await http.get(
          Uri.parse(
              "http://digitalisi.tn:8080/engine-rest/process-definition/"),
          headers: <String, String>{'authorization': basicAuth});

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        Fluttertoast.showToast(msg: "Login $username");
        // Write value
        await storage.write(key: 'username', value: username);
        await storage.write(key: 'password', value: password);
      } else {
        Fluttertoast.showToast(msg: "Incorrect credentials");
      }
    }
  }
}
