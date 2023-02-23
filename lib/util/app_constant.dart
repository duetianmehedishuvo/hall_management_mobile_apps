//constant key


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duetstahall/data/model/response/language_model.dart';
final CollectionReference adminCollection = FirebaseFirestore.instance.collection('admin');
final CollectionReference userCollection = FirebaseFirestore.instance.collection('Student');
final CollectionReference mealStudentCollection = FirebaseFirestore.instance.collection('Meal-Student');
final CollectionReference mealAdminCollection = FirebaseFirestore.instance.collection('Meal-Admin');
final CollectionReference fingerCollectionToday = FirebaseFirestore.instance.collection('Finger_Data_Todays');
final CollectionReference rfCollectionToday = FirebaseFirestore.instance.collection('RF_Data_Todays');
final CollectionReference fingerCollectionTomorrow = FirebaseFirestore.instance.collection('Finger_Data_Tomorrow');
final CollectionReference rfCollectionTomorrow = FirebaseFirestore.instance.collection('RF_Data_Tomorrow');
final CollectionReference mealRateCollection = FirebaseFirestore.instance.collection('mealRate');

class AppConstant {
  // API BASE URL
  static const String baseUrl = 'https://evue.in/shuvo/api/';
  static const String imageBaseUrl = 'https://evue.in/shuvo/images/';
  static const String loginURI = 'login';
  static const String signUPURI = 'register';
  static const String logoutURI = 'logout';
  static const String setNewPasswordURI = 'resetPassword';
  static const String getRoomInfo = 'getAllRoomsByYear?roomNo=';
  static const String getStudentInfoByID = 'getUserByStudentID?studentID=';
  static const String updateUser = 'updateUser';
  static const String searchStudent = 'searchStudent?query=';
  static const String deleteStudentsRoom = 'deleteStudentsRoom?id=';
  static const String getConfig = 'getConfig';
  static const String updateMealRate = 'updateMealRate';
  static const String updateGuestMealRate = 'updateGuestMealRate';
  static const String changeGuestMealAddedStatus = 'chanegGuestMealAddedStatus';
  static const String updateOfflineTakaCollectTime = 'updateOfflineTakaCollectTime';
  static const String getAllMealByStudentID = 'getAllMealByStudentID?studentID=';
  static const String addMeal = 'addMeal';
  static const String deleteMealByID = 'deleteMealByID?created_at=';
  static const String deleteGuestMealByID = 'deleteGuestMealByID?created_at=';
  static const String updateBalance = 'updateStudentBalance?balance=';


  static const String otpSendURI = '/accounts/otp/send/';
  static const String resetOtpSendURI = '/accounts/password/reset/';
  static const String otpVerifyURI = '/accounts/otp/verify/';
  static const String sendFriendRequestURI = '/accounts/friends/send-friend-request/';
  static const String cancelFriendRequestURI = '/accounts/friends/cancel-friend-request/';
  static const String acceptFriendRequestURI = '/accounts/friends/accept-friend-request/';
  static const String unfriendURI = '/accounts/friends/unfriend/';

  static const String sendFriendRequestListURI = '/accounts/friends/friend-request/list/?size=10&page=';
  static const String sendSuggestFriendListURI = '/accounts/friends/suggestions/?size=10&page=';
  static const String friendListsURI = '/accounts/friends/list/?size=10&page=';
  static const String follwersListsURI = '/accounts/followers/list/?size=10&page=';
  static const String profileURI = '/accounts/profile/';
  static const String uploadCoverImageURI = '/accounts/profile/update/cover-image/';
  static const String uploadProfileImageURI = '/accounts/profile/update/profile-image/';
  static const String editProfile = '/accounts/profile/update/';
  static const String newsFeedURI = '/posts/newsfeeds?page=';
  static const String watchListUri = '/watch/list/?size=10&page=';
  static const String postsUri = '/posts/';
  static const String postsGroupUri = '/posts/group/';
  static const String animalUri = '/animal/';
  static const String animalOwnerURI = '/animal/owner/';
  static const String groupUri = '/group/';
  static const String groupCategoryUri = '/group/category/';
  static const String groupJoinAllURI = '/group/group-join-list/';
  static const String groupSuggestAllURI = '/group/suggest/all/';
  static const String groupCreatorAllURI = '/group/creator/';
  static const String notificationListURI = '/notification/list/';
  static const String notificationUnreadCountURI = '/notification/count/unread/';
  static const String notificationReadCountURI = '/notification/counter/read/';
  static const String passwordUpdate = '/accounts/password/change/';
  static const String pageAuthorURI = '/page/author-page/';
  static const String pageSuggestedURI = '/page/suggested-page/';
  static const String pageLikeAllURI = '/page/like-page-list/';
  static const String pageCategoryURI = '/page/category/';
  static const String pageURI = '/page/';
  static const String postPageURI = '/posts/page/';
  static const String emailUpdate = '/settings/change-email/';
  static const String blocklist = '/settings/block/';
  static const String messageRoomList = '/message-room-list/';
  static const String chatRoomListUri = '/chat-message-list/';
  static const String chatMessageBetweenTwoUserURI = '/chat-message-between-two-user/';
  static const String messageRoomCreateList = '/message-room-create/';
  static const String getOtherSettingsValue = '/settings/other-settings/';
  static const String getNotificationSettingsValueUri = '/settings/notification/';
  static const String termsAndConditionUri = '/terms-condition/list/';
  static const String faqQuestionUri = '/settings/faq/';
  static const String latestVersionUri = '/latest-version/';
  static const String helpDiskURI = '/settings/help-desk/';


  // Shared Key
  static const String studentID = 'StudentID';
  static const String userPassword = 'user_password';
  static const String theme = 'theme';
  static const String userStatus = 'userStatus';
  static const String amount = 'ammount';
  static const String token = 'token';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String user = 'user';
  static const String userEmail2 = 'user_email2';
  static const String customerID = 'customerID';
  static const String userName = 'userName';
  static const String phoneNumber = 'phoneNumber';
  static const String cartList = 'cart_list';
  static const String currencyName = 'currencyName';

  static List<LanguageModel> languagesList = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'Bangla', countryCode: 'BD', languageCode: 'bn'),
  ];
}
