// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i6;
import 'package:firebase_analytics/firebase_analytics.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i5;
import 'package:firebase_messaging/firebase_messaging.dart' as _i7;
import 'package:firebase_storage/firebase_storage.dart' as _i34;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as _i3;
import 'package:geoflutterfire/geoflutterfire.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_geocoding/google_geocoding.dart' as _i9;
import 'package:google_sign_in/google_sign_in.dart' as _i10;
import 'package:injectable/injectable.dart' as _i2;

import 'src/application/children_lookup/children_lookup_bloc.dart' as _i41;
import 'src/application/children_lookup/details/children_lookup_details_bloc.dart'
    as _i42;
import 'src/application/demands/demands_bloc.dart' as _i43;
import 'src/application/family/children/form/children_form_bloc.dart' as _i40;
import 'src/application/family/children/watcher/children_bloc.dart' as _i39;
import 'src/application/family/location/form/location_form_bloc.dart' as _i47;
import 'src/application/family/location/watcher/locations_bloc.dart' as _i27;
import 'src/application/family/trusted/trusted_form/trusted_user_form_bloc.dart'
    as _i49;
import 'src/application/family/trusted/trusted_watcher/trusted_user_watcher_bloc.dart'
    as _i37;
import 'src/application/home/tab/tab_bloc.dart' as _i36;
import 'src/application/join_proposal/family_join_proposal_bloc.dart' as _i44;
import 'src/application/join_proposal/issuer_join_proposal_bloc.dart' as _i26;
import 'src/application/messages/messages_bloc.dart' as _i48;
import 'src/application/notifications/notifications_events/notifications_events_bloc.dart'
    as _i29;
import 'src/application/notifications/notifications_events/notifications_events_update_bloc.dart'
    as _i30;
import 'src/application/notifications/tab/notification_tab_bloc.dart' as _i28;
import 'src/application/notifications/unseen/notifications_unseen_bloc.dart'
    as _i31;
import 'src/application/planning/planning_bloc.dart' as _i32;
import 'src/application/profil/tab/profil_tab_bloc.dart' as _i33;
import 'src/application/search_user/search_user_bloc.dart' as _i35;
import 'src/domain/auth/i_auth_facade.dart' as _i11;
import 'src/domain/children_lookup/i_children_lookup_repository.dart' as _i13;
import 'src/domain/error/i_error_service.dart' as _i16;
import 'src/domain/family/i_family_repository.dart' as _i20;
import 'src/domain/join_proposal/i_join_proposal_repository.dart' as _i22;
import 'src/domain/messages/i_messages_repository.dart' as _i45;
import 'src/domain/notification/i_familyevent_repository.dart' as _i18;
import 'src/domain/user/i_user_repository.dart' as _i24;
import 'src/helper/analytics_svc.dart' as _i38;
import 'src/infrastructure/auth/firebase_auth_facade.dart' as _i12;
import 'src/infrastructure/children_lookup/api_children_lookup_repository.dart'
    as _i14;
import 'src/infrastructure/core/firebase_injectable_module.dart' as _i50;
import 'src/infrastructure/core/geocoding_injectable_module.dart' as _i51;
import 'src/infrastructure/family/api_family_repository.dart' as _i21;
import 'src/infrastructure/family_event/api_family_event_repository.dart'
    as _i19;
import 'src/infrastructure/http/api_service.dart' as _i15;
import 'src/infrastructure/join_proposal/api_join_proposal_repository.dart'
    as _i23;
import 'src/infrastructure/messages/firebase_messages_repository.dart' as _i46;
import 'src/infrastructure/user/api_user_repository.dart' as _i25;
import 'src/services/error/error_service.dart' as _i17;

const String _prod = 'prod';
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
  gh.lazySingleton<_i13.IChildrenLookupRepository>(
      () => _i14.ApiChildrenLookupRepository(get<_i15.ApiService>()),
      registerFor: {_prod});
  gh.lazySingleton<_i16.IErrorService>(() => _i17.SentryErrorService());
  gh.lazySingleton<_i18.IFamilyEventRepository>(
      () => _i19.ApiFamilyEventRepository(get<_i15.ApiService>()),
      registerFor: {_prod});
  gh.lazySingleton<_i20.IFamilyRepository>(
      () => _i21.ApiFamilyRepository(get<_i15.ApiService>()),
      registerFor: {_prod});
  gh.lazySingleton<_i22.IJoinProposalRepository>(
      () => _i23.ApiJoinProposalRepository(get<_i15.ApiService>()),
      registerFor: {_prod});
  gh.lazySingleton<_i24.IUserRepository>(
      () => _i25.ApiUserRepository(get<_i15.ApiService>()),
      registerFor: {_prod});
  gh.factory<_i26.IssuerJoinProposalBloc>(
      () => _i26.IssuerJoinProposalBloc(get<_i22.IJoinProposalRepository>()));
  gh.factory<_i27.LocationsBloc>(
      () => _i27.LocationsBloc(get<_i20.IFamilyRepository>()));
  gh.factory<_i28.NotificationTabBloc>(() => _i28.NotificationTabBloc());
  gh.factory<_i29.NotificationsEventsBloc>(
      () => _i29.NotificationsEventsBloc(get<_i18.IFamilyEventRepository>()));
  gh.factory<_i30.NotificationsEventsUpdateBloc>(() =>
      _i30.NotificationsEventsUpdateBloc(get<_i18.IFamilyEventRepository>()));
  gh.factory<_i31.NotificationsUnseenBloc>(
      () => _i31.NotificationsUnseenBloc(get<_i18.IFamilyEventRepository>()));
  gh.factory<_i32.PlanningBloc>(
      () => _i32.PlanningBloc(get<_i13.IChildrenLookupRepository>()));
  gh.factory<_i33.ProfileTabBloc>(() => _i33.ProfileTabBloc());
  gh.lazySingleton<_i34.Reference>(
      () => firebaseInjectableModule.storageReference);
  gh.factory<_i35.SearchUserBloc>(() => _i35.SearchUserBloc(
      get<_i24.IUserRepository>(), get<_i11.IAuthFacade>()));
  gh.factory<_i36.TabBloc>(() => _i36.TabBloc());
  gh.factory<_i37.TrustedUserWatcherBloc>(
      () => _i37.TrustedUserWatcherBloc(get<_i20.IFamilyRepository>()));
  gh.factory<_i38.AnalyticsSvc>(() => _i38.AnalyticsSvc(
      get<_i4.FirebaseAnalytics>(), get<_i16.IErrorService>()));
  gh.factory<_i39.ChildrenBloc>(
      () => _i39.ChildrenBloc(get<_i20.IFamilyRepository>()));
  gh.factory<_i40.ChildrenFormBloc>(
      () => _i40.ChildrenFormBloc(get<_i20.IFamilyRepository>()));
  gh.factory<_i41.ChildrenLookupBloc>(() => _i41.ChildrenLookupBloc(
      get<_i20.IFamilyRepository>(), get<_i13.IChildrenLookupRepository>()));
  gh.factory<_i42.ChildrenLookupDetailsBloc>(() =>
      _i42.ChildrenLookupDetailsBloc(get<_i13.IChildrenLookupRepository>()));
  gh.factory<_i43.DemandsBloc>(
      () => _i43.DemandsBloc(get<_i13.IChildrenLookupRepository>()));
  gh.factory<_i44.FamilyJoinProposalBloc>(
      () => _i44.FamilyJoinProposalBloc(get<_i22.IJoinProposalRepository>()));
  gh.lazySingleton<_i45.IMessagesRepository>(() =>
      _i46.FirebaseMessagesRepository(get<_i7.FirebaseMessaging>(),
          get<_i16.IErrorService>(), get<_i24.IUserRepository>()));
  gh.factory<_i47.LocationFormBloc>(() => _i47.LocationFormBloc(
      get<_i20.IFamilyRepository>(), get<_i38.AnalyticsSvc>()));
  gh.factory<_i48.MessagesBloc>(() => _i48.MessagesBloc(
      get<_i45.IMessagesRepository>(), get<_i16.IErrorService>()));
  gh.factory<_i49.TrustedUserFormBloc>(() => _i49.TrustedUserFormBloc(
      get<_i20.IFamilyRepository>(), get<_i38.AnalyticsSvc>()));
  return get;
}

class _$FirebaseInjectableModule extends _i50.FirebaseInjectableModule {}

class _$GeocodingInjectableModule extends _i51.GeocodingInjectableModule {}
