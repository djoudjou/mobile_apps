import 'package:flutter/material.dart';

// Env
const String baseUrlEnvVar = "API_URL";

//Images

const String logoFamilyImagesPath = "images/family_logo.png";
const String logoImagesPath = "images/400PngdpiLogo.png";
const String defaultChildImagesPath = "images/childheadwithsmilingface.png";
const String defaultUserImagesPath =
    "images/account_avatar_face_man_people_profile_user_icon.png";
const String profileImagesPath = "images/family2.jpg";
const String notificationsImagesPath = "images/family.jpeg";
const String defaultLocationImagesPath = "images/location.png";
const String childrenLookupImagesPath = "images/recuperation_enfants.jpeg";

const AssetImage childrenLookupImages = AssetImage(childrenLookupImagesPath);
const AssetImage logoImages = AssetImage(logoImagesPath);
const AssetImage defaultChildImages = AssetImage(defaultChildImagesPath);
const AssetImage defaultUserImages = AssetImage(defaultUserImagesPath);
const AssetImage profileImages = AssetImage(profileImagesPath);
const AssetImage notificationsImages = AssetImage(notificationsImagesPath);
const AssetImage defaultLocationImages = AssetImage(defaultLocationImagesPath);

//Icons
Icon camIcon = const Icon(Icons.camera_enhance);
Icon libIcon = const Icon(Icons.photo_library);

// Widget
Widget emptyWidget = Container(height: 0.0);

// Main color
const primaryColor = Colors.blue;

// firebase const
const fieldId = "id";
const fieldName = "name";
const fieldSurname = "surname";
const fieldBirthday = "birthday";
const fieldPhotoUrl = "photoUrl";

const fieldDate = "date";
const fieldFrom = "from";
const fieldTo = "to";
const fieldType = "type";
const fieldSeen = "seen";
const fieldSubject = "subject";

const fieldTrusted = "trusted";

const fieldSince = "since";
const fieldBy = "by";

const fieldEmail = "email";
const fieldSpouse = "spouse";
const fieldFamilyId = "familyId";
const fieldSpouseProposal = "spouseProposal";

const int megabyte = 1024 * 1024;

// Google place
const defaultLocation = "";

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.black87,
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);
