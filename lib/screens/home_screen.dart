import 'package:camunda_flutter/models/process.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = const FlutterSecureStorage();
  String? username = "";
  String? password = "";
  String basicAuth = "init";
  List<Process_def> _list = List<Process_def>.empty();

  Future<void> _getLoggedUser() async {
    final _username = await _storage.read(key: 'username');
    final _password = await _storage.read(key: 'password');
    setState(() {
      username = _username;
      password = _password;
      basicAuth = 'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    });
  }

  Future<List<Process_def>> _getProcessList() async {
    List<Process_def> _processList;

    var response = await http.get(
        Uri.parse(
            "http://digitalisi.tn:8080/engine-rest/process-definition?latest=true"),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      var data = res as List;
      setState(() {
        _list = data
            .map<Process_def>((json) => Process_def.fromJson(json))
            .toList();
        print(_list);
      });
    } else {
      //show toast here
    }
    return _list;
  }

  @override
  void initState() {
    super.initState();
    _getLoggedUser().then((value) => _getProcessList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome $username"),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              logout(context);
            },
            child: const Icon(
              Icons.logout, // add custom icons also
            ),
          ),
        ),
        body: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => print(_list[index].id),
                  child: Column(
                    children: [
                      Text(
                        _list[index].id!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      Container(
                        color: Colors.redAccent,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.center,
                        child: Text(
                          _list[index].name!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ));
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

class _SecItem {
  _SecItem(this.key, this.value);

  final String key;
  final String value;
}
