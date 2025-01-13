class Constant {
  // app related constants
  static const String appName = 'Ross Chat';
  static const String appTagLine = 'Chat with your friends';
  static const String appVersion = '1.0.0';

  // home screen related constants
  static const String private = 'private';
  static const String public = 'public';
  static const String group = 'groups';
  static const String chat = 'chat';
  static const String people = 'people';
  static const String friend = 'friend';
  static const String search = 'search';
  static const String searchFriend = 'search friend';

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
  static const String groupSettingsScreen = "/groupSettingsScreen";

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
  static const String reactions = 'reactions';
  static const String changeLanguage = 'change language';

  //Error
  static const String codeAutoRetrivalTimeOut =
      'Code auto-retrieval timed out. Please request a new code.';
  static const String emptyGroupName =
      'Group name cannot be empty or less than 3 character';
  static const String emptyGroupDescription =
      'Group description cannot be empty';

  // success messages
  //static const String success = 'Success';
  static const String groupCreated = 'Group created successfully';

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

  static const String profile = 'Profile';
  static const String somethingWentWrong = 'Something went wrong';
  static const String viewfriendRequest = 'View Friend Request';
  static const String friendList = 'view friends';
  static const String sendfriendRequest = 'send friend request';
  static const String friendAccepted = 'you are now friend with: ';
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
  static const String you = 'You';
  static const String and = 'and';
  static const String chatFiles = 'chat files';
  static const String gallery = 'gallery';
  static const String maintain = 'maintenance';
  static const String maintainMessage = 'ceci est en maintenance';
  static const String maintenance = 'maintenance';
  static const String done = "done";
  static const String delete = "delete";
  static const String selectAdmins = "select admins";

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

  // constant for group
  static const String createrUid = 'createrUid';
  static const String groupName = "groupName";
  static const String groupImage = "groupImage";
  static const String groupDescription = "groupDescription";
  static const String lastMessageId = "lastMessageId";
  static const String groupMembers = "group members";
  static const String groupInfo = "group info";
  static const String selectGroupMembers = "select group members";
  static const String groupCreatedAt = "groupCreatedAt";
  static const String isPrivate = "isPrivate";
  static const String editSettings = "editSettings";
  static const String ApproveMembers = "ApproveMembers";
  static const String lockMessages = "lockMessages";
  static const String requestToJoin = "requestToJoin";
  static const String groupMembersUids = "groupMembersUids";
  static const String adminsUids = "adminsUids";
  static const String awaitingApprovalUids = "awaitingApprovalUids";

  //static const String groupSettingsScreen = "group chat";
  static const String groupSettings = "group settings";
  static const String createGroup = 'create group';
  static const String editGroupSettings = 'edit group settings';
  static const String settingSubltitle =
      'Only admin can edit group info, name, image and description';
  static const String approveNewMembers = 'Approve new members';
  static const String approveMembersSubtitle =
      'New members will be added after admin approval';
  static const String requestsToJoin = 'Requests to join';
  static const String requestsToJoinSubtitle =
      "Request incomming members to join the group, before viewing group content";
  static const String lockMessagesGroup = "Lock messages";
  static const String lockMessagesSubtitle =
      "Only admins can send messages, other members can only read messages";
  static const String groupAdmins = "Group Admins";
  // static const String groupAdminsSubtitle =
  static const String noAdmins = "you are the only admin";
  static const String emptyGroupMember =
      "No members yet in the group add members before add other admins";
  static const String groupImages = "groupImages";
}
