import 'dart:convert';
import 'dart:io';
import 'package:chatchat/models/user_model.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/widget/frienList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isSuccessful = false;
  bool _isLoading = false;
  String? _uid;
  String? _phoneNumber;
  UserModel? _userModel;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get isSuccessful => _isSuccessful;
  String? get uid => _uid;
  String? get phoneNumber => _phoneNumber;
  UserModel? get userModel => _userModel;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // check authentication state
  Future<bool> checkAuthenticationState() async {
    bool isSignedIn = false;
    await Future.delayed(const Duration(seconds: 2));
    if (_auth.currentUser != null) {
      _uid = _auth.currentUser!.uid;

      // get user data From firestore
      await getUserDataFromFirestore();

      print(
          "get user data from firestore good on the checkAuthenticationState");

      // save user data to shared preference
      await saveUserDatatoSharedPreferences();

      print(
          "save user data to shared preference good on the checkAuthenticationState");

      notifyListeners();
      isSignedIn = true;
    } else {
      isSignedIn = false;
    }

    return isSignedIn;
  }

  // check if user exists in firestore
  Future<bool> checkUserExists() async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection(Constant.users).doc(_uid).get();

      if (documentSnapshot.exists) {
        print('User exists in Firestore.');
        return true;
      } else {
        print('User does not exist in Firestore.');
        return false;
      }
    } catch (e) {
      print('Error checking user existence: $e');
      return false; // Default to false in case of error
    }
  }

  // set user online status
  Future<void> setUserOnlineStatus({required bool value}) async {
    await _firestore
        .collection(Constant.users)
        .doc(_auth.currentUser!.uid)
        .update({Constant.isOnline: value});
  }

  //get user data from firestore
  // Future<void> getUserDataFromFirestore() async {
  //   DocumentSnapshot documentSnapshot =
  //       await _firestore.collection(Constant.users).doc(_uid).get();
  //   _userModel =
  //       UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
  //   notifyListeners();
  // }
  Future<void> getUserDataFromFirestore() async {
    try {
      print('enter User data fetching.');
      DocumentSnapshot documentSnapshot =
          await _firestore.collection(Constant.users).doc(_uid).get();

      print('Document exists: ${documentSnapshot.exists}');
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        _userModel =
            UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
        notifyListeners();
        print('User data fetched successfully in firestore.');
        print(
            'User data fetched successfully in firestore. ${_userModel!.toMap().toString()}');
      } else {
        print('No user data found for UID: $_uid');
        // Handle the case where the user document does not exist or is empty
      }
    } catch (e) {
      print('Error fetching user data from Firestore: $e');
      // Handle errors (e.g., log them or provide feedback to the UI)
    }
  }

  Future<void> saveUserDatatoSharedPreferences() async {
    if (userModel != null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString(
          Constant.userModel, jsonEncode(userModel!.toMap()));
    } else {
      debugPrint(
          "Error: userModel is null. Cannot save to shared preferences.");
    }
  }

  // get data from shared preferences
  Future<void> getUserDatatoSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userModelString =
        sharedPreferences.getString(Constant.userModel) ?? "";
    _userModel = UserModel.fromMap(jsonDecode(userModelString));
    _uid = _userModel?.uid;
    notifyListeners();
  }

  //sign in with phone number
  Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    _isLoading = true;

    notifyListeners();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credentials) async {
        try {
          final UserCredential result =
              await _auth.signInWithCredential(credentials);
          _uid = result.user?.uid;
          _phoneNumber = result.user?.phoneNumber;
          _isSuccessful = true;
          _isLoggedIn = true;
        } catch (e) {
          _isSuccessful = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing in: ${e.toString()}'),
            ),
          );
          //showSnackBar(context, 'Error signing in: ${e.toString()}');
        } finally {
          _isLoading = false;
          notifyListeners();
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        _isSuccessful = false;
        _isLoading = false;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${e.message}'),
          ),
        );
        //showSnackBar(context, 'Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        _isLoading = false;
        notifyListeners();
        // Navigate to OTP input screen
        Navigator.of(context).pushNamed(Constant.otpScreen, arguments: {
          Constant.verificationId: verificationId,
          Constant.phoneNumber: phoneNumber,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP code sent!'),
          ),
        );
        //showSnackBar(context, 'OTP code sent!');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Code auto-retrieval timed out. Please request a new code.'),
          ),
        );
        //showSnackBar(context, 'Code auto-retrieval timed out. Please request a new code.');
      },
    );
  }

  //verify otp
  Future<void> verifyOTP({
    required String verificationId,
    required String otp,
    required BuildContext context,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      print('auth valide dans verify otp');
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential).then((value) async {
        print('auth valide dans sign in with credential');
        _uid = value.user?.uid;
        _phoneNumber = value.user?.phoneNumber;
        _isSuccessful = true;
        _isLoading = false;
        onSuccess();
        notifyListeners();
      }).catchError((e) {
        print('auth non valide');
        _isSuccessful = false;
        _isLoading = false;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error signing in: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        //snackBar(context, 'Error signing in: ${e.toString()}');
        //showSnackBar(context, 'Error signing in: ${e.toString()}');
      });
    } catch (e) {
      _isSuccessful = false;
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error signing in: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      //snackBar(context, 'Error signing in: ${e.toString()}');
      //showSnackBar(context, 'Error signing in: ${e.toString()}');
    }
  }

// save user data to firestore
  void saveUserDataToFirestore({
    required UserModel userModel,
    required File? fileImage,
    required Function onSuccess,
    required Function onFail,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (fileImage != null) {
        String imageUrl = await storeFileToStorage(
          file: fileImage,
          reference: '${Constant.userImages}/${userModel.uid}',
        );
        userModel.image = imageUrl;
      }

      userModel.lastSeen = DateTime.now().microsecondsSinceEpoch.toString();
      userModel.createdAt = DateTime.now().microsecondsSinceEpoch.toString();

      _userModel = userModel;

      _uid = userModel.uid;

      //save user data to firestore
      await _firestore
          .collection(Constant.users)
          .doc(_uid)
          .set(userModel.toMap());
      //await saveUserDatatoSharedPreferences();
      //_isSuccessful = true;
      _isLoading = false;
      onSuccess();
      notifyListeners();
    } on FirebaseException catch (e) {
      //_isSuccessful = false;
      _isLoading = false;
      notifyListeners();
      onFail(e.toString());
    }
  }

  // store File to storage and return file url
  Future<String> storeFileToStorage(
      {required File file, required String reference}) async {
    UploadTask uploadTask = _storage.ref().child(reference).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String fileUrl = await taskSnapshot.ref.getDownloadURL();
    return fileUrl;
  }

  // get user strem
  Stream<DocumentSnapshot> userStream({
    required String userId,
  }) {
    return _firestore.collection(Constant.users).doc(userId).snapshots();
  }

  // get all user Stream
  Stream<QuerySnapshot> getAllUserStream({
    required String userId,
  }) {
    return _firestore
        .collection(Constant.users)
        .where(
          Constant.uid,
          isNotEqualTo: userId,
        )
        .snapshots();
  }

  // send friend request
  Future<void> sendFriendRequest({
    required String receiverId,
  }) async {
    try {
      // add our uid to  receiver friend request list
      await _firestore.collection(Constant.users).doc(receiverId).update({
        Constant.receivefriendRequestsUids: FieldValue.arrayUnion([_uid]),
      });
      // add receiver uid to our friend request list
      await _firestore.collection(Constant.users).doc(_uid).update({
        Constant.sentFriendRequestsUids: FieldValue.arrayUnion([receiverId]),
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  // accept friend request
  Future<void> acceptFriendRequest({required String friendId}) async {
    // add our uid to friend list
    await _firestore.collection(Constant.users).doc(friendId).update({
      Constant.friendsUids: FieldValue.arrayUnion([_uid])
    });

    // add friend uid to our friend list
    await _firestore.collection(Constant.users).doc(_uid).update({
      Constant.friendsUids: FieldValue.arrayUnion([friendId])
    });

    // remove our uid form friend request list
    await _firestore.collection(Constant.users).doc(friendId).update({
      Constant.sentFriendRequestsUids: FieldValue.arrayRemove([_uid])
    });

    // remove our friend uid form our friend request sents list
    await _firestore.collection(Constant.users).doc(_uid).update({
      Constant.receivefriendRequestsUids: FieldValue.arrayRemove([friendId])
    });
  }

  // remove friends
  Future<void> removeFriend({
    required String friendId,
  }) async {
    // remove our uid from friend list
    await _firestore.collection(Constant.users).doc(friendId).update({
      Constant.friendsUids: FieldValue.arrayRemove([_uid])
    });
    // remove our friend uid from our friend list
    await _firestore.collection(Constant.users).doc(_uid).update({
      Constant.friendsUids: FieldValue.arrayRemove([friendId])
    });
  }

  // cancel friend request
  Future<void> cancelFriendRequest({
    required String receiverId,
  }) async {
    try {
      // remove our uid from  receiver friend request list
      await _firestore.collection(Constant.users).doc(receiverId).update({
        Constant.receivefriendRequestsUids: FieldValue.arrayRemove([_uid]),
      });
      // remove receiver uid from our friend request list
      await _firestore.collection(Constant.users).doc(_uid).update({
        Constant.sentFriendRequestsUids: FieldValue.arrayRemove([receiverId]),
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  // get list of friends
  Future<List<UserModel>> getFriendList(
    String uid,
  ) async {
    print('test si la recup des amis marche bien entrer dans la fonction');
    List<UserModel> friends = [];
    DocumentSnapshot snapshot =
        await _firestore.collection(Constant.users).doc(uid).get();

    List<dynamic> friendsUids = snapshot.get(Constant.friendsUids);
    notifyListeners();

    for (String friendUid in friendsUids) {
      DocumentSnapshot docSnap =
          await _firestore.collection(Constant.users).doc(friendUid).get();
      UserModel friend =
          UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
      print('test si la recup des amis marche bien ${friend.name}');
      notifyListeners();
      friends.add(friend);
    }
    return friends;
  }

  // get list of friend requests
  Future<List<UserModel>> getFriendRequestList(
    String uid,
  ) async {
    List<UserModel> friendRequests = [];
    DocumentSnapshot snapshot =
        await _firestore.collection(Constant.users).doc(uid).get();
    List<dynamic> friendRequestsUids =
        snapshot.get(Constant.receivefriendRequestsUids);

    for (String friendUid in friendRequestsUids) {
      DocumentSnapshot docSnap =
          await _firestore.collection(Constant.users).doc(friendUid).get();
      UserModel friends =
          UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
      print('test si la recup des requettes amis marche bien ${friends.name}');
      notifyListeners();
      friendRequests.add(friends);
    }
    return friendRequests;
  }

  // logout
  Future<void> logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
