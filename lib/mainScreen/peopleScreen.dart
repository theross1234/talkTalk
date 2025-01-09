import 'package:chatchat/enums/enums.dart';
import 'package:chatchat/models/user_model.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/utils/assetManager.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:chatchat/widget/friendWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Peoplescreen extends StatefulWidget {
  const Peoplescreen({super.key});

  @override
  State<Peoplescreen> createState() => _PeoplescreenState();
}

class _PeoplescreenState extends State<Peoplescreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel;
    return Scaffold(
      //appBar: AppBar(title:Text("appbar"),),
      body: Column(children: [
        // cuppertino search bar
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSearchTextField(
              placeholder: Constant.search,
              onChanged: (value) {},
            )),

        // list of people
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: context
                    .read<AuthenticationProvider>()
                    .getAllUserStream(userId: currentUser!.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text(Constant.somethingWentWrong);
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 300,
                            width: 300,
                            child: Lottie.asset(AssetsManager.noDataFound)),
                        const Text(
                          Constant.noUserFound,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ));
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      final data = UserModel.fromMap(
                          document.data()! as Map<String, dynamic>);
                      return FriendWidget(
                          friend: data, viewType: FriendViewType.allUsers);

                      // ListTile(
                      //   leading: userImageWidget(
                      //       imageUrl: data[Constant.image],
                      //       radius: 40,
                      //       onTap: () {
                      //         //Navigate to profile screen with uid as argument
                      //         Navigator.pushNamed(
                      //           context,
                      //           Constant.profileScreen,
                      //           arguments: document.id,
                      //         );
                      //       }),
                      //   title: Text(data[Constant.name]),
                      //   subtitle: Text(
                      //     data[Constant.aboutMe],
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // );
                    }).toList(),
                  );
                })),
      ]),
    );
  }
}
