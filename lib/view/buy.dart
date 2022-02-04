import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../helper/apis.dart';
import '../main_provider_model.dart';
import '../model/User.dart';
import '../provider/BuyProvider.dart';
import '../provider/SearchProvider.dart';
import '../repository/charge_response.dart';
import '../repository/my_info_response.dart';
import '../repository/network_custom.dart';

class BuyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: networkCustom(context: context, apiUrl: 'http://starslive.club/public/api/user/my-info', queryParameters: null, methodPost: false),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          MyInfoResponse myInfoResponse = MyInfoResponse.fromJson(snapshot.data.data);
          return BuyScreen2(myInfoResponse);
        } else if (snapshot.hasError) {
          Fluttertoast.showToast(msg: snapshot.error.toString());
          return Center(
              child: Column(
            children: [
              Text('حدث خطا'),
            ],
          ));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class BuyScreen2 extends StatefulWidget {
  final MyInfoResponse myInfoResponse;
  const BuyScreen2(this.myInfoResponse, {Key key}) : super(key: key);

  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen2> {
  TextEditingController money = TextEditingController();
  TextEditingController toId = TextEditingController();
  String m, name = '';
  int x;
  User passToBuy;
  bool covertUsdToCoinLoading = false;
  @override
  Widget build(BuildContext context) {
    MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => SimpleDialog(
                          title: Row(
                            children: [
                              GestureDetector(
                                child: Icon(Icons.arrow_back),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                width: 55,
                              ),
                              const Text(
                                'سجل الشحن',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.purple),
                              ),
                            ],
                          ),
                          children: <Widget>[
                            Container(
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.4,
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            if (widget.myInfoResponse.data.transactions.length < 1) Text('لا يوجد شحنات'),
                                            ...widget.myInfoResponse.data.transactions.map((e) {
                                              return Column(
                                                children: [
                                                  Container(width: double.infinity, height: 1),
                                                  Text('شحن قيمة: ${e.usd}'),
                                                  Text('عدد العملات المرسلة: ${e.coins}'),
                                                  Text('الي : ${e.toName} , ID : ${e.toId}'),
                                                  Divider(),
                                                ],
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {},
                              ),
                              width: 80,
                            ),
                          ],
                        ),
                      ).then((returnVal) {
                        if (returnVal != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('You clicked: $returnVal'),
                              action: SnackBarAction(label: 'OK', onPressed: () {}),
                            ),
                          );
                        }
                      });
                    },
                    child: Container(
                      width: 120,
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('سجل الشحن'),
                          Icon(Icons.arrow_back),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Text(
                        '${mainProviderModel.profileData.name}',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'ID:${mainProviderModel.profileData.id}',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 18),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 40,
                      child: Image.network(
                        '${mainProviderModel.profileData.image}',
                        width: 45,
                        height: 45,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                      color: Color(0xFF6134AC),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.network('${mainProviderModel.profileData.image}', width: 45, height: 50),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'الرصيد المتبقي للشحن',
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w100, fontSize: 14),
                                  textAlign: TextAlign.start,
                                ),
                                Text('${widget.myInfoResponse.data.currentShiftSalaryTotal} USD', style: TextStyle(color: Colors.white, fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.network('${mainProviderModel.profileData.image}', width: 45, height: 50),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'المبالغ التي تم شحنها خلال هذا الشهر',
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w100, fontSize: 14),
                                ),
                                Text('${widget.myInfoResponse.data.currentShiftTotalTransferred} USD'),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => SimpleDialog(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'اي دي الشحن',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                                    child: TextField(
                                      controller: toId,
                                      onChanged: (value) {
                                        setState(() {
                                          m = value;
                                          Provider.of<SearchProvider>(context, listen: false).getSearchUser(context, id: toId.text);
                                          print(toId.text);
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'شحن أموال',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                                    child: TextField(
                                      controller: money,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          //name = Provider.of<SearchProvider>(context,listen: false).user.name;
                                        });
                                      },
                                      decoration: InputDecoration(hintText: 'يرجى ادخال المبلغ (دولار)'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                                  //   child: Row(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                  //     children: [
                                  //       Image.asset(
                                  //         'assets/img/diamond.png',
                                  //         width: 25,
                                  //         height: 25,
                                  //       ),
                                  //       Text(
                                  //         '150',
                                  //         style: TextStyle(
                                  //           fontSize: 16,
                                  //         ),
                                  //       ),
                                  //       SizedBox(
                                  //         height: 20,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                              StatefulBuilder(
                                builder: (BuildContext context, setState2) {
                                  return covertUsdToCoinLoading
                                      ? Container(
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : GestureDetector(
                                          child: Container(
                                            padding: EdgeInsets.only(top: 5),
                                            width: double.infinity,
                                            height: 35,
                                            child: Text(
                                              'شحن',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(25),
                                              color: Colors.purple.shade300,
                                            ),
                                          ),
                                          onTap: () async {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context2) => SimpleDialog(
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        const Text(
                                                          'معلومات الشحن الخاصة بك',
                                                          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 16),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'اي دي الشحن : ',
                                                            ),
                                                            Text(
                                                              '${toId.text}',
                                                              style: TextStyle(color: Colors.black),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'الاسم : ',
                                                            ),
                                                            Text(
                                                              '${mainProviderModel.profileData.name}',
                                                              style: TextStyle(color: Colors.black),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        const Text(
                                                          'شحن أموال',
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              '${money.text} ',
                                                              style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 16),
                                                            ),
                                                            Text(
                                                              'Dollor = ',
                                                              style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 16),
                                                            ),
                                                            Text(
                                                              '${int.parse('${money.text}') * 286}',
                                                              style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 16),
                                                            ),
                                                            Image.asset(
                                                              'assets/img/diamond.png',
                                                              width: 20,
                                                              height: 20,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            FlatButton(
                                                              onPressed: () => Navigator.pop(context, 'Cancel'),
                                                              child: const Text('Cancel'),
                                                            ),
                                                            FlatButton(
                                                              onPressed: () async {
                                                                Provider.of<BuyProvider>(context, listen: false).getBuytoUser(id: toId.text, Usd: money.text);
                                                                /*showBottomSheet<String>(context: context, builder: (context)=>Container(
                                                                  decoration: BoxDecoration(
                                                                    border: Border(top: BorderSide(color: baseColor))
                                                                  ),
                                                                  child: ListView(
                                                                    shrinkWrap: true,
                                                                    primary: false,
                                                                    children: [
                                                                      ListTile(
                                                                        dense: true,
                                                                        title: Text('نتائج الشحن'),
                                                                      ),
                                                                      ListTile(
                                                                        dense: true,
                                                                        title: Text(
                                                                            Provider.of<BuyProvider>(context,listen: false).user.status != 'error' ?
                                                                            'تم الشحن بنجاح'
                                                                                : 'فشل الشحن'
                                                                        ),
                                                                      ),
                                                                      ListTile(
                                                                        dense: true,
                                                                        title: Text(
                                                                            '${Provider.of<BuyProvider>(context,listen: false).user.msg}',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                );*/
                                                                Navigator.pop(context);
                                                                covertUsdToCoinLoading = true;
                                                                setState2(() {});
                                                                Map<String, dynamic> queryParameters = Map();
                                                                queryParameters['usd'] = '${money.text}';
                                                                queryParameters['receiver_id'] = '${toId.text}';
                                                                try {
                                                                  Response response = await networkCustom(
                                                                    context: context,
                                                                    apiUrl: '$BASEURL/user/send_coins',
                                                                    queryParameters: queryParameters,
                                                                    methodPost: true,
                                                                  );
                                                                  ChargeResponse chargeResponse = ChargeResponse.fromJson(response.data);
                                                                  if (chargeResponse.status != 'error') {
                                                                    Fluttertoast.showToast(msg: 'تم الشحن بنجاح');
                                                                    mainProviderModel.profileData.salary = mainProviderModel.profileData.salary - double.parse(money.text);
                                                                  } else {
                                                                    Fluttertoast.showToast(msg: '${chargeResponse.msg}');
                                                                  }
                                                                } catch (e) {
                                                                  Fluttertoast.showToast(msg: 'حدث خطا اثناء عملية الشحن');
                                                                }
                                                                covertUsdToCoinLoading = false;
                                                                setState2(() {});
                                                                setState(() {});
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text(
                                                                'OK',
                                                                style: TextStyle(
                                                                  color: Color(0xff8A47F8),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                  width: 110,
                  height: 35,
                  child: Text(
                    'شحن الآن',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.purple.shade300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//

/*
SimpleDialog(
                                                          children: <Widget>[
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                SizedBox(height:30),
                                                                ListTile(
                                                                  dense: true,
                                                                  title: Text('نتائج الشحن'),
                                                                ),
                                                                SizedBox(height:30),
                                                                ListTile(
                                                                  dense: true,
                                                                  title: Text(
                                                                      Provider.of<BuyProvider>(context,listen: false).user.status != 'error' ?
                                                                      'تم الشحن بنجاح'
                                                                          : 'فشل الشحن'
                                                                  ),
                                                                ),
                                                                SizedBox(height:30),
                                                                ListTile(
                                                                  dense: true,
                                                                  title: Text(
                                                                    '${Provider.of<BuyProvider>(context,listen: false).user.msg}',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        );
 */



// To parse this JSON data, do
//
//     final chargeResponse = chargeResponseFromJson(jsonString);
