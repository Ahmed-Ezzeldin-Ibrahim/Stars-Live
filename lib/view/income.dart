import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:starslive/helper/apis.dart';
import 'package:starslive/main_provider_model.dart';
import 'package:starslive/repository/charge_response.dart';
import 'package:starslive/repository/network_custom.dart';

import '../constant/contant.dart';
import 'buy.dart';

class IncomeWidget extends StatefulWidget {
  @override
  _IncomeWidgetState createState() => _IncomeWidgetState();
}

class _IncomeWidgetState extends State<IncomeWidget> {
  bool convertDiamondToCoingLoading = false;
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
            localized(context, 'income'),
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
            SizedBox(height: 10),
            _rowWidget(context),
            SizedBox(height: 50),
            Center(
              child: Text(
                localized(context, 'balance') + ': ' + '${mainProviderModel.profileData.diamonds}',
                style: GoogleFonts.cairo(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: MaterialButton(
                onPressed: () async {
                  if (convertDiamondToCoingLoading) return;
                  if (mainProviderModel.profileData.type == 'host' || kDebugMode) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuyScreen()));
                  } else {
                    convertDiamondToCoingLoading = true;
                    setState(() {});
                    try {
                      dynamic response = await networkCustom(
                        context: context,
                        apiUrl: '$BASEURL/user/send_coins',
                        queryParameters: {},
                        methodPost: true,
                      );
                      ChargeResponse chargeResponse = ChargeResponse.fromJson(response.data);
                      if (chargeResponse.status != 'error') {
                        Fluttertoast.showToast(msg: 'تم التحويل بنجاح');
                      } else {
                        Fluttertoast.showToast(msg: '${chargeResponse.msg}');
                      }
                    } catch (e) {
                      Fluttertoast.showToast(msg: 'حدث خطا اثناء عملية التحويل');
                    }
                    convertDiamondToCoingLoading = false;
                    setState(() {});
                  }
                },
                color: baseColor,
                elevation: 0,
                height: 55,
                minWidth: w - 30,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                child: convertDiamondToCoingLoading
                    ? Container(
                        child: Center(child: CircularProgressIndicator(backgroundColor: Colors.white)),
                      )
                    : Text(
                        localized(context, 'withdrow'),
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _rowWidget(BuildContext context) {
    MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localized(context, 'totalIcome'),
          style: GoogleFonts.cairo(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 5),
            Image.asset(
              'assets/img/diamond.png',
              height: 40,
              width: 40,
              fit: BoxFit.fill,
            ),
            SizedBox(width: 10),
            Text(
              '${mainProviderModel.profileData.totalReceivedGifts}',
              style: GoogleFonts.cairo(color: Color(0xffFFC700), fontSize: 23, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ],
    );
  }
}
