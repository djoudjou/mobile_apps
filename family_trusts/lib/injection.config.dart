// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i6;
import 'package:familytrusts/src/application/children_lookup/children_lookup_bloc.dart'
    as _i38;
import 'package:familytrusts/src/application/children_lookup/details/children_lookup_details_bloc.dart'
    as _i39;
import 'package:familytrusts/src/application/connection/connection_bloc.dart'
    as _i40;
import 'package:familytrusts/src/application/demands/demands_bloc.dart' as _i41;
import 'package:familytrusts/src/application/family/children/form/children_form_bloc.dart'
    as _i37;
import 'package:familytrusts/src/application/family/children/watcher/children_bloc.dart'
    as _i36;
import 'package:familytrusts/src/application/family/location/form/location_form_bloc.dart'
    as _i47;
import 'package:familytrusts/src/application/family/location/watcher/locations_bloc.dart'
    as _i25;
import 'package:familytrusts/src/application/family/trusted/trusted_form/trusted_user_form_bloc.dart'
    as _i50;
import 'package:familytrusts/src/application/family/trusted/trusted_watcher/trusted_user_watcher_bloc.dart'
    as _i34;
import 'package:familytrusts/src/application/home/tab/tab_bloc.dart' as _i33;
import 'package:familytrusts/src/application/join_proposal/family_join_proposal_bloc.dart'
    as _i42;
import 'package:familytrusts/src/application/join_proposal/issuer_join_proposal_bloc.dart'
    as _i24;
import 'package:familytrusts/src/application/messages/messages_bloc.dart'
    as _i48;
import 'package:familytrusts/src/application/notifications/notifications_events/notifications_events_bloc.dart'
    as _i27;
import 'package:familytrusts/src/application/notifications/notifications_events/notifications_events_update_bloc.dart'
    as _i28;
import 'package:familytrusts/src/application/notifications/tab/notification_tab_bloc.dart'
    as _i26;
import 'package:familytrusts/src/application/notifications/unseen/notifications_unseen_bloc.dart'
    as _i29;
import 'package:familytrusts/src/application/planning/planning_bloc.dart'
    as _i30;
import 'package:familytrusts/src/application/profil/tab/profil_tab_bloc.dart'
    as _i31;
import 'package:familytrusts/src/application/search_user/search_user_bloc.dart'
    as _i49;
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart' as _i43;
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart'
    as _i10;
import 'package:familytrusts/src/domain/error/i_error_service.dart' as _i13;
import 'package:familytrusts/src/domain/family/i_family_repository.dart'
    as _i17;
import 'package:familytrusts/src/domain/join_proposal/i_join_proposal_repository.dart'
    as _i19;
import 'package:familytrusts/src/domain/messages/i_messages_repository.dart'
    as _i45;
import 'package:familytrusts/src/domain/notification/i_familyevent_repository.dart'
    as _i15;
import 'package:familytrusts/src/domain/user/i_user_repository.dart' as _i22;
import 'package:familytrusts/src/helper/analytics_svc.dart' as _i35;
import 'package:familytrusts/src/infrastructure/auth/firebase_auth_facade.dart'
    as _i44;
import 'package:familytrusts/src/infrastructure/children_lookup/api_children_lookup_repository.dart'
    as _i11;
import 'package:familytrusts/src/infrastructure/core/firebase_injectable_module.dart'
    as _i52;
import 'package:familytrusts/src/infrastructure/core/geocoding_injectable_module.dart'
    as _i51;
import 'package:familytrusts/src/infrastructure/family/api_family_repository.dart'
    as _i18;
import 'package:familytrusts/src/infrastructure/family_event/api_family_event_repository.dart'
    as _i16;
import 'package:familytrusts/src/infrastructure/http/api_service.dart' as _i12;
import 'package:familytrusts/src/infrastructure/http/api_service_http.dart'
    as _i21;
import 'package:familytrusts/src/infrastructure/join_proposal/api_join_proposal_repository.dart'
    as _i20;
import 'package:familytrusts/src/infrastructure/messages/firebase_messages_repository.dart'
    as _i46;
import 'package:familytrusts/src/infrastructure/user/api_user_repository.dart'
    as _i23;
import 'package:familytrusts/src/services/error/error_service.dart' as _i14;
import 'package:firebase_analytics/firebase_analytics.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i5;
import 'package:firebase_messaging/firebase_messaging.dart' as _i7;
import 'package:firebase_storage/firebase_storage.dart' as _i32;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_geocoding/google_geocoding.dart' as _i8;
import 'package:google_sign_in/google_sign_in.dart' as _i9;
import 'package:injectable/injectable.dart' as _i2;

const String _prod = 'prod';

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
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
    gh.lazySingleton<_i7.FirebaseMessaging>(
        () => firebaseInjectableModule.fire);
    gh.lazySingleton<_i8.GoogleGeocoding>(
        () => geocodingInjectableModule.googleGeocoding);
    gh.lazySingleton<_i9.GoogleSignIn>(
        () => firebaseInjectableModule.googleSignIn);
    gh.lazySingleton<_i10.IChildrenLookupRepository>(
      () => _i11.ApiChildrenLookupRepository(gh<_i12.ApiService>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i13.IErrorService>(() => _i14.SentryErrorService());
    gh.lazySingleton<_i15.IFamilyEventRepository>(
      () => _i16.ApiFamilyEventRepository(gh<_i12.ApiService>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i17.IFamilyRepository>(
      () => _i18.ApiFamilyRepository(gh<_i12.ApiService>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i19.IJoinProposalRepository>(
      () => _i20.ApiJoinProposalRepository(
        gh<_i12.ApiService>(),
        gh<_i21.ApiServiceHttp>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i22.IUserRepository>(
      () => _i23.ApiUserRepository(gh<_i12.ApiService>()),
      registerFor: {_prod},
    );
    gh.factory<_i24.IssuerJoinProposalBloc>(
        () => _i24.IssuerJoinProposalBloc(gh<_i19.IJoinProposalRepository>()));
    gh.factory<_i25.LocationsBloc>(
        () => _i25.LocationsBloc(gh<_i17.IFamilyRepository>()));
    gh.factory<_i26.NotificationTabBloc>(() => _i26.NotificationTabBloc());
    gh.factory<_i27.NotificationsEventsBloc>(
        () => _i27.NotificationsEventsBloc(gh<_i15.IFamilyEventRepository>()));
    gh.factory<_i28.NotificationsEventsUpdateBloc>(() =>
        _i28.NotificationsEventsUpdateBloc(gh<_i15.IFamilyEventRepository>()));
    gh.factory<_i29.NotificationsUnseenBloc>(
        () => _i29.NotificationsUnseenBloc(gh<_i15.IFamilyEventRepository>()));
    gh.factory<_i30.PlanningBloc>(() => _i30.PlanningBloc(
          gh<_i10.IChildrenLookupRepository>(),
          gh<_i22.IUserRepository>(),
        ));
    gh.factory<_i31.ProfileTabBloc>(() => _i31.ProfileTabBloc());
    gh.lazySingleton<_i32.Reference>(
        () => firebaseInjectableModule.storageReference);
    gh.factory<_i33.TabBloc>(() => _i33.TabBloc());
    gh.factory<_i34.TrustedUserWatcherBloc>(
        () => _i34.TrustedUserWatcherBloc(gh<_i17.IFamilyRepository>()));
    gh.factory<_i35.AnalyticsSvc>(() => _i35.AnalyticsSvc(
          gh<_i4.FirebaseAnalytics>(),
          gh<_i13.IErrorService>(),
        ));
    gh.factory<_i36.ChildrenBloc>(
        () => _i36.ChildrenBloc(gh<_i17.IFamilyRepository>()));
    gh.factory<_i37.ChildrenFormBloc>(
        () => _i37.ChildrenFormBloc(gh<_i17.IFamilyRepository>()));
    gh.factory<_i38.ChildrenLookupBloc>(() => _i38.ChildrenLookupBloc(
          gh<_i17.IFamilyRepository>(),
          gh<_i10.IChildrenLookupRepository>(),
        ));
    gh.factory<_i39.ChildrenLookupDetailsBloc>(() =>
        _i39.ChildrenLookupDetailsBloc(gh<_i10.IChildrenLookupRepository>()));
    gh.factory<_i40.ConnectBloc>(
        () => _i40.ConnectBloc(gh<_i13.IErrorService>()));
    gh.factory<_i41.DemandsBloc>(
        () => _i41.DemandsBloc(gh<_i10.IChildrenLookupRepository>()));
    gh.factory<_i42.FamilyJoinProposalBloc>(
        () => _i42.FamilyJoinProposalBloc(gh<_i19.IJoinProposalRepository>()));
    gh.lazySingleton<_i43.IAuthFacade>(() => _i44.FirebaseAuthFacade(
          gh<_i5.FirebaseAuth>(),
          gh<_i9.GoogleSignIn>(),
          gh<_i3.FacebookAuth>(),
          gh<_i13.IErrorService>(),
        ));
    gh.lazySingleton<_i45.IMessagesRepository>(
        () => _i46.FirebaseMessagesRepository(
              gh<_i7.FirebaseMessaging>(),
              gh<_i13.IErrorService>(),
              gh<_i22.IUserRepository>(),
            ));
    gh.factory<_i47.LocationFormBloc>(() => _i47.LocationFormBloc(
          gh<_i17.IFamilyRepository>(),
          gh<_i35.AnalyticsSvc>(),
        ));
    gh.factory<_i48.MessagesBloc>(() => _i48.MessagesBloc(
          gh<_i45.IMessagesRepository>(),
          gh<_i13.IErrorService>(),
        ));
    gh.factory<_i49.SearchUserBloc>(() => _i49.SearchUserBloc(
          gh<_i22.IUserRepository>(),
          gh<_i43.IAuthFacade>(),
        ));
    gh.factory<_i50.TrustedUserFormBloc>(() => _i50.TrustedUserFormBloc(
          gh<_i17.IFamilyRepository>(),
          gh<_i35.AnalyticsSvc>(),
        ));
    return this;
  }
}

class _$GeocodingInjectableModule extends _i51.GeocodingInjectableModule {}

class _$FirebaseInjectableModule extends _i52.FirebaseInjectableModule {}
