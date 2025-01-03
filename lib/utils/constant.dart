class Constant {
  // app related constants
  static const String appName = 'Ross Chat';
  static const String appTagLine = 'Chat with your friends';
  static const String appVersion = '1.0.0';

  // screens Routes
  static const String loginScreen = '/loginScreen';
  static const String otpScreen = '/otpScreen';
  static const String userinformationscreen = '/userinformationscreen';
  static const String homescreen = '/homescreen';
  static const String chatscreen = '/chatscreen';
  static const String profileScreen = '/profileScreen';
  static const String searchScreen = '/searchScreen';
  static const String addFriendScreen = '/addFriendScreen';
  static const String friendProfileScreen = '/friendProfileScreen';
  static const String friendRequestScreen = '/friendRequestScreen';
  static const String friendRequestSentScreen = '/friendRequestSentScreen';
  static const String settingScreen = '/settingScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String aboutScreen = '/aboutScreen';
  static const String privacyScreen = '/privacyScreen';
  static const String termsScreen = '/termsScreen';
  static const String helpScreen = '/helpScreen';
  static const String logoutScreen = '/logoutScreen';
  static const String landingScreen = '/Landigscreen';
  static const String friendsScreen = '/friendsScreen';

  // data Const
  static const String uid = 'uid';
  static const String name = 'name';
  static const String token = 'token';
  static const String phoneNumber = 'phoneNumber';
  static const String aboutMe = 'about Me';
  static const String image = 'image';
  static const String lastSeen = 'lastSeen';
  static const String createdAt = 'createdAt';
  static const String isOnline = 'isOnline';
  static const String friendsUids = 'friendsUids';
  static const String receivefriendRequestsUids = 'receivefriendRequestsUids';
  static const String sentFriendRequestsUids = 'sentFriendRequestsUids';
  static const String isFriend = 'isFriend';
  static const String isFriendRequestSent = 'isFriendRequestSent';
  static const String isFriendRequestReceived = 'isFriendRequestReceived';
  static const String isFriendRequestAccepted = 'isFriendRequestAccepted';
  static const String isFriendRequestRejected = 'isFriendRequestRejected';
  static const String isFriendRequestCancelled = 'isFriendRequestCancelled';
  static const String isFriendRequestCancelledByMe =
      'isFriendRequestCancelledByMe';
  static const String isFriendRequestCancelledByOther =
      'isFriendRequestCancelledByOther';
  static const String userImages = 'userImages';
  static const String contactUid = 'contactUid';
  static const String contactName = 'contactName';
  static const String contactPhoneNumber = 'contactPhoneNumber';
  static const String contactImage = 'contactImage';
  static const String groupId = 'groupId';
  static const String isMe = 'isMe';
  static const String users = 'users';
  static const String chats = 'chats';
  static const String messages = 'messages';
  static const String groups = 'groups';
  static const String lastMessage = 'lastMessage';
  static const String message = 'message';
  static const String senderId = 'senderId';
  static const String receiverId = 'receiverId';
  static const String verificationId = 'verificationId';
  static const String userModel = 'userModel';

  // messages constant
  static const String messageId = 'messageId';
  static const String messageText = 'messageText';
  static const String messageType = 'messageType';
  //static const String messageStatus = 'messageStatus';
  static const String sentTime = 'sentTime';
  static const String senderUid = 'senderUid';
  static const String senderName = 'senderName';
  static const String senderImage = 'senderImage';
  static const String timeSent = 'timeSent';
  static const String isSeen = 'isSeen';
  static const String repliedMessage = 'repliedMessage';
  static const String repliedTo = 'repliedTo';
  static const String repliedMessageType = 'repliedMessageType';
  // static const String messageStatusReadByBoth = 'readByBoth';
  // static const String messageStatusReadByNone = 'readByNone';

  static const String profile = 'Profile';
  static const String somethingWentWrong = 'Something went wrong';
  static const String viewfriendRequest = 'View Friend Request';
  static const String friendList = 'view friends';
  static const String sendfriendRequest = 'send friend request';
  static const String logout = 'logout';
  static const String logoutMessage = 'are you sure you want to logout !?';
  static const String cancel = 'cancel';
  static const String settings = 'Settings';
  static const String changeTheme = 'Change theme';
  static const String noUserFound = 'No user Found';
  static const String noFriend = 'you dont have any friends';
  static const String noChat = 'you have not chat with anyone';
  static const String noMessageYet = 'no message yet';
  static const String cancelFriendRequest = 'Cancel Friend Request';
  static const String acceptFriendRequest = 'Accept Friend Request';
  static const String sendMessage = 'send message';
  static const String unFriend = 'unFriend';
  static const String sure = 'are u sure';
  static const String sureAdvertise = 'this action cannot be undone';
  static const String frienRemove = 'friend Remove succesfully';
  static const String viewFriendRequest = 'view friend request';
  static const String onLine = 'online';
  static const String offLine = 'offline';
  static const String lastSeenAt = 'last seen at';
  static const String lastSeenappBar = 'last seen';
  static const String video = 'video';
  static const String document = 'document';
  static const String you = 'you';
  static const String chatFiles = 'chat files';
  static const String gallery = 'gallery';

  // appBar title Constant
  static const String friendScreenAppTitle = 'your friends';
  static const String friendRequestScreenAppTitle = 'your friend request';
  static const String chatScreenAppTitle = 'chat';

  // snackBar message title
  static const String success = 'success';
  static const String error = 'error';
  static const String warning = 'warning';
  static const String info = 'info';
  static const String question = 'question';

  // static message content
  static const String permissionNotGranted = 'permission non valide';
  static const String permissionNotGrantedAudio =
      'permission d\'acceder à l\'audio non valide';
}

enum ChatViewType { all, chat, group }

enum MessageEnum { text, image, video, audio, document }

enum FriendViewType { all, friend, friendRequest, groupView }

// extension convertMessageEnumToString on String
extension MessageEnumExtension on String {
  MessageEnum toMessageEnum() {
    switch (this) {
      case 'text':
        return MessageEnum.text;
      case 'image':
        return MessageEnum.image;
      case 'video':
        return MessageEnum.video;
      case 'audio':
        return MessageEnum.audio;
      case 'document':
        return MessageEnum.document;
      default:
        return MessageEnum.text;
    }
  }
}
