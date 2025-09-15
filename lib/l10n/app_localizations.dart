import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @set_radius.
  ///
  /// In en, this message translates to:
  /// **'Set Radius'**
  String get set_radius;

  /// No description provided for @edit_profile_info.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile Info'**
  String get edit_profile_info;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @support_and_feedback.
  ///
  /// In en, this message translates to:
  /// **'Support and Feedback'**
  String get support_and_feedback;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @neighborly.
  ///
  /// In en, this message translates to:
  /// **'Neighborly'**
  String get neighborly;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @your_current_radius.
  ///
  /// In en, this message translates to:
  /// **'Your current radius'**
  String get your_current_radius;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'KM.'**
  String get km;

  /// No description provided for @radius_point_1.
  ///
  /// In en, this message translates to:
  /// **'Zoom In to Your Zone: Set how close or far you want to connect! Keep it super local for nearby neighbors, or open up your radius to explore more communities.'**
  String get radius_point_1;

  /// No description provided for @radius_point_2.
  ///
  /// In en, this message translates to:
  /// **'Find What’s Happening Around You: Slide to discover cool spots, events, and stories tailored just for you.The closer you go, the more local the vibe.'**
  String get radius_point_2;

  /// No description provided for @radius_point_3.
  ///
  /// In en, this message translates to:
  /// **'Stay Local or Go Big: Tiny radius, cozy connections. Big radius, more possibilities! Adjust the slider and see how your neighborhood grows.'**
  String get radius_point_3;

  /// No description provided for @radius_changed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Radius changed successfully!'**
  String get radius_changed_successfully;

  /// No description provided for @activity_and_stats.
  ///
  /// In en, this message translates to:
  /// **'Activity and Stats'**
  String get activity_and_stats;

  /// No description provided for @karma_score.
  ///
  /// In en, this message translates to:
  /// **'Karma Score'**
  String get karma_score;

  /// No description provided for @karma.
  ///
  /// In en, this message translates to:
  /// **'Karma'**
  String get karma;

  /// No description provided for @karma_description.
  ///
  /// In en, this message translates to:
  /// **'Your Karma score reflects your engagement within the community. Share, help, and connect to build your score.'**
  String get karma_description;

  /// No description provided for @awards.
  ///
  /// In en, this message translates to:
  /// **'Awards'**
  String get awards;

  /// No description provided for @basic_information.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basic_information;

  /// No description provided for @profile_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_updated_successfully;

  /// No description provided for @edit_photo.
  ///
  /// In en, this message translates to:
  /// **'Edit photo'**
  String get edit_photo;

  /// No description provided for @uername_and_gender_cannot_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Username and gender cannot be empty'**
  String get uername_and_gender_cannot_be_empty;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email_id.
  ///
  /// In en, this message translates to:
  /// **'Email Id'**
  String get email_id;

  /// No description provided for @username_should_be_at_least_6_character_long.
  ///
  /// In en, this message translates to:
  /// **'Username should be at least 6 character long.'**
  String get username_should_be_at_least_6_character_long;

  /// No description provided for @username_cannot_contain_spaces.
  ///
  /// In en, this message translates to:
  /// **'Username cannot contain spaces.'**
  String get username_cannot_contain_spaces;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone_number;

  /// No description provided for @invalid_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Invalid Phone number.'**
  String get invalid_phone_number;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @city_updated_to.
  ///
  /// In en, this message translates to:
  /// **'City updated to'**
  String get city_updated_to;

  /// No description provided for @successfully.
  ///
  /// In en, this message translates to:
  /// **'Successfully'**
  String get successfully;

  /// No description provided for @neighborly_user.
  ///
  /// In en, this message translates to:
  /// **'Neighborly user'**
  String get neighborly_user;

  /// No description provided for @looks_like_this_profile_is_no_longer_with_us.
  ///
  /// In en, this message translates to:
  /// **'Boo! Looks like this profile is no longer with us.'**
  String get looks_like_this_profile_is_no_longer_with_us;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @no_posts_to_haunt_this_profile.
  ///
  /// In en, this message translates to:
  /// **'No posts to haunt this profile!'**
  String get no_posts_to_haunt_this_profile;

  /// No description provided for @comments_have_drifted_away.
  ///
  /// In en, this message translates to:
  /// **'Comments have drifted away!'**
  String get comments_have_drifted_away;

  /// No description provided for @write_your_feedback_here.
  ///
  /// In en, this message translates to:
  /// **'Write your feedback here'**
  String get write_your_feedback_here;

  /// No description provided for @your_feedback.
  ///
  /// In en, this message translates to:
  /// **'Your feedback'**
  String get your_feedback;

  /// No description provided for @feedback_submitted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully'**
  String get feedback_submitted_successfully;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @find_me.
  ///
  /// In en, this message translates to:
  /// **'Find Me'**
  String get find_me;

  /// No description provided for @you_will_automatically_join_the_community_group_when_it_is_created.
  ///
  /// In en, this message translates to:
  /// **'You will automatically join the community group when it is created.'**
  String get you_will_automatically_join_the_community_group_when_it_is_created;

  /// No description provided for @find_me_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Find me updated successfully'**
  String get find_me_updated_successfully;

  /// No description provided for @aaah_something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Aaah! Something went wrong'**
  String get aaah_something_went_wrong;

  /// No description provided for @please_check_your_connection_and_try_again.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection .\nPlease try starting it again'**
  String get please_check_your_connection_and_try_again;

  /// No description provided for @we_could_not_fetch_your_data_please_try_starting_it_again.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t fetch your data.\nPlease try starting it again'**
  String get we_could_not_fetch_your_data_please_try_starting_it_again;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get current_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirm_password;

  /// No description provided for @save_password.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get save_password;

  /// No description provided for @forgot_your_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password ?'**
  String get forgot_your_password;

  /// No description provided for @wrong_password_Try_again_or_click_forgot_password_to_reset_it.
  ///
  /// In en, this message translates to:
  /// **'Wrong password. Try again or click forgot password to reset it.'**
  String get wrong_password_Try_again_or_click_forgot_password_to_reset_it;

  /// No description provided for @new_password_should_be_atleast_6_character_long.
  ///
  /// In en, this message translates to:
  /// **'New password should be atleast 6 character long.'**
  String get new_password_should_be_atleast_6_character_long;

  /// No description provided for @password_should_be_atleast_6_character_long.
  ///
  /// In en, this message translates to:
  /// **'Password should be atleast 6 character long.'**
  String get password_should_be_atleast_6_character_long;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwords_do_not_match;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get no_internet_connection;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @share_this_profile.
  ///
  /// In en, this message translates to:
  /// **'Share this profile'**
  String get share_this_profile;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @no_comments.
  ///
  /// In en, this message translates to:
  /// **'No comments'**
  String get no_comments;

  /// No description provided for @that_is_an_opportunity_go_ahead_make_the_first_move.
  ///
  /// In en, this message translates to:
  /// **'That’s an opportunity! Go ahead, make the first move.'**
  String get that_is_an_opportunity_go_ahead_make_the_first_move;

  /// No description provided for @start_the_discussion.
  ///
  /// In en, this message translates to:
  /// **'Start the Discussion'**
  String get start_the_discussion;

  /// No description provided for @oops_something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'oops something went wrong'**
  String get oops_something_went_wrong;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get no_data;

  /// No description provided for @enter_your_email_and_we_will_send_you_a_code_to_reset_your_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we’ll send you a code to reset your password.'**
  String
      get enter_your_email_and_we_will_send_you_a_code_to_reset_your_password;

  /// No description provided for @enter_email_address.
  ///
  /// In en, this message translates to:
  /// **'Enter Email Address'**
  String get enter_email_address;

  /// No description provided for @welcome_to_neighborly.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Neighborly'**
  String get welcome_to_neighborly;

  /// No description provided for @connect_with_your_neighbors_share_stories_and_stay_informed_with_neighborly_your_hyper_local_community_app_designed_to_bring_people_together.
  ///
  /// In en, this message translates to:
  /// **'Connect with your neighbors, share stories, and stay informed with Neighborly, your hyper-local community app designed to bring people together.'**
  String
      get connect_with_your_neighbors_share_stories_and_stay_informed_with_neighborly_your_hyper_local_community_app_designed_to_bring_people_together;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcome_back;

  /// No description provided for @continue_with_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continue_with_google;

  /// No description provided for @continue_with_email.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get continue_with_email;

  /// No description provided for @enter_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enter_phone_number;

  /// No description provided for @please_enter_a_valid_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get please_enter_a_valid_phone_number;

  /// No description provided for @continues.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continues;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'By clicking the above button and creating an account, you have read and accepted the Terms of Service and acknowledged our Privacy Policy '**
  String get privacy_policy;

  /// No description provided for @terms_of_service.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service.'**
  String get terms_of_service;

  /// No description provided for @join_neighborly_with_your_email.
  ///
  /// In en, this message translates to:
  /// **'Join Neighborly with your email.'**
  String get join_neighborly_with_your_email;

  /// No description provided for @please_enter_a_valid_email_address.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get please_enter_a_valid_email_address;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @phone_number_already_exists_please_login.
  ///
  /// In en, this message translates to:
  /// **'Phone Number already exists. Please login.'**
  String get phone_number_already_exists_please_login;

  /// No description provided for @email_already_exists_please_login.
  ///
  /// In en, this message translates to:
  /// **'Email already exists. Please login.'**
  String get email_already_exists_please_login;

  /// No description provided for @title_required.
  ///
  /// In en, this message translates to:
  /// **'Title (Required)'**
  String get title_required;

  /// No description provided for @whats_on_your_mind.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind ?'**
  String get whats_on_your_mind;

  /// No description provided for @add_a_photo.
  ///
  /// In en, this message translates to:
  /// **'Add a Photo'**
  String get add_a_photo;

  /// No description provided for @take_a_picture.
  ///
  /// In en, this message translates to:
  /// **'Take a Picture'**
  String get take_a_picture;

  /// No description provided for @add_a_video.
  ///
  /// In en, this message translates to:
  /// **'Add a Video'**
  String get add_a_video;

  /// No description provided for @create_a_poll.
  ///
  /// In en, this message translates to:
  /// **'Create a Poll'**
  String get create_a_poll;

  /// No description provided for @no_new_notifications.
  ///
  /// In en, this message translates to:
  /// **'No New Notifications'**
  String get no_new_notifications;

  /// No description provided for @there_are_currently_no_notifications_to_display.
  ///
  /// In en, this message translates to:
  /// **'There are currently no notifications to display.'**
  String get there_are_currently_no_notifications_to_display;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @location_permissions_are_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied.'**
  String get location_permissions_are_denied;

  /// No description provided for @location_permissions_are_permanently_denied_we_cannot_request_permissions.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied, we cannot request permissions.'**
  String
      get location_permissions_are_permanently_denied_we_cannot_request_permissions;

  /// No description provided for @no_location_access.
  ///
  /// In en, this message translates to:
  /// **'No Location Access'**
  String get no_location_access;

  /// No description provided for @device_location_is_turned_off_and_if_you_donot_turn_on_your_location_then_last_location_will_be_used.
  ///
  /// In en, this message translates to:
  /// **'Device location is turned off, and if you don\'t turn on your location then last location will be used.'**
  String
      get device_location_is_turned_off_and_if_you_donot_turn_on_your_location_then_last_location_will_be_used;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @this_video_is_too_large.
  ///
  /// In en, this message translates to:
  /// **'This video is too large'**
  String get this_video_is_too_large;

  /// No description provided for @you_can_select_up_to_5_images.
  ///
  /// In en, this message translates to:
  /// **'You can select up to 5 images.'**
  String get you_can_select_up_to_5_images;

  /// No description provided for @sorry_you_are_banned_please_try_it_after_some_time.
  ///
  /// In en, this message translates to:
  /// **'Sorry,You are banned.\nPlease try it after some time'**
  String get sorry_you_are_banned_please_try_it_after_some_time;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get go_back;

  /// No description provided for @post_created.
  ///
  /// In en, this message translates to:
  /// **'Post Created'**
  String get post_created;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @poll_created.
  ///
  /// In en, this message translates to:
  /// **'Poll Created'**
  String get poll_created;

  /// No description provided for @write_your_question_here.
  ///
  /// In en, this message translates to:
  /// **'Write your question here...'**
  String get write_your_question_here;

  /// No description provided for @add_option.
  ///
  /// In en, this message translates to:
  /// **'Add Option'**
  String get add_option;

  /// No description provided for @allow_multiple_votes.
  ///
  /// In en, this message translates to:
  /// **'Allow multiple votes'**
  String get allow_multiple_votes;

  /// No description provided for @option.
  ///
  /// In en, this message translates to:
  /// **'Option'**
  String get option;

  /// No description provided for @pick_video_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Pick video from gallery'**
  String get pick_video_from_gallery;

  /// No description provided for @record_a_video.
  ///
  /// In en, this message translates to:
  /// **'Record a video'**
  String get record_a_video;

  /// No description provided for @we_couldnot_fetch_your_notification_Please_try_starting_it_again.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t fetch your notification.\nPlease try starting it again'**
  String get we_couldnot_fetch_your_notification_Please_try_starting_it_again;

  /// No description provided for @enter_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enter_verification_code;

  /// No description provided for @we_sent_a_verification_code_to_your_phone.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to your phone'**
  String get we_sent_a_verification_code_to_your_phone;

  /// No description provided for @we_sent_a_verification_code_to_your_email.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to your email'**
  String get we_sent_a_verification_code_to_your_email;

  /// No description provided for @enter_otp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enter_otp;

  /// No description provided for @the_otp_entered_is_incorrect_please_try_again.
  ///
  /// In en, this message translates to:
  /// **'The OTP entered is incorrect. Please try again.'**
  String get the_otp_entered_is_incorrect_please_try_again;

  /// No description provided for @otp_has_expired.
  ///
  /// In en, this message translates to:
  /// **'OTP has expired'**
  String get otp_has_expired;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resend_code;

  /// No description provided for @user_not_found_please_sign_up.
  ///
  /// In en, this message translates to:
  /// **'User not found, please sign Up'**
  String get user_not_found_please_sign_up;

  /// No description provided for @verify_your_username.
  ///
  /// In en, this message translates to:
  /// **'Verify your username.'**
  String get verify_your_username;

  /// No description provided for @enter_your_username.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enter_your_username;

  /// No description provided for @wrong_username.
  ///
  /// In en, this message translates to:
  /// **'Wrong username'**
  String get wrong_username;

  /// No description provided for @leaving_so_soon_confirm_if_you_want_to_logout.
  ///
  /// In en, this message translates to:
  /// **'Leaving so soon? Confirm if you want to logout.'**
  String get leaving_so_soon_confirm_if_you_want_to_logout;

  /// No description provided for @are_you_sure_you_want_to_delete_your_account_this_action_is_irreversible.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action is irreversible.'**
  String
      get are_you_sure_you_want_to_delete_your_account_this_action_is_irreversible;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @award_not_available_you_run_out_of_this_award.
  ///
  /// In en, this message translates to:
  /// **'Award not available. You run out of this award.'**
  String get award_not_available_you_run_out_of_this_award;

  /// No description provided for @award_given_successfully.
  ///
  /// In en, this message translates to:
  /// **'Award given successfully'**
  String get award_given_successfully;

  /// No description provided for @award_this_post.
  ///
  /// In en, this message translates to:
  /// **'Award this post'**
  String get award_this_post;

  /// No description provided for @commented_on_this.
  ///
  /// In en, this message translates to:
  /// **'commented on this'**
  String get commented_on_this;

  /// No description provided for @comment_deleted.
  ///
  /// In en, this message translates to:
  /// **'Comment Deleted'**
  String get comment_deleted;

  /// No description provided for @post_deleted.
  ///
  /// In en, this message translates to:
  /// **'Post Deleted'**
  String get post_deleted;

  /// No description provided for @give_award_on_your_commente.
  ///
  /// In en, this message translates to:
  /// **'Give award on your commente'**
  String get give_award_on_your_commente;

  /// No description provided for @time_to_be_the_hero_this_wall_needs_start_the.
  ///
  /// In en, this message translates to:
  /// **'Time to be the hero this wall needs, start the \nConversation'**
  String get time_to_be_the_hero_this_wall_needs_start_the;

  /// No description provided for @create_a_post.
  ///
  /// In en, this message translates to:
  /// **'Create a Post'**
  String get create_a_post;

  /// No description provided for @one_last_thing_before_we_get_started.
  ///
  /// In en, this message translates to:
  /// **'One last thing before we get started'**
  String get one_last_thing_before_we_get_started;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get date_of_birth;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @date_of_birth_saved_successfully.
  ///
  /// In en, this message translates to:
  /// **'Date of birth saved successfully'**
  String get date_of_birth_saved_successfully;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @poll.
  ///
  /// In en, this message translates to:
  /// **'Poll'**
  String get poll;

  /// No description provided for @no_comments_yet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get no_comments_yet;

  /// No description provided for @post_not_found.
  ///
  /// In en, this message translates to:
  /// **'Post not found'**
  String get post_not_found;

  /// No description provided for @delete_comment.
  ///
  /// In en, this message translates to:
  /// **'Delete Comment'**
  String get delete_comment;

  /// No description provided for @delete_post.
  ///
  /// In en, this message translates to:
  /// **'Delete Post'**
  String get delete_post;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @buy_awards.
  ///
  /// In en, this message translates to:
  /// **'Buy awards'**
  String get buy_awards;

  /// No description provided for @add_some_awards_in_your_bag.
  ///
  /// In en, this message translates to:
  /// **'Add some awards in your bag'**
  String get add_some_awards_in_your_bag;

  /// No description provided for @random_awards.
  ///
  /// In en, this message translates to:
  /// **'Random Awards'**
  String get random_awards;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @payment_successful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get payment_successful;

  /// No description provided for @payment_failed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get payment_failed;

  /// No description provided for @bag.
  ///
  /// In en, this message translates to:
  /// **'Bag'**
  String get bag;

  /// No description provided for @buy_now.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buy_now;

  /// No description provided for @total_price.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get total_price;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @payment_verified.
  ///
  /// In en, this message translates to:
  /// **'Payment Verified'**
  String get payment_verified;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @view_replies.
  ///
  /// In en, this message translates to:
  /// **'View replies'**
  String get view_replies;

  /// No description provided for @hide_replies.
  ///
  /// In en, this message translates to:
  /// **'Hide replies'**
  String get hide_replies;

  /// No description provided for @no_reply_yet.
  ///
  /// In en, this message translates to:
  /// **'No reply yet'**
  String get no_reply_yet;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @poll_deleted.
  ///
  /// In en, this message translates to:
  /// **'Poll Deleted'**
  String get poll_deleted;

  /// No description provided for @delete_poll.
  ///
  /// In en, this message translates to:
  /// **'Delete Poll'**
  String get delete_poll;

  /// No description provided for @inappropriate_content.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate content'**
  String get inappropriate_content;

  /// No description provided for @spam.
  ///
  /// In en, this message translates to:
  /// **'Spam'**
  String get spam;

  /// No description provided for @harassment_or_hate_speech.
  ///
  /// In en, this message translates to:
  /// **'Harassment or hate speech'**
  String get harassment_or_hate_speech;

  /// No description provided for @violence_or_dangerous_organizations.
  ///
  /// In en, this message translates to:
  /// **'Violence or dangerous organizations'**
  String get violence_or_dangerous_organizations;

  /// No description provided for @intellectual_property_violation.
  ///
  /// In en, this message translates to:
  /// **'Intellectual property violation'**
  String get intellectual_property_violation;

  /// No description provided for @reason_to_report.
  ///
  /// In en, this message translates to:
  /// **'Reason to Report'**
  String get reason_to_report;

  /// No description provided for @thanks_for_letting_us_know.
  ///
  /// In en, this message translates to:
  /// **'Thanks for letting us know'**
  String get thanks_for_letting_us_know;

  /// No description provided for @we_appreciate_your_help_in_keeping_our_community_safe_and_respectful_our_team_will_review_the_content_shortly.
  ///
  /// In en, this message translates to:
  /// **'We appreciate your help in keeping our community safe and respectful. Our team will review the content shortly.'**
  String
      get we_appreciate_your_help_in_keeping_our_community_safe_and_respectful_our_team_will_review_the_content_shortly;

  /// No description provided for @select_a_description_to_be_saved.
  ///
  /// In en, this message translates to:
  /// **'Select a description to be saved'**
  String get select_a_description_to_be_saved;

  /// No description provided for @are_you_sure_you_whant_to_Unblock_this_user.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you whant to Unblock this user'**
  String get are_you_sure_you_whant_to_Unblock_this_user;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @blocked_User.
  ///
  /// In en, this message translates to:
  /// **'Blocked User'**
  String get blocked_User;

  /// No description provided for @no_Members.
  ///
  /// In en, this message translates to:
  /// **'No Members'**
  String get no_Members;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @describe_your_community.
  ///
  /// In en, this message translates to:
  /// **'Describe your community'**
  String get describe_your_community;

  /// No description provided for @community_display_name.
  ///
  /// In en, this message translates to:
  /// **'Community display name'**
  String get community_display_name;

  /// No description provided for @select_a_display_name_to_be_saved.
  ///
  /// In en, this message translates to:
  /// **'Select a display name to be saved'**
  String get select_a_display_name_to_be_saved;

  /// No description provided for @your_community_name.
  ///
  /// In en, this message translates to:
  /// **'your community name'**
  String get your_community_name;

  /// No description provided for @if_you_leave_the_icon_will_not_be_saved_Are_you_sure.
  ///
  /// In en, this message translates to:
  /// **'if you leave, the icon will not be saved. Are you sure?'**
  String get if_you_leave_the_icon_will_not_be_saved_Are_you_sure;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @community_Icon.
  ///
  /// In en, this message translates to:
  /// **'Community Icon'**
  String get community_Icon;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @select_a_image_to_be_saved.
  ///
  /// In en, this message translates to:
  /// **'Select a image to be saved'**
  String get select_a_image_to_be_saved;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @select_a_location_to_be_saved.
  ///
  /// In en, this message translates to:
  /// **'Select a location to be saved'**
  String get select_a_location_to_be_saved;

  /// No description provided for @type_to_search_location.
  ///
  /// In en, this message translates to:
  /// **'Type to search location'**
  String get type_to_search_location;

  /// No description provided for @are_you_sure_you_make_this_person_Admin.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you make this person Admin?'**
  String get are_you_sure_you_make_this_person_Admin;

  /// No description provided for @admin_made.
  ///
  /// In en, this message translates to:
  /// **'Admin made'**
  String get admin_made;

  /// No description provided for @are_you_sure_you_want_to_remove_this_person_from_Admin_post.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this person from Admin post?'**
  String get are_you_sure_you_want_to_remove_this_person_from_Admin_post;

  /// No description provided for @admin_remove.
  ///
  /// In en, this message translates to:
  /// **'Admin remove'**
  String get admin_remove;

  /// No description provided for @are_you_sure_you_want_to_remove_this_person_from_community.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this person from community?'**
  String get are_you_sure_you_want_to_remove_this_person_from_community;

  /// No description provided for @user_removed.
  ///
  /// In en, this message translates to:
  /// **'User removed'**
  String get user_removed;

  /// No description provided for @are_you_sure_you_want_to_leave_this_community.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this community?'**
  String get are_you_sure_you_want_to_leave_this_community;

  /// No description provided for @group_leaved.
  ///
  /// In en, this message translates to:
  /// **'Group leaved'**
  String get group_leaved;

  /// No description provided for @are_you_sure_you_want_to_block_this_user.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block this user?'**
  String get are_you_sure_you_want_to_block_this_user;

  /// No description provided for @remove_Admin.
  ///
  /// In en, this message translates to:
  /// **'Remove Admin'**
  String get remove_Admin;

  /// No description provided for @make_Admin.
  ///
  /// In en, this message translates to:
  /// **'Make Admin'**
  String get make_Admin;

  /// No description provided for @remove_from_community.
  ///
  /// In en, this message translates to:
  /// **'Remove from community'**
  String get remove_from_community;

  /// No description provided for @leave_community.
  ///
  /// In en, this message translates to:
  /// **'Leave community'**
  String get leave_community;

  /// No description provided for @block_user.
  ///
  /// In en, this message translates to:
  /// **'Block user'**
  String get block_user;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @radius.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get radius;

  /// No description provided for @select_a_radius_to_be_saved.
  ///
  /// In en, this message translates to:
  /// **'Select a radius to be saved'**
  String get select_a_radius_to_be_saved;

  /// No description provided for @miles.
  ///
  /// In en, this message translates to:
  /// **'miles'**
  String get miles;

  /// No description provided for @you_can_use_this_slider_to_increase_and_decrease_the_radius_of_our_community.
  ///
  /// In en, this message translates to:
  /// **'You can use this slider to increase and decrease the radius of your community'**
  String
      get you_can_use_this_slider_to_increase_and_decrease_the_radius_of_our_community;

  /// No description provided for @delete_Group.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get delete_Group;

  /// No description provided for @are_you_sure_you_want_to_delete_this_group_This_action_cannot_be_undone.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this group? This action cannot be undone.'**
  String
      get are_you_sure_you_want_to_delete_this_group_This_action_cannot_be_undone;

  /// No description provided for @group_deleted.
  ///
  /// In en, this message translates to:
  /// **'Group deleted'**
  String get group_deleted;

  /// No description provided for @group_settings.
  ///
  /// In en, this message translates to:
  /// **'Group settings'**
  String get group_settings;

  /// No description provided for @community_name.
  ///
  /// In en, this message translates to:
  /// **'Community name'**
  String get community_name;

  /// No description provided for @community_Type.
  ///
  /// In en, this message translates to:
  /// **'Community Type'**
  String get community_Type;

  /// No description provided for @group_unmuted.
  ///
  /// In en, this message translates to:
  /// **'Group unmuted'**
  String get group_unmuted;

  /// No description provided for @group_muted.
  ///
  /// In en, this message translates to:
  /// **'Group muted!'**
  String get group_muted;

  /// No description provided for @unmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get unmute;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @member_list.
  ///
  /// In en, this message translates to:
  /// **'Member list'**
  String get member_list;

  /// No description provided for @blocked_users.
  ///
  /// In en, this message translates to:
  /// **'Blocked users'**
  String get blocked_users;

  /// No description provided for @delete_community.
  ///
  /// In en, this message translates to:
  /// **'Delete community'**
  String get delete_community;

  /// No description provided for @anyone_can_join_see_posts_and_participate_in_discussions.
  ///
  /// In en, this message translates to:
  /// **'Anyone can join, see posts, and participate in discussions.'**
  String get anyone_can_join_see_posts_and_participate_in_discussions;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @only_invited_members_can_join_view_posts_and_engage_in_conversations.
  ///
  /// In en, this message translates to:
  /// **'only invited members can join, view posts, and engage in conversations'**
  String
      get only_invited_members_can_join_view_posts_and_engage_in_conversations;

  /// No description provided for @are_you_sure_you_want_leave_without_save.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want leave without save?'**
  String get are_you_sure_you_want_leave_without_save;

  /// No description provided for @name_is_mandatory.
  ///
  /// In en, this message translates to:
  /// **'Name is mandatory'**
  String get name_is_mandatory;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @choose_your_group_type.
  ///
  /// In en, this message translates to:
  /// **'Choose your group type'**
  String get choose_your_group_type;

  /// No description provided for @community_Description.
  ///
  /// In en, this message translates to:
  /// **'Community Description'**
  String get community_Description;

  /// No description provided for @community_Radius.
  ///
  /// In en, this message translates to:
  /// **'Community Radius'**
  String get community_Radius;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @we_appreciate_your_help_in_keeping_our_community_safe_and_respectful_Our_team_will_review_the_content_shortly.
  ///
  /// In en, this message translates to:
  /// **'We appreciate your help in keeping our community safe and respectful. Our team will review the content shortly.'**
  String
      get we_appreciate_your_help_in_keeping_our_community_safe_and_respectful_Our_team_will_review_the_content_shortly;

  /// No description provided for @reason_to_Report.
  ///
  /// In en, this message translates to:
  /// **'Reason to Report'**
  String get reason_to_Report;

  /// No description provided for @leave_Community.
  ///
  /// In en, this message translates to:
  /// **'Leave Community?'**
  String get leave_Community;

  /// No description provided for @group_leaved_successfully.
  ///
  /// In en, this message translates to:
  /// **'Group leaved successfully'**
  String get group_leaved_successfully;

  /// No description provided for @join_Community.
  ///
  /// In en, this message translates to:
  /// **'Join Community?'**
  String get join_Community;

  /// No description provided for @are_you_sure_you_want_to_join_this_community.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to join this community?'**
  String get are_you_sure_you_want_to_join_this_community;

  /// No description provided for @group_joined_successfully.
  ///
  /// In en, this message translates to:
  /// **'Group joined successfully'**
  String get group_joined_successfully;

  /// No description provided for @hey_check_this_community.
  ///
  /// In en, this message translates to:
  /// **'Hey, check this community:'**
  String get hey_check_this_community;

  /// No description provided for @look_this_event.
  ///
  /// In en, this message translates to:
  /// **'Look this event'**
  String get look_this_event;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get error;

  /// No description provided for @nearby_Groups.
  ///
  /// In en, this message translates to:
  /// **'Nearby Groups'**
  String get nearby_Groups;

  /// No description provided for @my_Groups.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get my_Groups;

  /// No description provided for @no_Community_found.
  ///
  /// In en, this message translates to:
  /// **'No Community found'**
  String get no_Community_found;

  /// No description provided for @trending_Communities.
  ///
  /// In en, this message translates to:
  /// **'Trending Communities'**
  String get trending_Communities;

  /// No description provided for @vazio.
  ///
  /// In en, this message translates to:
  /// **'vazio'**
  String get vazio;

  /// No description provided for @communities.
  ///
  /// In en, this message translates to:
  /// **'Communities'**
  String get communities;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get people;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @no_Community_Groups_Yet.
  ///
  /// In en, this message translates to:
  /// **'No Community Groups Yet'**
  String get no_Community_Groups_Yet;

  /// No description provided for @be_the_first_to_create_a_group_and_start_connecting.
  ///
  /// In en, this message translates to:
  /// **'Be the first to create a group and start connecting!'**
  String get be_the_first_to_create_a_group_and_start_connecting;

  /// No description provided for @start_a_Community.
  ///
  /// In en, this message translates to:
  /// **'Start a Community'**
  String get start_a_Community;

  /// No description provided for @no_results_for.
  ///
  /// In en, this message translates to:
  /// **'No results for'**
  String get no_results_for;

  /// No description provided for @we_couldnt_find_any_matches_Try_adjusting_your_search_or_using_different_keywords.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any matches. Try adjusting your search or using different keywords'**
  String
      get we_couldnt_find_any_matches_Try_adjusting_your_search_or_using_different_keywords;

  /// No description provided for @group_Description.
  ///
  /// In en, this message translates to:
  /// **'Group Description'**
  String get group_Description;

  /// No description provided for @see_more.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get see_more;

  /// No description provided for @see_less.
  ///
  /// In en, this message translates to:
  /// **'See less'**
  String get see_less;

  /// No description provided for @members_list.
  ///
  /// In en, this message translates to:
  /// **'Members list'**
  String get members_list;

  /// No description provided for @view_All_Members.
  ///
  /// In en, this message translates to:
  /// **'View All Members'**
  String get view_All_Members;

  /// No description provided for @no_posts_so_far.
  ///
  /// In en, this message translates to:
  /// **'No posts so far'**
  String get no_posts_so_far;

  /// No description provided for @type_something_here.
  ///
  /// In en, this message translates to:
  /// **'type something here'**
  String get type_something_here;

  /// No description provided for @image_Cover_Avatar.
  ///
  /// In en, this message translates to:
  /// **'Image Cover/Avatar'**
  String get image_Cover_Avatar;

  /// No description provided for @type_to_search.
  ///
  /// In en, this message translates to:
  /// **'type_to_search'**
  String get type_to_search;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @create_community.
  ///
  /// In en, this message translates to:
  /// **'Create community'**
  String get create_community;

  /// No description provided for @upload_image.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get upload_image;

  /// No description provided for @create_description.
  ///
  /// In en, this message translates to:
  /// **'create description'**
  String get create_description;

  /// No description provided for @change_location.
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get change_location;

  /// No description provided for @refer_and_earn.
  ///
  /// In en, this message translates to:
  /// **'Refer and earn'**
  String get refer_and_earn;

  /// No description provided for @your_interests.
  ///
  /// In en, this message translates to:
  /// **'Your interests'**
  String get your_interests;

  /// No description provided for @rewards_and_referral_details.
  ///
  /// In en, this message translates to:
  /// **'Rewards and referral details'**
  String get rewards_and_referral_details;

  /// No description provided for @invite_friends.
  ///
  /// In en, this message translates to:
  /// **'Invite friends'**
  String get invite_friends;

  /// No description provided for @copy_your_code.
  ///
  /// In en, this message translates to:
  /// **'Copy your code'**
  String get copy_your_code;

  /// No description provided for @share_with_friends.
  ///
  /// In en, this message translates to:
  /// **'Share it with your friends'**
  String get share_with_friends;

  /// No description provided for @your_personal_code.
  ///
  /// In en, this message translates to:
  /// **'Your personal code'**
  String get your_personal_code;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @total_rewards.
  ///
  /// In en, this message translates to:
  /// **'Total rewards'**
  String get total_rewards;

  /// No description provided for @withdrawable_amount.
  ///
  /// In en, this message translates to:
  /// **'Withdrawable amount'**
  String get withdrawable_amount;

  /// No description provided for @users_you_referred.
  ///
  /// In en, this message translates to:
  /// **'Users you referred'**
  String get users_you_referred;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @withdraw_reward_amount.
  ///
  /// In en, this message translates to:
  /// **'Withdraw your reward amount'**
  String get withdraw_reward_amount;

  /// No description provided for @withdrawal_request_history.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request history'**
  String get withdrawal_request_history;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @no_reward_history.
  ///
  /// In en, this message translates to:
  /// **'No reward history available'**
  String get no_reward_history;

  /// No description provided for @reward_history.
  ///
  /// In en, this message translates to:
  /// **'Reward history'**
  String get reward_history;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @connect_with_neighbors.
  ///
  /// In en, this message translates to:
  /// **'Connect with neighbors'**
  String get connect_with_neighbors;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
