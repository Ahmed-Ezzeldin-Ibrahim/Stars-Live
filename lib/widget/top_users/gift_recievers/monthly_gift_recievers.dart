import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:provider/provider.dart';
import '../../../provider/top_users_provider.dart';
import '../../follow_button.dart';

class MonthlyGiftRecievers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TopUsersProvider>(builder: (context, topusers, child) {
      return Conditional.single(
        context: context,
        conditionBuilder: (context) =>
            topusers.monthlyTopReceiversUsers != null,
        fallbackBuilder: (context) =>
            Center(child: CircularProgressIndicator()),
        widgetBuilder: (context) => Conditional.single(
          context: context,
          conditionBuilder: (context) =>
              topusers.monthlyTopReceiversUsers.data.isNotEmpty,
          fallbackBuilder: (context) => Center(child: Text("No Top Users")),
          widgetBuilder: (context) => ListView.separated(
              itemCount: topusers.monthlyTopReceiversUsers.data.length,
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
                                topusers.monthlyTopReceiversUsers.data[index]
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
                            .monthlyTopReceiversUsers.data[index].user.image),
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
