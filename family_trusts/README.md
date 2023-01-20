# familytrusts

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Remarque :
 - Soucis sur le SSO, une fois l'application fermée, on perd la session
 - Le cadrage des photos ou initial
 - proposer la gallery par défaut pour les photos
 - page profile > avoir un tab pour
 - Attention à ne pas pouvoir modifier l'email une fois saisie


Les features à faire :
 - permettre de ne plus recevoir les notifications de certaines personnes
 - Si une personne n'est pas trouvée dans l'application, permettre l'envoi d'un email pour s'inscrire
    Voir template d'email avec lien dans le store


Les features pour le Minimum Viable Product :
 - Gérer la localisation des personnes dans la fiche personne
 - permettre de saisir une liste de lieux favoris (domicile, école etc...)
 - Lors de la recherche, si pas trouvé envoie d'un email/sms pour s'inscrire sur l'application (tricher avec la beta fermé)
    Bascule vers les contacts avec la possibilité d'envoie d'invitation en masse
 - UC missions :
    - Une mission n'est visible que si dans la même région que la personne
    - Gérer les notifications comme sur whatsapp (pastille sur l'icone de l'apps + notification téléphone)
 - Publication de l'appication dans le store Android > "en mode fermé"


Générer les fichiers json et freezed
flutter pub run build_runner watch --delete-conflicting-outputs

Générer une clé
keytool -genkey -v -keystore familytrusts.jks -alias familytrusts_key -keyalg RSA -keysize 2048 -validity 10000

keytool -exportcert -alias familytrusts_key -keystore familytrusts.jks | openssl sha1 -binary | openssl base64

convertir les secrets en base 64
openssl base64 -in android/app/google-services.json > googleservice-info.txt
openssl base64 -in ios/Runner/GoogleService-Info.plist > googleservice-info.txt

Commande pour générer les traductions
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart
flutter pub run easy_localization:generate

logo
https://www.freelogoservices.com/fr/home-return
a.djoutsop@gmail.com:Support2424

flutter build appbundle --no-shrink
Java -jar bundletool-all-1.2.0.jar build-apks --bundle=outputs/bundle/release/app-release.aab --output=app.apks --ks=../../familytrusts.jks --ks-key-alias=familytrusts_key --ks-pass=pass:Support2424 --mode=universal

clear pg connexion
heroku login
heroku pg:killall


** publication
https://app-privacy-policy-generator.firebaseapp.com/
