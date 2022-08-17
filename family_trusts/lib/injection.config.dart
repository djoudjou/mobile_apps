// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart' as _i6;
import 'package:firebase_analytics/firebase_analytics.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i5;
import 'package:firebase_messaging/firebase_messaging.dart' as _i7;
import 'package:firebase_storage/firebase_storage.dart' as _i20;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as _i3;
import 'package:geoflutterfire/geoflutterfire.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_geocoding/google_geocoding.dart' as _i9;
import 'package:google_sign_in/google_sign_in.dart' as _i10;
import 'package:injectable/injectable.dart' as _i2;

import 'src/application/auth/authentication_bloc.dart' as _i24;
import 'src/application/auth/sign_in_form/sign_in_form_bloc.dart' as _i34;
import 'src/application/children_lookup/children_lookup_bloc.dart' as _i52;
import 'src/application/children_lookup/details/children_lookup_details_bloc.dart'
    as _i53;
import 'src/application/demands/demands_bloc.dart' as _i54;
import 'src/application/family/children/form/children_form_bloc.dart' as _i51;
import 'src/application/family/children/watcher/children_bloc.dart' as _i38;
import 'src/application/family/location/form/location_form_bloc.dart' as _i43;
import 'src/application/family/location/watcher/locations_bloc.dart' as _i32;
import 'src/application/family/setup/setup_family_bloc.dart' as _i49;
import 'src/application/family/trusted/trusted_form/trusted_user_form_bloc.dart'
    as _i50;
import 'src/application/family/trusted/trusted_watcher/trusted_user_watcher_bloc.dart'
    as _i35;
import 'src/application/home/tab/tab_bloc.dart' as _i22;
import 'src/application/home/user/user_bloc.dart' as _i36;
import 'src/application/messages/messages_bloc.dart' as _i33;
import 'src/application/notifications/notifications_events/notifications_events_bloc.dart'
    as _i44;
import 'src/application/notifications/notifications_events/notifications_events_update_bloc.dart'
    as _i45;
import 'src/application/notifications/notifications_invitations/notifications_invitations_bloc.dart'
    as _i46;
import 'src/application/notifications/tab/notification_tab_bloc.dart' as _i18;
import 'src/application/notifications/unseen/notifications_unseen_bloc.dart'
    as _i47;
import 'src/application/planning/planning_bloc.dart' as _i48;
import 'src/application/profil/tab/profil_tab_bloc.dart' as _i19;
import 'src/application/search_user/search_user_bloc.dart' as _i21;
import 'src/application/user_form/user_form_bloc.dart' as _i37;
import 'src/domain/auth/i_auth_facade.dart' as _i11;
import 'src/domain/children_lookup/i_children_lookup_repository.dart' as _i39;
import 'src/domain/error/i_error_service.dart' as _i13;
import 'src/domain/family/i_family_repository.dart' as _i25;
import 'src/domain/invitation/i_spouse_proposal_repository.dart' as _i29;
import 'src/domain/messages/i_messages_repository.dart' as _i27;
import 'src/domain/notification/i_notification_repository.dart' as _i41;
import 'src/domain/user/i_user_repository.dart' as _i15;
import 'src/helper/analytics_svc.dart' as _i23;
import 'src/infrastructure/auth/firebase_auth_facade.dart' as _i12;
import 'src/infrastructure/children_lookup/firebase_children_lookup_repository.dart'
    as _i40;
import 'src/infrastructure/core/firebase_injectable_module.dart' as _i55;
import 'src/infrastructure/core/geocoding_injectable_module.dart' as _i56;
import 'src/infrastructure/family/firebase_family_repository.dart' as _i26;
import 'src/infrastructure/http/api_service.dart' as _i17;
import 'src/infrastructure/invitation/firebase_spouse_proposal_repository.dart'
    as _i30;
import 'src/infrastructure/messages/firebase_messages_repository.dart' as _i28;
import 'src/infrastructure/notification/firebase_notification_repository.dart'
    as _i42;
import 'src/infrastructure/user/api_user_repository.dart' as _i16;
import 'src/infrastructure/user/firebase_user_repository.dart' as _i31;
import 'src/services/error/error_service.dart' as _i14;

const String _prod = 'prod';
const String _dev = 'dev';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final firebaseInjectableModule = _$FirebaseInjectableModule();
  final geocodingInjectableModule = _$GeocodingInjectableModule();
  gh.lazySingleton<_i3.FacebookAuth>(
      () => firebaseInjectableModule.facebookAuth);
  gh.lazySingleton<_i4.FirebaseAnalytics>(
      () => firebaseInjectableModule.firebaseAnalytics);
  gh.lazySingleton<_i5.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth);
  gh.lazySingleton<_i6.FirebaseFirestore>(
      () => firebaseInjectableModule.firebaseFirestore);
  gh.lazySingleton<_i7.FirebaseMessaging>(() => firebaseInjectableModule.fire);
  gh.lazySingleton<_i8.Geoflutterfire>(
      () => firebaseInjectableModule.geoflutterfire);
  gh.lazySingleton<_i9.GoogleGeocoding>(
      () => geocodingInjectableModule.googleGeocoding);
  gh.lazySingleton<_i10.GoogleSignIn>(
      () => firebaseInjectableModule.googleSignIn);
  gh.lazySingleton<_i11.IAuthFacade>(() => _i12.FirebaseAuthFacade(
      get<_i5.FirebaseAuth>(),
      get<_i10.GoogleSignIn>(),
      get<_i3.FacebookAuth>()));
  gh.lazySingleton<_i13.IErrorService>(() => _i14.SentryErrorService());
  gh.lazySingleton<_i15.IUserRepository>(
      () => _i16.ApiUserRepository(get<_i17.ApiService>()),
      registerFor: {_prod});
  gh.factory<_i18.NotificationTabBloc>(() => _i18.NotificationTabBloc());
  gh.factory<_i19.ProfilTabBloc>(() => _i19.ProfilTabBloc());
  gh.lazySingleton<_i20.Reference>(
      () => firebaseInjectableModule.storageReference);
  gh.factory<_i21.SearchUserBloc>(() => _i21.SearchUserBloc(
      get<_i15.IUserRepository>(), get<_i11.IAuthFacade>()));
  gh.factory<_i22.TabBloc>(() => _i22.TabBloc());
  gh.factory<_i23.AnalyticsSvc>(() => _i23.AnalyticsSvc(
      get<_i4.FirebaseAnalytics>(), get<_i13.IErrorService>()));
  gh.factory<_i24.AuthenticationBloc>(
      () => _i24.AuthenticationBloc(get<_i11.IAuthFacade>()));
  gh.lazySingleton<_i25.IFamilyRepository>(() => _i26.FirebaseFamilyRepository(
      get<_i15.IUserRepository>(),
      get<_i6.FirebaseFirestore>(),
      get<_i20.Reference>(),
      get<_i8.Geoflutterfire>(),
      get<_i13.IErrorService>()));
  gh.lazySingleton<_i27.IMessagesRepository>(() =>
      _i28.FirebaseMessagesRepository(get<_i7.FirebaseMessaging>(),
          get<_i13.IErrorService>(), get<_i15.IUserRepository>()));
  gh.lazySingleton<_i29.ISpouseProposalRepository>(() =>
      _i30.FirebaseSpouseProposalRepository(
          get<_i6.FirebaseFirestore>(), get<_i15.IUserRepository>()));
  gh.lazySingleton<_i15.IUserRepository>(
      () => _i31.FirebaseUserRepository(get<_i6.FirebaseFirestore>(),
          get<_i20.Reference>(), get<_i23.AnalyticsSvc>()),
      registerFor: {_dev});
  gh.factory<_i32.LocationsBloc>(
      () => _i32.LocationsBloc(get<_i25.IFamilyRepository>()));
  gh.factory<_i33.MessagesBloc>(() => _i33.MessagesBloc(
      get<_i27.IMessagesRepository>(), get<_i13.IErrorService>()));
  gh.factory<_i34.SignInFormBloc>(() =>
      _i34.SignInFormBloc(get<_i11.IAuthFacade>(), get<_i23.AnalyticsSvc>()));
  gh.factory<_i35.TrustedUserWatcherBloc>(
      () => _i35.TrustedUserWatcherBloc(get<_i25.IFamilyRepository>()));
  gh.factory<_i36.UserBloc>(() => _i36.UserBloc(
      get<_i15.IUserRepository>(), get<_i29.ISpouseProposalRepository>()));
  gh.factory<_i37.UserFormBloc>(() => _i37.UserFormBloc(
      get<_i15.IUserRepository>(),
      get<_i23.AnalyticsSvc>(),
      get<_i25.IFamilyRepository>()));
  gh.factory<_i38.ChildrenBloc>(
      () => _i38.ChildrenBloc(get<_i25.IFamilyRepository>()));
  gh.lazySingleton<_i39.IChildrenLookupRepository>(() =>
      _i40.FirebaseChildrenLookupRepository(
          get<_i15.IUserRepository>(),
          get<_i6.FirebaseFirestore>(),
          get<_i13.IErrorService>(),
          get<_i25.IFamilyRepository>()));
  gh.lazySingleton<_i41.INotificationRepository>(() =>
      _i42.FirebaseNotificationRepository(
          get<_i15.IUserRepository>(),
          get<_i6.FirebaseFirestore>(),
          get<_i39.IChildrenLookupRepository>(),
          get<_i13.IErrorService>()));
  gh.factory<_i43.LocationFormBloc>(() => _i43.LocationFormBloc(
      get<_i25.IFamilyRepository>(),
      get<_i41.INotificationRepository>(),
      get<_i23.AnalyticsSvc>()));
  gh.factory<_i44.NotificationsEventsBloc>(
      () => _i44.NotificationsEventsBloc(get<_i41.INotificationRepository>()));
  gh.factory<_i45.NotificationsEventsUpdateBloc>(() =>
      _i45.NotificationsEventsUpdateBloc(get<_i41.INotificationRepository>()));
  gh.factory<_i46.NotificationsInvitationsBloc>(() =>
      _i46.NotificationsInvitationsBloc(get<_i41.INotificationRepository>()));
  gh.factory<_i47.NotificationsUnseenBloc>(
      () => _i47.NotificationsUnseenBloc(get<_i41.INotificationRepository>()));
  gh.factory<_i48.PlanningBloc>(
      () => _i48.PlanningBloc(get<_i39.IChildrenLookupRepository>()));
  gh.factory<_i49.SetupFamilyBloc>(() => _i49.SetupFamilyBloc(
      get<_i15.IUserRepository>(),
      get<_i29.ISpouseProposalRepository>(),
      get<_i41.INotificationRepository>(),
      get<_i23.AnalyticsSvc>()));
  gh.factory<_i50.TrustedUserFormBloc>(() => _i50.TrustedUserFormBloc(
      get<_i25.IFamilyRepository>(),
      get<_i41.INotificationRepository>(),
      get<_i11.IAuthFacade>(),
      get<_i15.IUserRepository>(),
      get<_i23.AnalyticsSvc>()));
  gh.factory<_i51.ChildrenFormBloc>(() => _i51.ChildrenFormBloc(
      get<_i25.IFamilyRepository>(), get<_i41.INotificationRepository>()));
  gh.factory<_i52.ChildrenLookupBloc>(() => _i52.ChildrenLookupBloc(
      get<_i11.IAuthFacade>(),
      get<_i15.IUserRepository>(),
      get<_i25.IFamilyRepository>(),
      get<_i39.IChildrenLookupRepository>(),
      get<_i41.INotificationRepository>()));
  gh.factory<_i53.ChildrenLookupDetailsBloc>(() =>
      _i53.ChildrenLookupDetailsBloc(
          get<_i11.IAuthFacade>(),
          get<_i15.IUserRepository>(),
          get<_i39.IChildrenLookupRepository>(),
          get<_i41.INotificationRepository>()));
  gh.factory<_i54.DemandsBloc>(
      () => _i54.DemandsBloc(get<_i39.IChildrenLookupRepository>()));
  return get;
}

class _$FirebaseInjectableModule extends _i55.FirebaseInjectableModule {}

class _$GeocodingInjectableModule extends _i56.GeocodingInjectableModule {}
