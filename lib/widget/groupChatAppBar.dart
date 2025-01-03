// import 'package:chatchat/models/user_model.dart';
// import 'package:chatchat/providers/authenticationProvider.dart';
// import 'package:chatchat/utils/constant.dart';
// import 'package:chatchat/utils/global_method.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// class Groupchatappbar extends StatefulWidget {
//   final String groupId;

//   const Groupchatappbar({super.key, required this.groupId});

//   @override
//   State<Groupchatappbar> createState() => _ChatappbarState();
// }

// class _ChatappbarState extends State<Groupchatappbar> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: context
//           .read<AuthenticationProvider>()
//           .userStream(userId: widget.groupId),
//       builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return const Center(child: Text(Constant.somethingWentWrong));
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final groupModel =
//             GroupModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
//         return Row(
//           children: [
//             userImageWidget(
//                 imageUrl: groupModel.groupImage,
//                 radius: 20,
//                 onTap: () {
//                   // Navigate to group settings screen
//                   Navigator.pushNamed(
//                     context,
//                     Constant.profileScreen,
//                     arguments: groupModel.uid,
//                   );
//                 }),
//             const SizedBox(width: 10),
//             Column(
//               children: [
//                 Text(groupModel.groupName, style: const TextStyle(fontSize: 18)),
//                 Text(
//                   groupModel.isOnline ? 'Online' : 'Offline',
//                   style: const TextStyle(fontSize: 12),
//                 )
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
