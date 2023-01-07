//constant key


import 'package:duetstahall/data/model/response/language_model.dart';

class AppConstant {
  // API BASE URL
  static const agoraApiKey = "52aa6d82f3f14aa3bd36b7a0fb6648f4";
  static const String baseUrl = 'https://testing.feedback-social.com';
  static const String baseUrlTesting = 'https://testing.feedback-social.com';
  static const String baseUrlLive = 'https://feedback-social.com';

  static const String socketBaseUrl = 'wss://testing.feedback-social.com/';
  static const String socketBaseUrlTesting = 'wss://testing.feedback-social.com/';
  static const String socketBaseUrlLive = 'wss://feedback-social.com/';

  static const String oldBaseUrl = 'https://als-social.com';

  static const String loginURI = '/accounts/signin/';
  static const String signupURI = '/accounts/signup/';
  static const String otpSendURI = '/accounts/otp/send/';
  static const String resetOtpSendURI = '/accounts/password/reset/';
  static const String setNewPasswordURI = '/accounts/password/reset/confirm/';
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
  static const String theme = 'theme';
  static const String light = 'light';
  static const String dark = 'dark';
  static const String token = 'token';
  static const String offlineChatList = 'offlineChatList';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String selectLanguageIndex = 'select_language_index';
  static const String userID = 'userID';
  static const String userProfileImage = 'userprofile_image';
  static const String userName = 'username';
  static const String usercode = 'usercode';
  static const String userEmail = 'useremail';
  static const String postTypePage = 'page';
  static const String postTypeGroup = 'group';
  static const String postTypeTimeline = 'timeline';
  static const String chats = 'chats';
  static const Duration durationAnimation = Duration(seconds: 1);

  static List<LanguageModel> languagesList = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'Bangla', countryCode: 'BD', languageCode: 'bn'),
  ];
}
