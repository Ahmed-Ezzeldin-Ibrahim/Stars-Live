import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/contant.dart';
import '../model/User.dart';
import '../provider/SearchProvider.dart';
import 'profilePage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String s = '';
  String name , path ;
  int level ;
  User passToProfile ;
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                controller: textEditingController,
                onEditingComplete: (){
                  setState(() {
                    print(textEditingController.text);
                    Provider.of<SearchProvider>(context,listen: false).getSearchUser(context,id: textEditingController.text);
                    passToProfile = Provider.of<SearchProvider>(context,listen: false).getSearched();
                    print('***** name = ${passToProfile.name}');
                    name = Provider.of<SearchProvider>(context,listen: false).user.name;
                    path = Provider.of<SearchProvider>(context,listen: false).user.image;
                    level = Provider.of<SearchProvider>(context,listen: false).user.userLevel.level;
                  });
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {

                      },
                    ),
                    hintText: 'بحث',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                    border: InputBorder.none
                ),
              ),
            ),
          )
      ),
      body: (name != null && path != null && level != null)?
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>profileScreen(passToProfile)));
            },
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white10
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Image.network(path,width: 50,height: 50,),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${name}'),
                    SizedBox(height: 5,),
                    Text('level : ${level}'),
                  ],
                ),
                ],
              ),
            ),
          ),
        ):Center(child: Text('no results')),
    );
  }
}