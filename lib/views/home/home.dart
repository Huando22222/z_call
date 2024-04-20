import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:z_call/views/home/search.dart';
import 'package:z_call/views/home/utils/image_post.dart';
import 'package:z_call/views/home/utils/text_post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController postText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                TextFormField(
                  controller: postText,
                  decoration: InputDecoration(labelText: "post sth"),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        var data = {
                          'time': DateTime.now(),
                          'type': 'text',
                          'content': postText.text,
                          "uid": FirebaseAuth.instance.currentUser!.uid,
                        };

                        FirebaseFirestore.instance
                            .collection('posts')
                            .add(data);
                        postText.text = "";
                        setState(() {});
                      },
                      child: Text("post"),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('timeline')
                .get(),
            builder: (context, snapshot) {
              print(
                  "----------------------------------${snapshot.data?.docs.length}");
              if (snapshot.hasData) {
                if (snapshot.data?.docs.isEmpty ?? true) {
                  return Text("no post");
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .doc((snapshot.data?.docs[index].data()
                                as Map)['post'])
                            .get(),
                        builder: (context, postsnapshot) {
                          if (postsnapshot.hasData) {
                            switch (postsnapshot.data!['type']) {
                              case 'text':
                                return TextPost(
                                  text: postsnapshot.data!['content'],
                                );
                              case 'image':
                                return ImagePost(
                                  text: postsnapshot.data!['content'],
                                  url: postsnapshot.data!['url'],
                                );
                              default:
                                return TextPost(
                                  text: postsnapshot.data!['content'],
                                );
                            }
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      );
                    },
                  );
                }
              } else {
                return LinearProgressIndicator();
              }
            },
          ))
        ],
      ),
    );
  }
}
