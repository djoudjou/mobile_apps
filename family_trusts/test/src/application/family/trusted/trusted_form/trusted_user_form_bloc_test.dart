import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/family/trusted/bloc.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/family/trusted_user/value_objects.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:familytrusts/src/domain/notification/value_objects.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:mockito/mockito.dart';

import 'package:mockito/annotations.dart';

import 'trusted_user_form_bloc_test.mocks.dart';

class MockAuthFacade extends Mock implements IAuthFacade {}

class MockUserRepository extends Mock implements IUserRepository {}

class MockFamilyRepository extends Mock implements IFamilyRepository {}

class MockNotificationRepository extends Mock
    implements INotificationRepository {}

class MockAnalyticsSvc extends Mock implements AnalyticsSvc {}

@GenerateMocks([
  MockAuthFacade,
  MockUserRepository,
  MockFamilyRepository,
  MockNotificationRepository,
  MockAnalyticsSvc,
])
void main() {
  MockAuthFacade? mockAuthFacade;
  MockUserRepository? mockUserRepository;
  MockFamilyRepository? mockFamilyRepository;
  MockNotificationRepository? mockNotificationRepository;
  MockAnalyticsSvc? mockAnalyticsSvc;

  setUp(
    () {
      mockAuthFacade = MockMockAuthFacade();
      mockUserRepository = MockMockUserRepository();
      mockFamilyRepository = MockMockFamilyRepository();
      mockNotificationRepository = MockMockNotificationRepository();
      mockAnalyticsSvc = MockMockAnalyticsSvc();
    },
  );

  tearDown(() {});

  group('TrustedUserForm', () {
    final User berangere = User(
        id: "BGU",
        familyId: "DJOUTSOP_ID",
        email: EmailAddress("berangere.guilley@me.com"),
        name: Name("Guilley"),
        surname: Surname("Bérangère"),
        photoUrl: "https://toto.jpeg");
    final User aurelien = User(
      id: "ADJ",
      familyId: "DJOUTSOP_ID",
      email: EmailAddress("a.djoutsop@gmail.com"),
      name: Name("Djoutsop"),
      surname: Surname("Aurélien"),
      photoUrl: "https://toto.jpeg",
    );

    final TimestampVo now = TimestampVo.now();

    blocTest(
      'emits [addTrusted] should add trusted User',
      build: () {
        when(mockAuthFacade!.getSignedInUserId())
            .thenAnswer((_) => some(aurelien.id!));

        when(mockUserRepository!.getUser(aurelien.id!))
            .thenAnswer((_) async => right(aurelien));

        when(mockFamilyRepository!.addTrustedUser(
            familyId: aurelien.familyId!,
            trustedUser: TrustedUser(
              user: berangere,
              since: now,
            ))).thenAnswer((_) async => right(unit));

        when(mockNotificationRepository!.createEvent(
            aurelien.id!,
            Event(
              date: now,
              seen: false,
              from: aurelien,
              to: berangere,
              type: EventType.trustAdded(),
              fromConnectedUser: true,
              subject: '',
            ))).thenAnswer((_) async => right(unit));

        return TrustedUserFormBloc(
          mockFamilyRepository!,
          mockNotificationRepository!,
          mockAuthFacade!,
          mockUserRepository!,
          mockAnalyticsSvc!,
        );
      },
      act: (TrustedUserFormBloc bloc) =>
          bloc.add(TrustedUserFormEvent.addTrustedUser(
        currentUser: aurelien,
        userToAdd: berangere,
        time: now,
      )),
      expect: () => [
        TrustedUserFormState(
          state: TrustedUserFormStateEnum.adding,
          addTrustedUserFailureOrSuccessOption: none(),
          searchUserFailureOrSuccessOption: none(),
        ),
        TrustedUserFormState(
          state: TrustedUserFormStateEnum.none,
          addTrustedUserFailureOrSuccessOption: some(right(unit)),
          searchUserFailureOrSuccessOption: none(),
        ),
      ],
    );
  });
}
