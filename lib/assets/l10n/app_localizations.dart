import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// not account
  ///
  /// In en, this message translates to:
  /// **'I do not have an account.'**
  String get account;

  /// I have an account
  ///
  /// In en, this message translates to:
  /// **'I already have an account.'**
  String get account_accept;

  /// details
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get email_enter;

  /// enter_full_name
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enter_full_name;

  /// enter_password_confirm
  ///
  /// In en, this message translates to:
  /// **'Enter your password to confirm'**
  String get enter_password_confirm;

  /// forget password
  ///
  /// In en, this message translates to:
  /// **'I forgot my password.'**
  String get forget;

  /// recover
  ///
  /// In en, this message translates to:
  /// **'Recover'**
  String get recover;

  /// full_name
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get full_name;

  /// Login
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get log_in;

  /// map
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// my_plants
  ///
  /// In en, this message translates to:
  /// **'My plants'**
  String get my_plants;

  /// name_alert
  ///
  /// In en, this message translates to:
  /// **'The name will be used to give credit for the photos uploaded.'**
  String get name_alert;

  /// no_elements
  ///
  /// In en, this message translates to:
  /// **'There are no items to display'**
  String get no_elements;

  /// Obligacion
  ///
  /// In en, this message translates to:
  /// **'Obligatory field'**
  String get obligatory_camp;

  /// password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// password_confirm
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get password_confirm;

  /// password
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get password_enter;

  /// password_match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get password_match;

  /// plant_register
  ///
  /// In en, this message translates to:
  /// **'Register Plant'**
  String get plant_register;

  /// Text
  ///
  /// In en, this message translates to:
  /// **'Fruit Image'**
  String get plant_register_fruit_image;

  /// Text
  ///
  /// In en, this message translates to:
  /// **'Full Image'**
  String get plant_register_full_image;

  /// Text
  ///
  /// In en, this message translates to:
  /// **'Branches Image'**
  String get plant_register_image_branches;

  /// Text
  ///
  /// In en, this message translates to:
  /// **'Flower Image'**
  String get plant_register_image_flower;

  /// Text
  ///
  /// In en, this message translates to:
  /// **'Sheet Image'**
  String get plant_register_sheet_image;

  /// Text
  ///
  /// In en, this message translates to:
  /// **'Stem Image'**
  String get plant_register_trunk_image;

  /// plants
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get plants;

  /// polices_warning
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms and conditions'**
  String get polices_warning;

  /// recover_password
  ///
  /// In en, this message translates to:
  /// **'Recover password'**
  String get recover_password;

  /// register
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// search
  ///
  /// In en, this message translates to:
  /// **'Search species...'**
  String get search;

  /// terms
  ///
  /// In en, this message translates to:
  /// **'I accept the policies and agreements.'**
  String get terms;

  /// terms_conditions
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get terms_conditions;

  /// Text Buttom
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get text_buttom_accept;

  /// Text Buttom
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get text_buttom_continue;

  /// Text Buttom
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get text_buttom_denied;

  /// Text Buttom
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get text_buttom_next;

  /// Text Buttom
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get text_buttom_send;

  /// Text
  ///
  /// In en, this message translates to:
  /// **'Join Planta! with our mobile app and contribute to plant conservation while exploring cities and countryside!'**
  String get text_onboarding_first;

  /// Text
  ///
  /// In en, this message translates to:
  /// **'Join us today and start exploring, learning and contributing to the conservation of the natural environment!'**
  String get text_onboarding_second;

  /// Text
  ///
  /// In en, this message translates to:
  /// **'Record the plants you find during your walks.'**
  String get text_onboarding_three_00;

  /// Text
  ///
  /// In en, this message translates to:
  /// **'Contribute to research and conservation by collecting data on species distribution.'**
  String get text_onboarding_three_01;

  /// Text
  ///
  /// In en, this message translates to:
  /// **'Learn about local plants and discover new species with the help of our community of users.'**
  String get text_onboarding_three_02;

  /// Title
  ///
  /// In en, this message translates to:
  /// **'Become a member of Planta! Tracker'**
  String get title_onboarding_second;

  /// Title
  ///
  /// In en, this message translates to:
  /// **'With Planta! Tracker, you can'**
  String get title_onboarding_three;

  /// user_profile
  ///
  /// In en, this message translates to:
  /// **'User profile'**
  String get user_profile;

  /// warning_exit
  ///
  /// In en, this message translates to:
  /// **'Are you sure to go out?'**
  String get warning_exit;

  /// Languages Change
  ///
  /// In en, this message translates to:
  /// **'Change languages:'**
  String get select_languages;

  /// Save changes
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get text_buttom_save;

  /// Messages to change name
  ///
  /// In en, this message translates to:
  /// **'Are you sure about changing the name?'**
  String get message_change_name;

  /// Messages to change password
  ///
  /// In en, this message translates to:
  /// **'Are you sure to change your password?'**
  String get message_change_password;

  /// Verifiying credentials
  ///
  /// In en, this message translates to:
  /// **'Incorrect credentials'**
  String get verify_credentials;

  /// Without connection
  ///
  /// In en, this message translates to:
  /// **'Without connection'**
  String get no_internet;

  /// Match password
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get match_password;

  /// Notes
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get note;

  /// Name plant
  ///
  /// In en, this message translates to:
  /// **'Pending determination'**
  String get name_plant;

  /// Comments
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// Address
  ///
  /// In en, this message translates to:
  /// **'The address was not registered'**
  String get address;

  /// take_photo_details
  ///
  /// In en, this message translates to:
  /// **'Picture taken by:'**
  String get take_photo_details;

  /// no_notes
  ///
  /// In en, this message translates to:
  /// **'No notes found'**
  String get no_notes;

  /// add_comments
  ///
  /// In en, this message translates to:
  /// **'Add comment'**
  String get add_comments;

  /// write_comments
  ///
  /// In en, this message translates to:
  /// **'Write your comment here...'**
  String get write_comments;

  /// message_add_comments
  ///
  /// In en, this message translates to:
  /// **'Are you sure to submit your comment?'**
  String get message_add_comments;

  /// publish
  ///
  /// In en, this message translates to:
  /// **'Successfully published'**
  String get publish;

  /// publish_repetitive
  ///
  /// In en, this message translates to:
  /// **'Repeat Post'**
  String get publish_repetitive;

  /// message_delete_plant
  ///
  /// In en, this message translates to:
  /// **'Are you sure about removing the plant?'**
  String get message_delete_plant;

  /// message_edit_plant
  ///
  /// In en, this message translates to:
  /// **'Are you sure about editing the plant?'**
  String get message_edit_plant;

  /// no_more
  ///
  /// In en, this message translates to:
  /// **'No more data'**
  String get no_more;

  /// edit_plant
  ///
  /// In en, this message translates to:
  /// **'Edit Plant'**
  String get edit_plant;

  /// cancel_edit
  ///
  /// In en, this message translates to:
  /// **'Are you sure about canceling the plant edition?'**
  String get cancel_edit;

  /// cancel_update
  ///
  /// In en, this message translates to:
  /// **'Are you sure to send the update?'**
  String get cancel_update;

  /// take_photo
  ///
  /// In en, this message translates to:
  /// **'To take the photo again, press the image'**
  String get take_photo;

  /// skip
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// get_location
  ///
  /// In en, this message translates to:
  /// **'Getting location...'**
  String get get_location;

  /// message_cancel_register
  ///
  /// In en, this message translates to:
  /// **'Are you sure about canceling the registration?'**
  String get message_cancel_register;

  /// message_send_register
  ///
  /// In en, this message translates to:
  /// **'Are you sure to send the registration?'**
  String get message_send_register;

  /// slide_to_continue
  ///
  /// In en, this message translates to:
  /// **'Slide to continue >'**
  String get slide_to_continue;

  /// see
  ///
  /// In en, this message translates to:
  /// **'See'**
  String get see;

  /// lifestage
  ///
  /// In en, this message translates to:
  /// **'Lifestage'**
  String get lifestage;

  /// select_lifestage
  ///
  /// In en, this message translates to:
  /// **'To complete the registration you must select the lifestage'**
  String get select_lifestage;

  /// message_plants_empty
  ///
  /// In en, this message translates to:
  /// **'To register your first plant press the button'**
  String get message_plants_empty;

  /// verify_code
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get verify_code;

  /// verify_code_failed
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verify_code_failed;

  /// no_receive_code
  ///
  /// In en, this message translates to:
  /// **'I have not received the code.'**
  String get no_receive_code;

  /// sign_up_failed
  ///
  /// In en, this message translates to:
  /// **'Sign up failed'**
  String get sign_up_failed;

  /// text_buttom_resend
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get text_buttom_resend;

  /// enter_email_valid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enter_email_valid;

  /// change_password
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// write_new_password
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get write_new_password;

  /// new_password
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// confirm_password
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// logout
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logout;

  /// slide
  ///
  /// In en, this message translates to:
  /// **'Slide'**
  String get slide;

  /// carousel
  ///
  /// In en, this message translates to:
  /// **'Image carousel'**
  String get carousel;

  /// search_without_results
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get search_without_results;

  /// text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttom_cancel;

  /// text
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please try again.'**
  String get error_connection;

  /// text
  ///
  /// In en, this message translates to:
  /// **'There are no registered plants at the moment.'**
  String get non_plant_registered;

  /// text
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get confirm_delete;

  /// text
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this Plant?'**
  String get delete_plant_question;

  /// text
  ///
  /// In en, this message translates to:
  /// **'Plant removed'**
  String get delete_plant_confirmed;

  /// text
  ///
  /// In en, this message translates to:
  /// **'A plant already sent is selected'**
  String get plant_selected;

  /// text
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get buttom_send;

  /// text
  ///
  /// In en, this message translates to:
  /// **'We\'re collecting your location information, please wait a moment and try again.'**
  String get location_info;

  /// text
  ///
  /// In en, this message translates to:
  /// **'Location data'**
  String get data_location;

  /// text
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// text
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @nSLocationWhenInUseUsageDescription.
  ///
  /// In en, this message translates to:
  /// **'We need access to your location to show your position on the map'**
  String get nSLocationWhenInUseUsageDescription;

  /// No description provided for @nSLocationAlwaysAndWhenInUseUsageDescription.
  ///
  /// In en, this message translates to:
  /// **'We need access to your location in the background to provide a better experience'**
  String get nSLocationAlwaysAndWhenInUseUsageDescription;

  /// No description provided for @nSCameraUsageDescription.
  ///
  /// In en, this message translates to:
  /// **'This app needs access to your camera in order to take pictures.'**
  String get nSCameraUsageDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
