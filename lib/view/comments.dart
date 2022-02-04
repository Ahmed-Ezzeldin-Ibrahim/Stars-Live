import 'package:flutter/material.dart';
import '../constant/contant.dart';

class CommentsWidget extends StatefulWidget {
  @override
  _CommentsWidgetState createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: Text(localized(context, 'comments'),style: TextStyle(fontSize: 22,color: Colors.white),),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(Icons.arrow_back_ios,size: 30,color: Colors.white,),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 22,
                itemBuilder: (context,index){
                  return _buildCommentWidget();
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            child: Row(
              children: [
                InkWell(
                  onTap: (){},
                  child: Image.asset('assets/img/camera.png',height: 25,width: 25,fit: BoxFit.fill,),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextFormField(
                        controller: _commentController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (input){
                          if(input.isEmpty){
                            return 'should fill comment';
                          }else{
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12),
                            // prefixIcon: Icon(Icons.mail_outline),
                            filled: true,
                            fillColor: Color(0xffF5F5F5),
                            border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45))
                        )
                    ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: (){},
                  child: Image.asset('assets/img/send.png',height: 25,width: 25,fit: BoxFit.fill,),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildCommentWidget(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage('assets/img/person.png'),
                    fit: BoxFit.cover
                )
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: Card(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('mahmoud sayed',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18,color: Colors.black,
                            fontWeight: FontWeight.w600),),
                       SizedBox(
                         height: 8,
                       ),
                       Text('nice post try commeent again',
                        style: TextStyle(fontSize: 15,color: baseColor.withOpacity(.4),
                            fontWeight: FontWeight.w400),
                       ),
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}
