// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> fr_FR = {
  "logout": {
    "title": "Se déconnecter",
    "confirm": "Voulez-vous vous déconnecter ?"
  },
  "global": {
    "confirm": "Etes vous sur ?",
    "loading": "Chargement en cours ...",
    "save": "Enregistrer",
    "success": "Opération réussi avec succes",
    "update": "Mise à jour",
    "delete": "Supprimer",
    "unexpected": "Erreur technique inattendu merci de contacter le support",
    "insufficientPermission": "Erreur technique inattendu merci de contacter le support",
    "serverError": "Erreur technique inattendu merci de contact le support",
    "noContent": "Pas de données",
    "yes": "Oui",
    "no": "Non"
  },
  "child": {
    "title": "fiche enfant"
  },
  "demands": {
    "title": "Mes demandes",
    "tabs": {
      "loading": "Chargement des demandes  ...",
      "error": "Erreur lors du chargement des demandes",
      "empty": "Aucune demande encore",
      "moveToTrash": "Supprimer la demande",
      "deleteConfirm": "Annuler la demande ?",
      "in_progress": {
        "tab": "En cours"
      },
      "passed": {
        "tab": "Passées"
      }
    }
  },
  "ask": {
    "title": "Demander",
    "inprogess": "Création de la demande en cours",
    "childlookup": {
      "title": "Récupérer mes enfants",
      "details": {
        "inprogess": "Mise à jour en cours"
      },
      "action": {
        "cancel": "Annuler la demande",
        "decline": "Décliner",
        "accept": "Accepter la proposition",
        "end": "Confirmer la récupération"
      },
      "event": {
        "created_template": "créé par {}",
        "canceled_template": "{} a annulé",
        "declined_template": "{} a décliné",
        "accepted_template": "accepté par {}",
        "ended_template": "{} a récupéré '{}'"
      },
      "notification": {
        "template": "Récupération de '{}' à '{}' {}",
        "created_template": "nouvelle mission de '{}', {}",
        "canceled_template": "{} a annulé la mission, {}",
        "declined_template": "{} a décliné la mission, {}",
        "accepted_template": "{} a accepté la mission, {}",
        "ended_template": "{} a bien récupéré '{}'"
      },
      "MissionState": {
        "accepted": "Prise en charge",
        "canceled": "Annulée",
        "waiting": "En attente",
        "ended": "Terminée"
      },
      "stepper": {
        "child_selection": "Sélection de l'enfant",
        "place_selection": "Sélection du lieu",
        "date_selection": "Sélection de la date",
        "note_selection": "Commentaires",
        "next": "Suivant",
        "previous": "Précédent"
      },
      "confirm": {
        "title": "Résumer de la demande",
        "msg": "Récupération de '{}' à '{}' \n {} au plus tard",
        "msgLookupChild": "Qui :",
        "msgLookupLocation": "Où :",
        "msgLookupDate": "Date :",
        "msgLookupNote": "Commentaires :",
        "confirm": "Confirmer",
        "cancel": "Annuler"
      },
      "success": "Création de la demande réussie"
    }
  },
  "childlookupDetails": {
    "title": "Récupération de l'enfant",
    "accept": "Prendre en charge",
    "cancel": "Annuler la demande"
  },
  "location": {
    "title": "Lieu",
    "unableToUpdate": "Erreur technique de la mise à jour du lieu",
    "unableToDelete": "Erreur technique lors de la suppression du lieu",
    "form": {
      "title": {
        "label": "Nom",
        "error": "Nom invalide"
      },
      "address": {
        "label": "Adresse",
        "error": "Adresse invalide"
      },
      "note": {
        "label": "Note",
        "error": "Note invalide"
      },
      "placePicker": {
        "label": "Sélectionner un lieu via Google Maps",
        "select": "Sélectionner le lieu"
      }
    },
    "search": {
      "title": "Rechercher une adresse"
    }
  },
  "form": {
    "email": {
      "label": "Adresse email",
      "error": "email invalide"
    },
    "password": {
      "label": "Mot de passe",
      "error": "Mot de passe invalide"
    },
    "firstname": {
      "label": "Prénom",
      "error": "Prénom invalide"
    },
    "lastname": {
      "label": "Nom",
      "error": "Nom invalide"
    },
    "birthday": {
      "label": "Date de naissance",
      "error": "Date de naissance non valide"
    },
    "phone": {
      "label": "Numéro de téléphone (+33)XXXXXXXXX",
      "error": "Numéro de téléphone au mauvais format"
    }
  },
  "login": {
    "title": "Connexion",
    "proceed": "Se connecter",
    "register": "Créer un compte",
    "or": "- Ou -",
    "google": "Google",
    "facebook": "Facebook",
    "alreadySignedWithAnotherMethod": "Compte déjà associé avec {}",
    "register_msg": "Pas encore de compte ?",
    "cancelledByUser": "Opération annulée",
    "emailAlreadyInUse": "Adresse email déjà utilisée",
    "invalidEmailAndPasswordCombination": "Invalid email and password combination"
  },
  "register": {
    "title": "Formulaire d'inscription",
    "cancelledByUser": "Opération annulée",
    "emailAlreadyInUse": "Adresse email déjà utilisée",
    "alreadySignedWithAnotherMethod": "Compte déjà associé avec {}",
    "proceed": "S'inscrire"
  },
  "search": {
    "title": "Recherche d'un utilisateur",
    "userLookupText": "prénom ou nom",
    "proceed": "S'inscrire"
  },
  "search_family": {
    "title": "Recherche d'une famille",
    "familyLookupText": "nom",
    "ask": "envoyer invitation",
    "no_result": "Aucun résultats"
  },
  "join_proposal": {
    "loadingFailed": "Erreur lors de la récupération des propositions \n merci de contacter le support",
    "summary": "Invitation envoyée à la famille '{}' {}",
    "details": {
      "family_label": "Famille",
      "status_label": "Status",
      "creation_date_label": "Envoyé",
      "expiration_date_label": "Expire",
      "member_label": "Personne ayant répondu",
      "accepted_text": "Acceptée",
      "canceled_text": "Annulée",
      "waiting_text": "En attente",
      "declined_text": "Refusée",
      "rejected_text": "Rejetée"
    },
    "send": {
      "button": "Envoyer une invitation",
      "confirm": "Envoyer l'invitation à la famille '{}'?",
      "failed": "Erreur lors de l'envoie de l'invitation \n merci d'essayer ultérieurement",
      "inProgress": "Envoie de l'invitation en cours ...",
      "success": "invitation envoyée"
    },
    "cancel": {
      "button": "Annuler la demande ?",
      "confirm": "Annuler la demande de rejoindre la famille '{}' ?",
      "failed": "Erreur lors de l'annulation de la demande",
      "inProgress": "Demande d'annulation en cours...",
      "success": "Demande annulée avec succès"
    },
    "decline": {
      "button": "Décliner la demande ?",
      "confirm": "Décliner la demande de '{}' ?",
      "failed": "Erreur lors de la déclinaison de la demande",
      "inProgress": "Déclinaison en cours...",
      "success": "Demande déclinée avec succès"
    },
    "accept": {
      "button": "Accepter la demande ?",
      "confirm": "Accepter la demande de '{}' ?",
      "failed": "Erreur lors de l'acceptation de la demande",
      "inProgress": "Acceptation de la demande en cours...",
      "success": "Demande acceptée avec succès"
    },
    "acceptFailed": "Erreur lors de l'acceptation de l'invitation",
    "acceptInProgress": "Acceptation de l'invitation en cours ...",
    "acceptSuccess": "invitation acceptée",
    "declineFailed": "Erreur lors de la déclinaison de l'invitation",
    "declineInProgress": "Invitation déclinée en cours...",
    "declineSuccess": "Invitation déclinée avec succès"
  },
  "user": {
    "title": "fiche utilisateur",
    "update": "Mise à jour de la fiche",
    "disconnect": "Mettre fin à la relation",
    "disconnect_confirm": "Vous êtes sur le point de mettre fin à la relation avec {} ?"
  },
  "trust_user": {
    "title": "fiche personne de confiance",
    "update": "Mise à jour de la fiche",
    "disconnect": "Supprimer la personne",
    "disconnect_confirm": "Vous êtes sur le point de retirer {} de vos personnes de confiance ?"
  },
  "notifications": {
    "title": "Fil d'actualité",
    "events_tab": "Notifications",
    "invitations_tab": "Invitations",
    "tabs": {
      "demands": {
        "title": "Demandes",
        "empty": "Aucuns demandes en cours"
      }
    }
  },
  "invitations": {
    "empty": "Aucunes invitations",
    "confirm": "Etes vous sur ?",
    "accept": "Accepter",
    "decline": "Décliner",
    "spouse_confirm": "Confirmez-vous être en couple avec {} ?",
    "trust_confirm": "Acceptez vous de faire partie du cercle de confiance de {} ?"
  },
  "events": {
    "empty": "Aucuns évènements",
    "confirm": "Etes vous sur ?",
    "accept": "Accepter",
    "decline": "Décliner",
    "markAsRead": "Marquer comme lu",
    "moveToTrash": "Supprimer le message"
  },
  "profile": {
    "title": "Profile",
    "sendSpouseProposal": "Envoie de l'invitation à {} ?",
    "sendTrustProposal": "Envoie de l'invitation à {} ?",
    "rejoinFamily": "Rejoindre une famille",
    "createNewFamily": "Créer une famille",
    "createNewFamilyConfirm": "Vous êtes sur le point ce créer une nouvelle famille ?",
    "deleteFamilyConfirm": "Suppression de la famille '{}' ?",
    "deleteLocationConfirm": "Suppression du lieu '{}' ?",
    "deleteChildConfirm": "Suppression de l'enfant '{}' ?",
    "tabs": {
      "children": {
        "tab": "Les enfants",
        "loading": "Chargement des enfants ...",
        "error": "Erreur lors du chargement des enfants",
        "noChildren": "Aucun enfant encore, merci d'en ajouter en cliquant sur le bouton ci-dessous"
      },
      "trusted": {
        "tab": "Personnes de confiances",
        "loading": "Chargement des personnes de confiances ...",
        "error": "Erreur lors du chargement des enfants",
        "noTrusted": "Aucune personne de confiance déclarée pour le moment, merci d'en ajouter en cliquant sur le bouton ci-dessous"
      },
      "locations": {
        "tab": "Lieux",
        "loading": "Chargement des lieux ...",
        "error": "Erreur lors du chargement des lieux",
        "noPlaces": "Aucun lieux encore, merci d'en ajouter en cliquant sur le bouton ci-dessous"
      }
    },
    "addFamilyInProgress": "Création de la famille '{}' en cours",
    "addFamilySuccess": "Création de la famille '{}' réussie",
    "addFamilyFailure": "Erreur lors de la création de la famille '{}'",
    "updateFamilyInProgress": "Mise à jour de la famille en cours",
    "updateFamilySuccess": "Mise à jour de la famille réussie",
    "updateFamilyFailure": "Erreur lors de la mise à jour de la famille",
    "deleteFamilyInProgress": "Suppression de la famille en cours",
    "deleteFamilySuccess": "Suppression de la famille réussie",
    "deleteFamilyFailure": "Erreur lors de la suppression de la famille",
    "unknownFamily": "Famille inconnue",
    "childrenNotLoaded": "Erreur lors du chargement des enfants",
    "addChildInProgress": "Ajout de l'enfant en cours",
    "addChildSuccess": "Ajout de l'enfant réussi",
    "addChildFailure": "Erreur lors de l'ajout de l'enfant",
    "updateChildInProgress": "Mise à jour de l'enfant en cours",
    "updateChildSuccess": "Mise à jour de la fiche de l'enfant réussi",
    "updateChildFailure": "Erreur lors de la mise à jour de la fiche de l'enfant",
    "deleteChildInProgress": "Suppression de l'enfant en cours",
    "deleteChildSuccess": "Suppression de l'enfant réussi",
    "deleteChildFailure": "Erreur lors de la suppression de l'enfant",
    "locationsNotLoaded": "Erreur lors du chargement des lieux",
    "addLocationInProgress": "Création du lieu en cours",
    "addLocationSuccess": "Création du lieu réussi",
    "addLocationFailure": "Erreur lors de la création du lieu",
    "updateLocationInProgress": "Mise à jour du lieu en cours",
    "updateLocationSuccess": "Mise à jour du lieu réussi",
    "updateLocationFailure": "Erreur lors de la mise à jour du lieu",
    "deleteLocationInProgress": "Suppression du lieu en cours",
    "deleteLocationSuccess": "Suppression du lieu réussi",
    "deleteLocationFailure": "Erreur lors de la suppression du lieu",
    "trustedUsersNotLoaded": "Erreur lors du chargement des personnes de confiances",
    "addTrustedUserInProgress": "Envoi demande d'ajout dans le cercle en cours",
    "addTrustedUserSuccess": "Envoi de la demande d'ajout dans le cercle de confiance réussi",
    "addTrustedUserFailure": "Erreur lors de l'ajout d'une personne de confiance",
    "deleteTrustedUserInProgress": "Suppression de la personne de confiance en cours",
    "deleteTrustedUserSuccess": "Suppression de la personne de confiance réussi",
    "deleteTrustedUserFailure": "Erreur lors de la suppression de la personne de confiance"
  },
  "family": {
    "title": "Famille",
    "create_confirm": "Vous aller créer une nouvelle famille ?",
    "form": {
      "name": {
        "label": "Nom",
        "error": "Nom invalide"
      }
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"fr_FR": fr_FR};
}
