import 'package:chatchat/enums/enums.dart';
import 'package:chatchat/models/user_model.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/utils/assetManager.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/widget/friendWidget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Frienlist extends StatelessWidget {
  final FriendViewType viewType;

  const Frienlist({super.key, required this.viewType});

  @override
  Widget build(BuildContext context) {
    //final userModel = context.read<AuthenticationProvider>().userModel;
    final uid = context.read<AuthenticationProvider>().userModel!.uid;

    final future = viewType == FriendViewType.friend
        ? context.read<AuthenticationProvider>().getFriendList(uid)
        : viewType == FriendViewType.friendRequest
            ? context.read<AuthenticationProvider>().getFriendRequestList(uid)
            : context.read<AuthenticationProvider>().getFriendList(uid);

    return FutureBuilder<List<UserModel>>(
      future: future,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text(Constant.somethingWentWrong));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Lottie.asset(AssetsManager.pepePooLottie)),
                  const Text(
                    Constant.noFriend,
                  )
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = data[index];
              return FriendWidget(friend: user, viewType: viewType);
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
