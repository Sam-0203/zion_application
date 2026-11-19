class CustomStrings {
  // time based greetings
  static String get timeBasedGreeting {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  // App Info
  static const String appName = 'Zion App';
  static const String ministryName = 'Zion Holistic Ministries';
  static const String applicationTitle = 'Zion Application';
  static const String splashScreenAppName = 'ZION';

  // Welcome Screen
  static const String welcomeMessage = 'Welcome Back';
  static const String praiseTheLord = 'Praise the Lord!';
  static const String elevateYourSpirit = 'ELEVATE YOUR SPIRIT';
  static const String dailyInspiration = 'Daily Inspiration...';
  static const String devotionText = 'ZION DEVOTIONAL';
  static const String comingNext = 'Coming next: Morning Prayer';
  static const String tapToContinue = 'Tap to continue';

  // User login selection Screen
  static const String selectionHeader = 'Welcome';
  static const String selectionSubHeader = 'Continue as Admin or User';
  static const String selectionAdminCardHeader = 'Admin';
  static const String selectionAdminCardSubHeader =
      'Manage application content';
  static const String selectionUserCardHeader = 'User';
  static const String selectionUserCardSubHeader = 'Browse and listen to songs';

  // Login Screen
  static const String loginHeader = 'Welcome Back!';
  static const String loginSubHeader = 'Please enter your details to sign in.';
  static const String loginSubHeader2 =
      'Please select your login type to sign in.';
  static const String loginOptionText = 'OR CONTINUE WITH';

  // Form Labels
  static const String userName = 'Username';
  static const String password = 'Password';

  // Placeholders
  static const String enterUserName = 'Enter your Username';
  static const String enterPassword = 'Enter your password';
  static const String enterAuthorizedEmail = 'Enter your Authorized email';

  // Buttons
  static const String loginButtonText = 'Login';
  static const String logoutButtonText = 'Logout';
  static const String googleLoginButton = 'Continue with Google';

  // Other Actions
  static const String forgotPassword = 'Forgot Password?';

  // Footer
  static const String footer = '© 2024 $ministryName. All rights reserved.';

  // Error Messages
  static const String errorLoadingData = 'Error loading data';
  static const String noData = 'No data';
  static const String noDataFound = 'No data found';
  static const String somethingWentWrong = 'Something went wrong';
  static const String googleLoginErrorMessage =
      'Google login failed. Please try again.';

  // Settings
  static const String settingsTitle = 'Settings';
  static const String settingsSubtitle = 'Manage your Zion app experience';
  static const String zionMember = 'Zion member';
  static const String zionInitial = 'Z';
  static const String yourAccount = 'Your account';
  static const String accountDetails = 'Account details';
  static const String accountType = 'Account type';
  static const String name = 'Name';
  static const String email = 'Email';
  static const String notAvailable = 'Not available';
  static const String yourZionApp = 'YOUR ZION APP';
  static const String accountAndApp = 'ACCOUNT & APP';
  static const String languageSettings = 'Languages';
  static const String languageSettingsSubtitle =
      'Set Word of God and app language';
  static const String bibleLanguages = 'Bible languages';
  static const String bibleLanguagesSubtitle =
      'Choose a language and browse the Bible';
  static const String worshipSongs = 'Worship songs';
  static const String worshipSongsSubtitle = 'Browse songs in the Zion library';
  static const String prayerRequests = 'Prayer requests';
  static const String prayerRequestsSubtitle = 'Read and share prayer requests';
  static const String accountDetailsSubtitle =
      'View your saved account information';
  static const String aboutZionApp = 'About Zion App';
  static const String appVersion = 'Version 0.1.0';
  static const String appVersionNumber = '0.1.0';
  static const String appVersionFooter = 'Zion App · Version 0.1.0';
  static const String logOutQuestion = 'Log out?';
  static const String logoutConfirmation =
      'You will need to sign in again to access your account.';
  static const String cancel = 'Cancel';
  static const String close = 'Close';
  static const String logOut = 'Log out';
  static const String loggingOut = 'Logging out…';
  static const String aboutZionDescription =
      'A place to read the Bible, listen to worship songs, and find daily inspiration.';
  static const String termsAndConditions = 'Terms and Conditions';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsSubtitle = 'Read the app terms';
  static const String privacySubtitle = 'Learn how the app uses your data';

  // Language settings
  static const String languagesTitle = 'Languages';
  static const String languagesIntro =
      'Choose languages for your Zion experience.';
  static const String wordOfGodLanguage = 'WORD OF GOD LANGUAGE';
  static const String wordOfGodLanguageDescription =
      'Used for your daily Word of God verse.';
  static const String appLanguage = 'APP LANGUAGE';
  static const String appLanguageDescription =
      'Choose and save your preferred app language.';
  static const String noLanguagesAvailable = 'No languages are available.';
  static const String couldNotLoadLanguages = 'Could not load languages';
  static const String couldNotLoadBibleBooks = 'Could not load Bible books';
  static const String noBooksAvailable = 'No books available';
  static const String noBooksForLanguage =
      'There are no books available for this language.';
  static const String retry = 'Retry';
  static const String wordOfGodLanguageSaved = 'Word of God language set to';
  static const String appLanguageSaved = 'App language set to';
  static String wordOfGodLanguageSavedFor(String language) =>
      '$wordOfGodLanguageSaved $language';
  static String appLanguageSavedFor(String language) =>
      '$appLanguageSaved $language';

  // Profile
  static const String myProfile = 'My Profile';
  static const String couldNotLoadProfile = 'Could not load your profile';
  static const String tryAgain = 'Try again';
  static const String personalInformation = 'PERSONAL INFORMATION';
  static const String username = 'Username';
  static const String mobile = 'Mobile';
  static const String dateOfBirth = 'Date of birth';
  static const String age = 'Age';
  static const String bio = 'Bio';
  static const String notProvided = 'Not provided';
  static const String couldNotLoadProfileStatus = 'Could not load profile';
  static String profileLoadFailure(int statusCode) =>
      '$couldNotLoadProfileStatus ($statusCode).';
  static const String booksCountSuffix = 'books';
  static const String chapterPrefix = 'Chapter';
  static const String prayerRequestTitle = 'Prayer Request';
  static const String allPrayerRequestsTitle = 'All Prayer Requests';
  static const String noPrayerDetails = 'No prayer details found';
  static const String viewsPrefix = 'Views';

  // Legal information
  static const String termsIntro =
      'By using Zion App, you agree to use its features responsibly.';
  static const List<String> termsAndConditionsContent = [
    'Zion App provides Bible reading, daily devotional verses, worship songs, and prayer request features for personal and community use.',
    'Use the app respectfully. Do not submit unlawful, abusive, misleading, or harmful content through prayer requests or other app features.',
    'Only share personal information in a prayer request when you have permission to do so. Prayer requests may be visible to other app users.',
    'Bible, song, and devotional content may be provided by Zion services or other content owners. Their rights remain with the respective owners.',
    'App features and content depend on network access and the availability of Zion services. Features may change as the app is maintained.',
    'You are responsible for keeping your account credentials and device secure.',
  ];
  static const String privacyIntro =
      'This page describes data the current Zion App code stores and sends to its services.';
  static const String privacyInformationHeading = 'Information the app uses';
  static const String privacyLocalStorageHeading = 'Stored on your device';
  static const String privacyNetworkHeading = 'Sent to Zion services';
  static const String privacyPermissionsHeading = 'Permissions and tracking';
  static const List<String> privacyStoredContent = [
    'The app stores your name, email, profile photo, initials, account role, and sign-in tokens in secure device storage.',
    'Your selected Word of God language and app language are saved in secure device storage so they remain selected on this device.',
  ];
  static const List<String> privacySentContent = [
    'The profile page requests username, date of birth, age, mobile number, bio, preferences, and account status from the Zion API. Bible, daily devotional, songs, and prayer request features also contact the configured Zion API. Authenticated requests may include your access token.',
    'Prayer request text you submit is sent to the Zion API and may be shown to other app users in the prayer request section.',
  ];
  static const List<String> privacyDeviceUseContent = [
    'If you choose Share or Copy for a Bible verse or daily devotional, its text is passed to the device share sheet or copied to the clipboard.',
    'The current app code does not request location, contacts, or camera access. No analytics or advertising SDK is configured in the app dependencies.',
  ];
  static const String termsAcceptanceNote =
      'Please use Zion App in a respectful and responsible way.';
  static const String termsSectionHeading = 'Using Zion App';

  // Shared navigation and empty/error states
  static const String tabHome = 'Home';
  static const String tabSongs = 'Songs';
  static const String tabBible = 'Bible';
  static const String tabSettings = 'Settings';
  static const String genericUser = 'User';
  static const String couldNotLoadData = 'Could not load data';
  static const String couldNotLoadPrayerRequests =
      'Could not load prayer requests';
  static const String couldNotLoadSongs = 'Could not load songs';
  static const String couldNotLoadSong = 'Could not load song';
  static const String noSongDetailsFound = 'No song details found';
  static const String noSongsFound = 'No songs found';
  static const String noLanguagesFound = 'No languages found';
  static const String noVersesAvailable = 'No verses available';
  static const String couldNotLoadVerses = 'Could not load verses';
  static const String couldNotLoadPrayerDetails = 'No prayer details found';
  static const String viewMore = 'View More';
  static const String wordOfGod = 'Word of God';
  static const String you = 'You';
  static const String prayerRequestHint = 'Write your prayer request...';
  static const String prayerRequest = 'Prayer Request';
  static String prayerViewsCount(int count) => 'Views: $count';
  static String booksCount(int count) => '$count $booksCountSuffix';
  static String chapterTitle(int chapter) => '$chapterPrefix $chapter';
  static String chapterViewsCount(int count) => '${count}v';

  // Bible screens
  static const String moreBibleLanguagesComing =
      'More languages will be added in the future.';
  static const String selectVerseToListen = 'Select a verse to listen';
  static const String audioPlayerReady = 'Audio player ready';
  static const String playingNow = 'Playing now';
  static const String tapPlayToListen = 'Tap play to listen';
  static const String paused = 'Paused';
  static const String share = 'Share';
  static const String copy = 'Copy';
  static const String copied = 'Copied';
  static const String bibleVerseCopied = 'Bible verse copied successfully';
  static String noVersesForChapter(String book, int chapter) =>
      '$book Chapter $chapter has no verses available.';
  static String bibleVerseShareText({
    required String date,
    required String selectedVerse,
    required String? englishVerse,
    required String reference,
  }) => [
    '- Praise the Lord brother & sister',
    '- $date',
    '',
    '- $selectedVerse',
    '',
    if (englishVerse != null && englishVerse.isNotEmpty) ...[
      '- $englishVerse',
      '',
    ],
    '- $reference',
  ].join('\n');

  // Daily devotional screen
  static const String pleaseTryAgainLater = 'Please try again later.';
  static const String dataLoading = 'Data Loading...';
  static const String todaysWordCopied =
      "Today's Word of God copied successfully";
  static const String praiseTheLordForSharing =
      'Praise the Lord brother & sister';
  static String devotionalShareText({
    required String date,
    required String selectedVerse,
    required String? englishVerse,
    required String reference,
  }) => [
    '- $praiseTheLordForSharing',
    '- $date',
    '',
    '- $selectedVerse',
    '',
    if (englishVerse != null && englishVerse.isNotEmpty) ...[
      '- $englishVerse',
      '',
    ],
    '- $reference',
  ].join('\n');

  // Network screen
  static const String noInternetConnection = 'No Internet Connection';
  static const String checkInternetAndTryAgain =
      'Please check your internet connection\nand try again.';
  static const String networkTryAgain = 'Try Again';
  static const String currentlyOffline = 'You are currently offline';

  // Songs and audio
  static const String songDetailsTitle = 'Song Details';
  static const String audioUnavailable = 'Audio unavailable';
  static const String audioNotAvailableForSong =
      'Audio is not available for this song.';
  static const String audioError = 'Audio Error';
  static const String unableToPlaySong = 'Unable to play this song.';
  static const String durationParseError = 'Duration parse error';
  static const String audioPlaybackError = 'Audio playback error';
  static const String songsSearch = 'Search Songs';

  // Prayer requests
  static const String prayerRequestsTitle = 'Prayer Requests';
  static const String prayerRequestsLowercase = 'prayer requests';
  static const String sharePrayerRequestTitle = 'Share a Prayer Request';
  static const String prayerRequestSubtitle = 'Let us pray with you';
  static const String prayerRequestCommunityNotice =
      'Your request will be shared with the prayer community.';
  static const String submitPrayerRequest = 'Submit Prayer Request';
  static const String pleaseEnterPrayerRequest =
      'Please enter your prayer request.';

  // Authentication
  static const String loginFailed = 'Login Failed';
  static const String loginProviderSetupMissing =
      'Social login is not configured for this app yet.';
  static const String googleServerClientIdMissing =
      'Add the Google Web application client ID as serverClientId. This is needed for native sign-in, not Flutter Web.';
  static const String loginResponseMissingToken =
      'Login succeeded, but the server did not return an access token.';
  static const String loginResponseInvalid =
      'The login server returned an invalid response.';
  static const String loginProviderMissingEmail =
      'The provider did not return an email address.';
  static const String loginProviderMissingUserId =
      'Facebook did not provide a user ID.';
  static const String loginTryAgain = 'Login failed. Please try again.';
  static const String unableToContinueWithGoogle =
      'Unable to continue with Google.';
  static const String unableToContinueWithFacebook =
      'Unable to continue with Facebook.';
  static const String continueWithFacebook = 'Continue with Facebook';
  static const String or = 'or';
  static const String secureAccessMessage =
      'Secure access for your spiritual journey';
  static const String usernameRequired = 'Username is required';
  static const String passwordRequired = 'Password is required';
}
