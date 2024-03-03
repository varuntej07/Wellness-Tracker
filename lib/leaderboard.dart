import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'authentication/login.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('UserData');

  void _reloadLeaderboard() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leader Board"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Login())),
            icon: const Icon(Icons.person),
            tooltip: 'Sign in',
          ),
          IconButton(
            onPressed: _reloadLeaderboard,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.orderBy('points', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching leaderboard data'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No leaderboard data found'));
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> userData = documents[index].data() as Map<String, dynamic>;
              String username = userData['username'] ?? 'Unknown User';

              // Converting the points value to int, handling nulls and ensuring a default value of 0
              int userPoints = (userData['points'] as num?)?.toInt() ?? 0;
              return ListTile(
                title: Text(username),
                trailing: Text('$userPoints points'),
              );
            },
          );
        },
      ),
    );
  }
}
