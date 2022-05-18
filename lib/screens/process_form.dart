import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProcessForm extends StatefulWidget {
  const ProcessForm({Key? key, required this.id, required this.name})
      : super(key: key);
  final String id;
  final String name;

  @override
  State<ProcessForm> createState() => _ProcessFormState();
}

class _ProcessFormState extends State<ProcessForm> {
  final _storage = const FlutterSecureStorage();
  String? username = "";
  String? password = "";
  String basicAuth = "init";
  List<_SecItem>? _list = List.empty();

  Future<void> _getLoggedUser() async {
    final _username = await _storage.read(key: 'username');
    final _password = await _storage.read(key: 'password');

    setState(() {
      username = _username;
      password = _password;
      basicAuth = 'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    });
  }

  Future<List<_SecItem>?> _getFormVariables() async {
    var response = await http.get(
        Uri.parse(
            "http://digitalisi.tn:8080/engine-rest/process-definition/${widget.id}/form-variables"),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      for (MapEntry e in map.entries) {
        //  print("Key ${e.key}, Value ${(e.value['type'])}");
        setState(() {
          //_list?.add(_SecItem(e.key, e.value['type']));
          _list = [...?_list, _SecItem(e.key, e.value['type'])];
        });
      }
    } else {
      //show toast here
    }
    return _list;
  }

  @override
  void initState() {
    super.initState();
    _getLoggedUser().then((value) => _getFormVariables());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: Form(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _list?.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => {},
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _list![index].key,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        autofocus: false,
                        onChanged: (text) {
                          _list?[index].value = text;
                        },
                        validator: (value) {
                          if (value == "") {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        // validator: null,
                        onSaved: (value) {
                          // passwordController.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.text_fields),
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: _list![index].key,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ],
                  ),
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          startProcess(_list);
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.start),
      ),
    );
  }

  Future<void> startProcess(List<_SecItem>? list) async {
    var variables = "{ \"variables\": {";
    int i = 1;
    list?.forEach((element) {
      variables = variables + element.toString();
      if (i < list.length) {
        variables = variables + ",";
      }
      i++;
    });
    variables = variables + "}}";

    var response =
        await http.post(
            Uri.parse(
                "http://digitalisi.tn:8080/engine-rest/process-definition/${widget.id}/submit-form"),
            headers: <String, String>{
              'authorization': basicAuth,
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: (variables));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Process started succesfully");

      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "Error starting process");
    }
  }
}

class _SecItem {
  _SecItem(this.key, this.value);

  String key;
  String value;

  @override
  String toString() {
    return " \"$key\": { \"value\": \"$value\",\"type\": \"String\"} ";
  }
}
