import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

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
    Locale('ko')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @my_trip.
  ///
  /// In en, this message translates to:
  /// **'My Trip'**
  String get my_trip;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @great_deals.
  ///
  /// In en, this message translates to:
  /// **'Great Deals'**
  String get great_deals;

  /// No description provided for @introducing.
  ///
  /// In en, this message translates to:
  /// **'Introducing'**
  String get introducing;

  /// No description provided for @our_guarantee.
  ///
  /// In en, this message translates to:
  /// **'Our Guarantee'**
  String get our_guarantee;

  /// No description provided for @our_msg.
  ///
  /// In en, this message translates to:
  /// **'Automatic protection included with every ticket at no extra cost.'**
  String get our_msg;

  /// No description provided for @learn_more.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learn_more;

  /// No description provided for @search_flight.
  ///
  /// In en, this message translates to:
  /// **'Search Flight'**
  String get search_flight;

  /// No description provided for @recent_searches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recent_searches;

  /// No description provided for @no_recent_searches.
  ///
  /// In en, this message translates to:
  /// **'No recent searches'**
  String get no_recent_searches;

  /// No description provided for @prices_are_not.
  ///
  /// In en, this message translates to:
  /// **'Prices are not real-time.'**
  String get prices_are_not;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stops;

  /// No description provided for @non_stop.
  ///
  /// In en, this message translates to:
  /// **'Nonstop'**
  String get non_stop;

  /// No description provided for @up_to_1_stop.
  ///
  /// In en, this message translates to:
  /// **'Up to 1 stop'**
  String get up_to_1_stop;

  /// No description provided for @up_to_2_stops.
  ///
  /// In en, this message translates to:
  /// **'Up to 2 stops'**
  String get up_to_2_stops;

  /// No description provided for @take_off.
  ///
  /// In en, this message translates to:
  /// **'Take Off'**
  String get take_off;

  /// No description provided for @landing.
  ///
  /// In en, this message translates to:
  /// **'Landing'**
  String get landing;

  /// No description provided for @flight_duration.
  ///
  /// In en, this message translates to:
  /// **'Flight Duration'**
  String get flight_duration;

  /// No description provided for @layover_duration.
  ///
  /// In en, this message translates to:
  /// **'Layover Duration'**
  String get layover_duration;

  /// No description provided for @airlines.
  ///
  /// In en, this message translates to:
  /// **'Airlines'**
  String get airlines;

  /// No description provided for @layover_cities.
  ///
  /// In en, this message translates to:
  /// **'Layover Cities'**
  String get layover_cities;

  /// No description provided for @trip_details.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get trip_details;

  /// No description provided for @book_now.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get book_now;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @one_way.
  ///
  /// In en, this message translates to:
  /// **'One Way'**
  String get one_way;

  /// No description provided for @round_trip.
  ///
  /// In en, this message translates to:
  /// **'Round Trip'**
  String get round_trip;

  /// No description provided for @travelers.
  ///
  /// In en, this message translates to:
  /// **'Travelers'**
  String get travelers;

  /// No description provided for @adults.
  ///
  /// In en, this message translates to:
  /// **'Adults'**
  String get adults;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @infant_lap.
  ///
  /// In en, this message translates to:
  /// **'Infant (lap)'**
  String get infant_lap;

  /// No description provided for @infant_seat.
  ///
  /// In en, this message translates to:
  /// **'Infant (seat)'**
  String get infant_seat;

  /// No description provided for @economy.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get economy;

  /// No description provided for @premium_economy.
  ///
  /// In en, this message translates to:
  /// **'Premium Economy'**
  String get premium_economy;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @first.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get first;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @book_departing_for.
  ///
  /// In en, this message translates to:
  /// **'Book Departing for'**
  String get book_departing_for;

  /// No description provided for @choose_departing_flight.
  ///
  /// In en, this message translates to:
  /// **'Choose Departing Flight'**
  String get choose_departing_flight;

  /// No description provided for @choose_returning_flight.
  ///
  /// In en, this message translates to:
  /// **'Choose Returning Flight'**
  String get choose_returning_flight;

  /// No description provided for @total_cost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get total_cost;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get log_out;

  /// No description provided for @where_do_you_want_to_go.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to go?'**
  String get where_do_you_want_to_go;

  /// No description provided for @only.
  ///
  /// In en, this message translates to:
  /// **'only'**
  String get only;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @no_matching_countries.
  ///
  /// In en, this message translates to:
  /// **'No matching countries'**
  String get no_matching_countries;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'\'Automatic protection included with every ticket at no extra cost.\''**
  String get automatic;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @c_class.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get c_class;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
