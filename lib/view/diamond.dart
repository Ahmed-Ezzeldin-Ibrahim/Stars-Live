import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../constant/contant.dart';
import '../helper/echo.dart';
import '../main_provider_model.dart';
import '../repository/chargersResponse.dart';

class DiamondWidget extends StatefulWidget {
  @override
  _DiamondWidgetState createState() => _DiamondWidgetState();
}

class _DiamondWidgetState extends State<DiamondWidget> {
  @override
  Widget build(BuildContext context) {
    MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(h * .08),
          child: AppBar(
            backgroundColor: baseColor,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context)),
            centerTitle: true,
            elevation: 0,
            title: Text(
              localized(context, 'diamonds'),
              style: GoogleFonts.cairo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        body: Container(
          height: h,
          width: w,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    'assets/img/diamond.png',
                    height: 40,
                    width: 40,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${mainProviderModel.profileData.balanceInCoins}',
                    style: GoogleFonts.cairo(color: Color(0xffFFC700), fontSize: 19, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FreightForwarderWidget())),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 2),
                        color: baseColor.withOpacity(.1),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        localized(context, 'freight_forwarder'),
                        style: GoogleFonts.cairo(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Icon(
                      Icons.arrow_back,
                      color: baseColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FreightForwarderWidget())),
                          child: _diamondPriceWidget(index: index + 1),
                        );
                      }))
            ],
          ),
        ));
  }

  Widget _diamondPriceWidget({int index}) {
    return Card(
      shape: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              'assets/img/diamond.png',
              height: 50,
              width: 50,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                '${7150 * index}',
                style: GoogleFonts.cairo(color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(color: Color(0xffFFC700), borderRadius: BorderRadius.circular(10)),
              child: Text(
                '${25 * index} ${localized(context, 'coin')}',
                style: GoogleFonts.cairo(color: baseColor, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FreightForwarderWidget extends StatefulWidget {
  @override
  _FreightForwarderWidgetState createState() => _FreightForwarderWidgetState();
}

class _FreightForwarderWidgetState extends State<FreightForwarderWidget> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(h * .08),
          child: AppBar(
            backgroundColor: baseColor,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context)),
            centerTitle: true,
            elevation: 0,
            title: Text(
              localized(context, 'freight_forwarder'),
              style: GoogleFonts.cairo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        body: FutureBuilder<List<SingleCharger>>(
          future: networkGetChargers(context),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Container(
                height: h,
                width: w,
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          launchWhatsApp('${snapshot.data[index].whats}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                '${index + 1} ',
                                style: GoogleFonts.cairo(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(100))),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: '${snapshot.data[index].avatar}',
                                      width: 75,
                                      height: 75,
                                      errorWidget: (context, url, error) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 17,
                                          ),
                                        );
                                      },
                                      placeholder: (context, url) {
                                        return CircularProgressIndicator();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${snapshot.data[index].name}',
                                      style: GoogleFonts.cairo(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      '${snapshot.data[index].whats}',
                                      style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            else if (snapshot.hasError)
              return GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                      ),
                      if (false && kDebugMode) Text('${snapshot.error}'),
                      Text("انترنت ضعيف او لايوجد اتصال بالانترنت", style: TextStyle(color: Colors.black)),
                      SizedBox(height: 12),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.black,
                          ),
                          child: Text("اعادة المحاولة", style: TextStyle(color: Colors.white))),
                    ],
                  ),
                ),
              );
            else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  launchWhatsApp(phoneNumber) async {
    Fluttertoast.showToast(msg: phoneNumber);
    final link = WhatsAppUnilink(
      phoneNumber: phoneNumber,
      text: "",
    );
    Fluttertoast.showToast(msg: link.text);
    await launch('$link');
  }

  Future<List<SingleCharger>> networkGetChargers(BuildContext context) async {
    final prefs = GetStorage();
    try {
      Dio dio = Dio();
      dio.interceptors.add(LogInterceptor(responseBody: true));
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${prefs.read('current_user_apiToken')}";

      Map<String, dynamic> queryParameters = Map();

      Response response = await dio.post('${baseLinkApi}chargers/all', queryParameters: queryParameters);
      ChargersResponse chargersResponse = new ChargersResponse.fromJson(response.data);

      return chargersResponse.data;
    } on DioError catch (e) {
      Echo('error $e');
      return Future.error('error $e');
    }
  }
}
