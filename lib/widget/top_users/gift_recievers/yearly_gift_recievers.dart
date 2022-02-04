import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:provider/provider.dart';
import '../../../provider/top_users_provider.dart';
import '../../follow_button.dart';

class YearlyGiftRecievers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TopUsersProvider>(builder: (context, topusers, child) {
      return Conditional.single(
        context: context,
        conditionBuilder: (context) => topusers.yearlyTopReceiversUsers != null,
        fallbackBuilder: (context) =>
            Center(child: CircularProgressIndicator()),
        widgetBuilder: (context) => Conditional.single(
          context: context,
          conditionBuilder: (context) =>
              topusers.yearlyTopReceiversUsers.data != null,
          fallbackBuilder: (context) => Center(child: Text("No Top Users")),
          widgetBuilder: (context) => ListView.separated(
              itemCount: topusers.yearlyTopReceiversUsers.data.length,
              separatorBuilder: (context, index) => SizedBox(height: 5),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Card(
                        child: ListTile(
                      title: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                topusers.yearlyTopReceiversUsers.data[index]
                                    .user.name,
                              ),
                              Text(
                                  'تم استلام ${topusers.yearlyTopReceiversUsers.data[index].value} ماسه')
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ],
                      ),
                      trailing: FollowButton(
                          following: topusers.yearlyTopReceiversUsers
                              .data[index].user.followers[index]),
                      leading: Container(
                        width: 60,
                        height: 60,
                        child: Image.network(topusers
                            .yearlyTopReceiversUsers.data[index].user.image),
                      ),
                    )),
                  ],
                );
              }),
        ),
      );
    });
  }
}
