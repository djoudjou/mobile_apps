import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/family_search/search_family_event.dart';
import 'package:familytrusts/src/application/family_search/search_family_state.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/family/family_failure.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/search_family_failure.dart';
import 'package:familytrusts/src/helper/bloc_helper.dart';
import 'package:quiver/strings.dart' as quiver;

class SearchFamilyBloc extends Bloc<SearchFamilyEvent, SearchFamilyState> {
  final IFamilyRepository _familyRepository;
  static const Duration duration = Duration(milliseconds: 500);

  SearchFamilyBloc(this._familyRepository)
      : super(SearchFamilyState.initial()) {
    on<FamilyLookupChanged>(
      _mapFamilyLookupChanged,
      transformer: debounce(duration),
    );
  }

  SearchFamilyFailure mapFamilyFailureToSearchFamilyFailure(
    FamilyFailure failure,
  ) {
    return failure.map(
      insufficientPermission: (_) => const SearchFamilyFailure.serverError(),
      unknownFamily: (_) => const SearchFamilyFailure.serverError(),
      unableToDelete: (_) => const SearchFamilyFailure.serverError(),
      unableToUpdate: (_) => const SearchFamilyFailure.serverError(),
      unexpected: (_) => const SearchFamilyFailure.serverError(),
      unableToCreate: (_) => const SearchFamilyFailure.serverError(),
    );
  }

  Future<void> _mapFamilyLookupChanged(
    FamilyLookupChanged event,
    Emitter<SearchFamilyState> emit,
  ) async {
    if (quiver.isNotBlank(event.familyLookupText) &&
        event.familyLookupText.isNotEmpty) {
      emit(
        state.copyWith(
          searchFamilyFailureOrSuccessOption: none(),
          isSubmitting: true,
        ),
      );

      final Either<FamilyFailure, List<Family>> findAllByNameResult =
          await _familyRepository.findAllByName(
        familyName: event.familyLookupText,
      );

      final Either<SearchFamilyFailure, List<Family>> result =
          findAllByNameResult.fold(
        (failure) => left(mapFamilyFailureToSearchFamilyFailure(failure)),
        (families) => right(families),
      );

      emit(
        state.copyWith(
          searchFamilyFailureOrSuccessOption: some(result),
          isSubmitting: false,
        ),
      );
    }
  }
}
