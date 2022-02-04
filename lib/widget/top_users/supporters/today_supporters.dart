import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:provider/provider.dart';
import '../../../provider/top_users_provider.dart';

class TodaySupporters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TopUsersProvider(),
      child: Consumer<TopUsersProvider>(builder: (context, topusers, child) {
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => topusers.todaySupporters != null,
          fallbackBuilder: (context) =>
              Center(child: CircularProgressIndicator()),
          widgetBuilder: (context) => Conditional.single(
            context: context,
            conditionBuilder: (context) =>
                topusers.todaySupporters.data.isNotEmpty,
            fallbackBuilder: (context) => Center(child: Text("No Top Users")),
            widgetBuilder: (context) => ListView.separated(
                itemCount: topusers.todaySupporters.data.length,
                separatorBuilder: (context, index) => SizedBox(height: 5),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      height: 80,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(topusers
                                  .todaySupporters.data[index].user.image))),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(topusers.todaySupporters.data[index].user.name),
                        Text(
                            'تم دعم المضيف ب ${topusers.todaySupporters.data[index].value} كوينز')
                      ],
                    ),
                  );
                }),
          ),
        );
      }),
    );
  }
}
