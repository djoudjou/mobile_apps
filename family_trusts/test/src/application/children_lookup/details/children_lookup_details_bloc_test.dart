import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/children_lookup/details/bloc.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/notification/i_familyevent_repository.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'children_lookup_details_bloc_test.mocks.dart';

class MockAuthFacade extends Mock implements IAuthFacade {}

class MockUserRepository extends Mock implements IUserRepository {}

class MockChildrenLookupRepository extends Mock
    implements IChildrenLookupRepository {}

class MockNotificationRepository extends Mock
    implements IFamilyEventRepository {}

@GenerateMocks([
  MockAuthFacade,
  MockUserRepository,
  MockChildrenLookupRepository,
  MockNotificationRepository
])
void main() {
  MockAuthFacade? mockAuthFacade;
  MockUserRepository? mockUserRepository;
  MockChildrenLookupRepository? mockChildrenLookupRepository;
  MockNotificationRepository? mockNotificationRepository;

  setUp(
    () {
      mockAuthFacade = MockMockAuthFacade();
      mockUserRepository = MockMockUserRepository();
      mockChildrenLookupRepository = MockMockChildrenLookupRepository();
      mockNotificationRepository = MockMockNotificationRepository();
    },
  );

  tearDown(() {});

  group('ChildrenLookupDetails', () {
    final User berangere = User(
      id: "BGU",
      family: Family(
        id: "DJOUTSOP_ID",
        name: Name("DJOUTSOP"),
      ),
      email: EmailAddress("berangere.guilley@me.com"),
      name: Name("Guilley"),
      surname: Surname("Bérangère"),
      photoUrl: "https://toto.jpeg",
    );
    final User aurelien = User(
      id: "ADJ",
      family: Family(
        id: "DJOUTSOP_ID",
        name: Name("DJOUTSOP"),
      ),
      email: EmailAddress("a.djoutsop@gmail.com"),
      name: Name("Djoutsop"),
      surname: Surname("Aurélien"),
      photoUrl: "https://toto.jpeg",
      spouse: berangere.id,
    );

    final Child liam = Child(
      id: "LIAM_ID_1",
      photoUrl: "",
      name: Name("Djoutsop"),
      surname: Surname("Liam"),
      birthday: Birthday.fromValue("24/11/2014"),
    );

    final Location ecoleEmileBouton = Location(
      id: "EMILE_BOUTON_ID",
      note: NoteBody("...."),
      title: Name("Ecole émile bouton"),
      address: Address("30 bis route de corbeil 91360 Villemoisson sur orge"),
      photoUrl: "",
      gpsPosition: GpsPosition.fromPosition(
        latitude: 0.0,
        longitude: 0.0,
      ),
    );

    final RendezVous rendezVous = RendezVous.fromDate(DateTime.now());

    final recupererLiam = ChildrenLookup(
      id: "ChildrenLookup_1",
      issuer: aurelien,
//personInCharge: berangere,
      child: liam,
      location: ecoleEmileBouton,
      rendezVous: rendezVous,
      noteBody: NoteBody("...."),
      creationDate: TimestampVo.now(),
      state: MissionState.waiting(),
      trustedUsers: [aurelien.id!, berangere.id!],
    );

    final Option<Either<ChildrenLookupFailure, List<ChildrenLookupHistory>>>
        optionEitherChildrenLookupHistoryNone = none();
    final Option<Either<ChildrenLookupFailure, Unit>>
        failureOrSuccessOptionNone = none();

    final Either<ChildrenLookupFailure, ChildrenLookup> eitherChildrenLookup_1 =
        right(recupererLiam);

    blocTest(
      'emits [init] with issuer=connected user, should return a valid ChildrenDetails',
      build: () {
        when(
          mockChildrenLookupRepository!
              .watchChildrenLookup(childrenLookupId: recupererLiam.id!),
        ).thenAnswer((_) => Stream.fromIterable([eitherChildrenLookup_1]));

        when(
          mockChildrenLookupRepository!.getChildrenLookupHistories(
            childrenLookupId: recupererLiam.id!,
          ),
        ).thenAnswer((_) => const Stream.empty());

        when(mockAuthFacade!.getSignedInUserId())
            .thenAnswer((_) => some(aurelien.id!));

        when(mockUserRepository!.getUser(aurelien.id!))
            .thenAnswer((_) async => right(aurelien));

        return ChildrenLookupDetailsBloc(
          mockAuthFacade!,
          mockUserRepository!,
          mockChildrenLookupRepository!,
          mockNotificationRepository!,
        );
      },
      act: (ChildrenLookupDetailsBloc bloc) => bloc
          .add(ChildrenLookupDetailsEvent.init(childrenLookup: recupererLiam)),
      expect: () => [
        ChildrenLookupDetailsState(
          showErrorMessages: false,
          isInitializing: true,
          isSubmitting: false,
          isIssuer: false,
          isTrustedUser: false,
          displayDeclineButton: false,
          displayAcceptButton: false,
          displayEndedButton: false,
          displayCancelButton: false,
          failureOrSuccessOption: failureOrSuccessOptionNone,
          optionEitherChildrenLookupHistory:
              optionEitherChildrenLookupHistoryNone,
        ),
        ChildrenLookupDetailsState(
          showErrorMessages: false,
          isInitializing: false,
          isSubmitting: false,
          isIssuer: true,
          isTrustedUser: true,
          displayDeclineButton: false,
          displayAcceptButton: false,
          displayEndedButton: false,
          displayCancelButton: true,
          failureOrSuccessOption: none(),
          optionEitherChildrenLookupHistory:
              optionEitherChildrenLookupHistoryNone,
          childrenLookup: recupererLiam,
        ),
      ],
    );

    blocTest(
      'emits [init] with issuer<>connected user, should return a valid ChildrenDetails',
      build: () {
        when(
          mockChildrenLookupRepository!
              .watchChildrenLookup(childrenLookupId: recupererLiam.id!),
        ).thenAnswer((_) => Stream.fromIterable([eitherChildrenLookup_1]));

        when(
          mockChildrenLookupRepository!.getChildrenLookupHistories(
            childrenLookupId: recupererLiam.id!,
          ),
        ).thenAnswer((_) => const Stream.empty());

        when(mockAuthFacade!.getSignedInUserId())
            .thenAnswer((_) => some(berangere.id!));

        when(mockUserRepository!.getUser(berangere.id!))
            .thenAnswer((_) async => right(berangere));

        return ChildrenLookupDetailsBloc(
          mockAuthFacade!,
          mockUserRepository!,
          mockChildrenLookupRepository!,
          mockNotificationRepository!,
        );
      },
      act: (ChildrenLookupDetailsBloc bloc) => bloc
          .add(ChildrenLookupDetailsEvent.init(childrenLookup: recupererLiam)),
      expect: () => [
        ChildrenLookupDetailsState(
          showErrorMessages: false,
          isInitializing: true,
          isSubmitting: false,
          isIssuer: false,
          isTrustedUser: false,
          displayDeclineButton: false,
          displayAcceptButton: false,
          displayEndedButton: false,
          displayCancelButton: false,
          failureOrSuccessOption: failureOrSuccessOptionNone,
          optionEitherChildrenLookupHistory:
              optionEitherChildrenLookupHistoryNone,
        ),
        ChildrenLookupDetailsState(
          showErrorMessages: false,
          isInitializing: false,
          isSubmitting: false,
          isIssuer: false,
          isTrustedUser: true,
          displayDeclineButton: false,
          displayAcceptButton: true,
          displayEndedButton: false,
          displayCancelButton: false,
          failureOrSuccessOption: none(),
          optionEitherChildrenLookupHistory:
              optionEitherChildrenLookupHistoryNone,
          childrenLookup: recupererLiam,
        ),
      ],
    );
  });
}
