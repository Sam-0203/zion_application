class APIsurls {
  // static String baseUrl = 'http://192.168.0.119:8000/'; // office URL
  static String baseUrl = 'http://192.168.1.16:8000/'; // BZA home URL
  // static String baseUrl = 'https://zionholisticministries.org'; // orginal URL
  // static String baseUrl = 'http://192.168.31.176:8000'; // Home Network URL
  // static String baseUrl = 'http://192.168.0.114:8000'; // Hotspot Network URL

  //   <-- User Login URLs -->
  static String userLogin = '$baseUrl/appusers/saveuser/';
  static String login = userLogin; // Backward-compatible alias
  static String userTokenSave =
      '$baseUrl/appusers/savetoken'; // Save user token
  static String singleUserDetails =
      '$baseUrl/appusers/currentuser/'; // get single user by token
  static String userDetailsUpdate =
      '$baseUrl/appusers/users/<int:id>/update/'; //Update user details by id
  static String userDelete =
      '$baseUrl/appusers/users/<int:id>/delete/'; //Delete user by id
  static String userLogout =
      '$baseUrl/appusers/users/logout/'; //Logout user by token

  //   <-- Songs URLs -->
  static String songsList = '$baseUrl/songs/songslist/'; // Get all songs
  static String songDetail(int songId) => '$baseUrl/songs/$songId/';
  // static String songDetails = '$baseUrl/songs/<int:id>/'; // Get song details by id
  static String songSearch = '$baseUrl/songs/search/?q='; // Search songs

  //   <-- Bible URLs -->
  static String bibleBooks =
      '$baseUrl/bible/<str:language_code>/biblelist/'; // Get Bible books by language
  static String bibleVerses =
      '$baseUrl/bible/books/<int:book_id>/verses/'; // Get verses by book id
  static String bibleSearch =
      '$baseUrl/bible/search/?q='; // Search Bible verses
  static String dailyDevotional =
      '$baseUrl/bible/verseoftheday/today/'; // Get daily devotional by language code

  //  <-- Languages URLs -->
  static String languagesList =
      '$baseUrl/languages/languageslist/'; // Get languages list

  // <-- Authorizers logins URLs -->
  static String adminLogin =
      '$baseUrl/appusers/authorized/login/'; // Post admins login

  // <-- Prayer Request URLs -->
  static String home = '$baseUrl/prayer_request/'; // Get home
  static String prayerRequests =
      '$baseUrl/prayer_request/all_prayer_request/'; // Get prayerRequests
  static String prayerRequestsDetails(int prayerId) =>
      '$baseUrl/prayer_request/$prayerId/'; // Get prayer_requests details
  static String sendPrayerRequest =
      '$baseUrl/prayer_request/send_prayer_request/'; // Post send_prayer_request
  static String deletePrayerRequest =
      '$baseUrl/prayer_request/delete_prayer_request/<int:pr>/'; // Delete deletePrayerRequest
}
