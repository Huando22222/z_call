import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:z_call/views/auth/login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? username;
  String? email;
  String? password;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sign Up")),
        body: Center(
          child: Form(
            key: key,
            child: ListView(
              padding: EdgeInsets.all(12),
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                  ),
                  validator: ValidationBuilder().maxLength(10).build(),
                  onChanged: (value) {
                    username = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                  validator: ValidationBuilder().email().maxLength(50).build(),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "password",
                  ),
                  validator:
                      ValidationBuilder().minLength(6).maxLength(50).build(),
                  onChanged: (value) {
                    password = value;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (key.currentState?.validate() ?? false) {
                      print(email);

                      try {
                        UserCredential userCred = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email!,
                          password: password!,
                        );

                        if (userCred.user != null) {
                          var data = {
                            'username': username,
                            'email': email,
                            'created_at': DateTime.now()
                          };

                          print(
                              "*************************************************************** ${data}");
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userCred.user!.uid)
                              .set(data);
                        }
                        print("222222222222222222222222222222222222222");
                        if (mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Text("Sign Up"),
                )
              ],
            ),
          ),
        ));
  }
}
