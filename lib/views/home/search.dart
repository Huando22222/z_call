import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("search"),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Search",
            ),
            onChanged: (value) {
              username = value;
              setState(() {});
            },
          ),
          if (username != null)
            if (username!.length > 3)
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isEqualTo: username)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.docs.isEmpty ?? false) {
                      return const Text("no User found !");
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          return ListTile(
                            leading: IconButton(
                              onPressed: () async {
                                QuerySnapshot q = await FirebaseFirestore
                                    .instance
                                    .collection('chats')
                                    .where(
                                  'users',
                                  arrayContains: [
                                    FirebaseAuth.instance.currentUser!.uid,
                                    doc.id,
                                  ],
                                ).get();

                                if (q.docs.isEmpty) {
                                  var data = {
                                    'users': [
                                      FirebaseAuth.instance.currentUser!.uid,
                                      doc.id,
                                    ],
                                    'recent_text': "hi",
                                  };

                                  FirebaseFirestore.instance
                                      .collection('chats')
                                      .add(data);
                                } else {}
                              },
                              icon: Icon(Icons.chat),
                            ),
                            title: Text(doc['username']),
                            trailing: FutureBuilder<DocumentSnapshot>(
                              future: doc.reference
                                  .collection('followers')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data?.exists ?? false) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        await doc.reference
                                            .collection('followers')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .delete();
                                        setState(() {});
                                      },
                                      child: Text("unfollow"),
                                    );
                                  }
                                  return ElevatedButton(
                                    onPressed: () async {
                                      await doc.reference
                                          .collection('followers')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .set(
                                        {
                                          'time': DateTime.now(),
                                        },
                                      );
                                      setState(() {});
                                    },
                                    child: Text("follow"),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
        ],
      ),
    );
  }
}
