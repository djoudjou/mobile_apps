import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:familytrusts/src/domain/family/locations/location_success.dart';
import 'package:familytrusts/src/domain/family/locations/value_objects.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:familytrusts/src/domain/notification/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import 'package:quiver/strings.dart' as quiver;

import 'bloc.dart';

@injectable
class LocationFormBloc extends Bloc<LocationFormEvent, LocationFormState> {
  final IFamilyRepository _familyRepository;
  final INotificationRepository _notificationRepository;
  final AnalyticsSvc _analyticsSvc;

  LocationFormBloc(
    this._familyRepository,
    this._notificationRepository,
    this._analyticsSvc,
  ) : super(LocationFormState.initial());

  @override
  Stream<LocationFormState> mapEventToState(LocationFormEvent event) async* {
    yield* event.map(
      pictureUrlChanged: (PictureUrlChanged e) async* {
        yield state.copyWith(
          photoUrl: e.pickedFileUrl,
          failureOrSuccessOption: none(),
        );
      },
      picturePathChanged: (PicturePathChanged e) async* {
        yield state.copyWith(
          imagePath: e.pickedFilePath,
          failureOrSuccessOption: none(),
        );
      },
      latLngChanged: (LatLngChanged e) async* {
        yield state.copyWith(
          gpsPosition: GpsPosition.fromPosition(
            latitude: e.position.latitude,
            longitude: e.position.longitude,
          ),
          failureOrSuccessOption: none(),
        );
      },
      titleChanged: (TitleChanged e) async* {
        yield state.copyWith(
          title: Name(e.title),
          failureOrSuccessOption: none(),
        );
      },
      addressChanged: (AddresChanged e) async* {
        yield state.copyWith(
          address: Address(e.address),
          failureOrSuccessOption: none(),
        );
      },
      noteChanged: (NoteChanged e) async* {
        yield state.copyWith(
          note: NoteBody(e.note),
          failureOrSuccessOption: none(),
        );
      },
      init: (LocationInit e) async* {
        final location = e.location;
        Position? position = await Geolocator.getLastKnownPosition();
        // if position is null it will look to geolocator
        position ??= await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        final LocationFormState newState = state.copyWith(
          id: e.location.id,
          familyId: e.familyId,
          photoUrl: location.photoUrl,
          address: location.address,
          title: location.title,
          note: location.note,
          isInitializing: false,
          currentPosition: GpsPosition.fromPosition(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          gpsPosition: e.location.gpsPosition,
          failureOrSuccessOption: none(),
        );
        yield newState;
      },
      saveLocation: (event) {
        return _mapSaveLocationToState(event);
      },
      deleteLocation: (event) {
        return _mapDeleteLocationToState(event);
      },
    );
  }

  Stream<LocationFormState> _mapSaveLocationToState(SaveLocation event) async* {
    try {
      yield state.copyWith(
        state: quiver.isNotBlank(event.location.id)
            ? LocationFormStateEnum.updating
            : LocationFormStateEnum.adding,
        failureOrSuccessOption: none(),
      );
      final User user = event.connectedUser;

      final Either<LocationFailure, Unit> result =
          await _familyRepository.addUpdateLocation(
        familyId: user.familyId!,
        location: event.location,
        pickedFilePath: event.pickedFilePath,
      );

      yield result.fold(
        (failure) {
          _analyticsSvc.debug("error during location save/update $failure");
          return state.copyWith(
              state: LocationFormStateEnum.none,
              failureOrSuccessOption: some(left(
                quiver.isNotBlank(event.location.id)
                    ? const LocationFailure.unableToUpdate()
                    : const LocationFailure.unableToCreate(),
              )));
        },
        (success) {
          return state.copyWith(
            state: LocationFormStateEnum.none,
            failureOrSuccessOption: some(right(
              quiver.isNotBlank(event.location.id)
                  ? const LocationSuccess.updateSuccess()
                  : const LocationSuccess.createSuccess(),
            )),
          );
        },
      );

      if (result.isRight()) {
        final eventLocation = Event(
          date: TimestampVo.now(),
          seen: false,
          from: user,
          to: user,
          type: quiver.isNotBlank(event.location.id)
              ? EventType.childUpdated()
              : EventType.childAdded(),
          subject: event.location.title.getOrCrash(),
          fromConnectedUser: true,
        );
        await _notificationRepository.createEvent(
          user.id!,
          eventLocation,
        );
        if (quiver.isNotBlank(user.spouse)) {
          await _notificationRepository.createEvent(
            user.spouse!,
            eventLocation,
          );
        }
      }
    } catch (_) {
      yield state.copyWith(
        state: LocationFormStateEnum.none,
        failureOrSuccessOption: some(left(
          quiver.isNotBlank(event.location.id)
              ? const LocationFailure.unableToUpdate()
              : const LocationFailure.unableToCreate(),
        )),
      );
    }
  }

  Stream<LocationFormState> _mapDeleteLocationToState(
      DeleteLocation event) async* {
    try {
      yield state.copyWith(
        state: LocationFormStateEnum.deleting,
        failureOrSuccessOption: none(),
      );
      final User user = event.connectedUser;
      final Either<LocationFailure, Unit> result =
          await _familyRepository.deleteLocation(
        familyId: user.familyId!,
        location: event.location,
      );
      yield result.fold(
        (failure) {
          _analyticsSvc.debug("error during location suppression $failure");
          return state.copyWith(
            state: LocationFormStateEnum.none,
            failureOrSuccessOption: some(left(failure)),
          );
        },
        (success) {
          return state.copyWith(
            state: LocationFormStateEnum.none,
            failureOrSuccessOption:
                some(right(const LocationSuccess.deleteSucces())),
          );
        },
      );

      if (result.isRight()) {
        await createDeleteEvent(user, event);
      }
    } catch (e) {
      _analyticsSvc.debug("error during location suppression $e");
      yield state.copyWith(
        state: LocationFormStateEnum.none,
        failureOrSuccessOption:
            some(left(const LocationFailure.unableToDelete())),
      );
    }
  }

  Future<void> createDeleteEvent(User user, DeleteLocation event) async {
    final eventLocationDeleted = Event(
      date: TimestampVo.now(),
      seen: false,
      from: user,
      to: user,
      subject: event.location.title.getOrCrash(),
      type: EventType.childRemoved(),
      fromConnectedUser: true,
    );
    await _notificationRepository.createEvent(
      user.id!,
      eventLocationDeleted,
    );

    if (quiver.isNotBlank(user.spouse)) {
      await _notificationRepository.createEvent(
        user.spouse!,
        eventLocationDeleted,
      );
    }
  }
}
