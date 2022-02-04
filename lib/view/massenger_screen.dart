import 'package:flutter/material.dart';
import '../repository/user_repository.dart';

class Massangerscreen extends StatefulWidget {
  @override
  _MassangerscreenState createState() => _MassangerscreenState();
}

class _MassangerscreenState extends State<Massangerscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        title: Text(
          'friends',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10),
        height: 250,
        child: ListView.builder(
            itemCount: currentUser.value.followers.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      child: Image.network(
                          currentUser.value.followers[index].image),
                      radius: 20,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.value.followers[index].name,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                        onPressed: () {}, icon: Icon(Icons.check_box)),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
