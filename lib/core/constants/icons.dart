import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// App Icons
class AppIcons {
  // <--- General Icons --->
  // Back button
  static Icon backButton({double? size, Color? color}) {
    return Icon(
      Icons.arrow_back_ios_new_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // Forward button
  static Icon forwardButton({double? size, Color? color}) {
    return Icon(
      Icons.arrow_forward_ios_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // Share button
  static Icon shareButton({double? size, Color? color}) {
    return Icon(
      Icons.share_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // Share button
  static Icon copyButton({double? size, Color? color}) {
    return Icon(
      Icons.copy_all_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  //<--- Authentication Icons --->
  // Login icon
  static Icon loginIcon({double? size, Color? color}) {
    return Icon(
      Icons.login_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // Logout icon
  static Icon logoutIcon({double? size, Color? color}) {
    return Icon(
      Icons.logout_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // Google icon
  static Icon googleIcon({double? size, Color? color}) {
    return FaIcon(
      FontAwesomeIcons.google,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  //email icon
  static Icon emailIcon({double? size, Color? color}) {
    return Icon(
      Icons.email_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // password icon
  static Icon passwordIcon({double? size, Color? color}) {
    return Icon(
      Icons.lock_outline,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // password visibility icon
  static Icon visibilityIcon({double? size, Color? color}) {
    return Icon(
      Icons.visibility_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // password visibility off icon
  static Icon visibilityOffIcon({double? size, Color? color}) {
    return Icon(
      Icons.visibility_off_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // Apple icon
  static Icon appleIcon({double? size, Color? color}) {
    return FaIcon(
      FontAwesomeIcons.apple,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // Facebook icon
  static Icon facebookIcon({double? size, Color? color}) {
    return FaIcon(
      FontAwesomeIcons.facebookF,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // <--- Search Bar Icons --->
  // search icon
  static Icon searchIcon({double? size, Color? color}) {
    return Icon(
      Icons.search_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // clear search icon
  static Icon clearSearchIcon({double? size, Color? color}) {
    return Icon(
      Icons.close_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // <--- Navigation Bar Icons --->
  // home icon
  static Icon homeIcon({double? size, Color? color}) {
    return Icon(
      Icons.home_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // home icon
  static Icon homeIconFill({double? size, Color? color}) {
    return Icon(Icons.home, color: color ?? AppColors.onSurface, size: size);
  }

  // chats icon
  static Icon chatsIcon({double? size, Color? color}) {
    return Icon(
      Icons.chat_bubble_outline,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // songs icon
  static Icon songsIcon({double? size, Color? color}) {
    return Icon(
      Icons.music_note_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // songs icon
  static Icon songsIconFill({double? size, Color? color}) {
    return Icon(
      Icons.music_note,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  //admin profile Icon
  static Icon adminProfileIcon({double? size, Color? color}) {
    return Icon(
      Icons.manage_accounts_outlined,
      color: color ?? AppColors.primary,
      size: size,
    );
  }

  // user selection security
  static Icon securityIcon({double? size, Color? color}) {
    return Icon(
      Icons.shield_outlined,
      color: color ?? AppColors.primary,
      size: size,
    );
  }

  // profile icon
  static Icon profileIcon({double? size, Color? color}) {
    return Icon(
      Icons.person_outline,
      color: color ?? AppColors.primary,
      size: size,
    );
  }

  // profile icon
  static Icon profileIconFill({double? size, Color? color}) {
    return Icon(Icons.person, color: color ?? AppColors.primary, size: size);
  }

  // bible icon
  static Icon bibleIcon({double? size, Color? color}) {
    return Icon(
      Icons.menu_book_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // settings icon
  static Icon settingsIcon({double? size, Color? color}) {
    return Icon(
      Icons.settings_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // settings icon
  static Icon settingsIconFIll({double? size, Color? color}) {
    return Icon(
      Icons.settings,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // notifications icon
  static Icon notificationsIcon({double? size, Color? color}) {
    return Icon(
      Icons.notifications_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // <--- Message Icons --->
  // Message sent icon
  static Icon messageSentIcon({double? size, Color? color}) {
    return Icon(
      Icons.send_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // Message received icon
  static Icon messageReceivedIcon({double? size}) {
    return Icon(Icons.circle, color: AppColors.success, size: size);
  }

  // Message read icon
  static Icon messageReadIcon({double? size}) {
    return Icon(Icons.check, color: AppColors.tertiary, size: size);
  }

  // Message unread icon
  static Icon messageUnreadIcon({double? size}) {
    return Icon(Icons.check, color: AppColors.onSurfaceMuted, size: size);
  }

  // Message failed icon
  static Icon messageFailedIcon({double? size}) {
    return Icon(Icons.error_outline, color: AppColors.error, size: size);
  }

  // Message <--- Update Icons ---> icon

  // message update option icon
  static Icon messageUpdateOptionIcon({double? size, Color? color}) {
    return Icon(
      Icons.threed_rotation_sharp,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // Update available icon
  static Icon updateAvailableIcon({double? size, Color? color}) {
    return Icon(
      Icons.edit_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }

  // delete icon
  static Icon deleteIcon({double? size, Color? color}) {
    return Icon(
      Icons.delete_outlined,
      color: color ?? AppColors.onSurface,
      size: size,
    );
  }
}
