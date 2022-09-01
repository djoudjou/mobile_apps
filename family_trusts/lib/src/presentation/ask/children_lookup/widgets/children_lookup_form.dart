import 'package:auto_route/auto_route.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/children_lookup/bloc.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/date_helper.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/avatar_widget.dart';
import 'package:familytrusts/src/presentation/core/children_lookup/children_lookup_widget.dart';
import 'package:familytrusts/src/presentation/core/error_content.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildrenLookupForm extends StatefulWidget {
  final User connectedUser;

  const ChildrenLookupForm({Key? key, required this.connectedUser})
      : super(key: key);

  @override
  _ChildrenLookupFormState createState() => _ChildrenLookupFormState();
}

class _ChildrenLookupFormState extends State<ChildrenLookupForm> with LogMixin {
  TextEditingController? dateCtl;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dateCtl = TextEditingController();

    Intl.defaultLocale = fr;
  }

  @override
  void dispose() {
    dateCtl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChildrenLookupBloc, ChildrenLookupState>(
      listener: (bc, state) {
        if (state.isSubmitting) {
          showProgressMessage(LocaleKeys.ask_inprogess.tr(), bc);
        }

        state.failureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) {
              showErrorMessage(LocaleKeys.global_serverError.tr(), bc);
              /*
              failure.map(
                serverError: (_) => {},
                noFamily: (NoFamily noFamily) {},
                invalidChild: (InvalidChild value) {},
                userNotConnected: (UserNotConnected value) {},
                invalidLocation: (InvalidLocation value) {},
                invalidIssuer: (InvalidIssuer value) {},
                insufficientPermission: (InsufficientPermission value) {},
                unableToUpdate: (UnableToUpdate value) {},
              );
               */
            },
            (_) {
              showSuccessMessage(
                LocaleKeys.ask_childlookup_success.tr(),
                bc,
                onDismissed: () {
                  AutoRouter.of(context).popUntilRoot();
                  AutoRouter.of(context).replace(
                    HomePageRoute(
                      currentTab: AppTab.myDemands,
                      connectedUserId: widget.connectedUser.id!,
                    ),
                  );
                },
              );
            },
          ),
        );

        dateCtl?.text = parseRdvDateTimeFromDateTime(
          state.rendezVousStep.rendezVous.getOrCrash(),
        );
      },
      child: BlocBuilder<ChildrenLookupBloc, ChildrenLookupState>(
        builder: (context, state) {
          if (state.isInitializing) {
            return const LoadingContent();
          } else {
            return SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    //color: Colors.green,
                    child: buildStepper(context, state),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildStepper(BuildContext context, ChildrenLookupState state) {
    if (state.isCompleted) {
      return buildResume(context, state);
    } else {
      const double radius = 60;
      return Stepper(
        steps: [
          buildStepChildrenSelection(state, radius, context),
          buildStepLocationsSelection(state, radius, context),
          buildStepRendezVous(state, context),
          buildStepNote(state, context),
        ],
        currentStep: state.currentStep,
        onStepContinue: () => BlocProvider.of<ChildrenLookupBloc>(context).add(
          const ChildrenLookupEvent.next(),
        ),
        onStepTapped: (step) =>
            BlocProvider.of<ChildrenLookupBloc>(context).add(
          ChildrenLookupEvent.goTo(step),
        ),
        onStepCancel: () => BlocProvider.of<ChildrenLookupBloc>(context).add(
          const ChildrenLookupEvent.cancel(),
        ),
        controlsBuilder: (
          BuildContext context,
          ControlsDetails controls,
        ) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MyButton(
                onPressed: controls.onStepContinue!,
                message: LocaleKeys.ask_childlookup_stepper_next.tr(),
              ),
              const MyHorizontalSeparator(),
              MyButton(
                onPressed: controls.onStepCancel!,
                message: LocaleKeys.ask_childlookup_stepper_previous.tr(),
              ),
            ],
          );
        },
      );
    }
  }

  Step buildStepNote(ChildrenLookupState state, BuildContext context) {
    return Step(
      isActive: state.notesStep.isActive,
      state: getCurrentStepState(
        isActive: state.notesStep.isActive,
        isValid: state.notesStep.noteBody.isValid(),
      ),
      title: MyText(LocaleKeys.ask_childlookup_stepper_note_selection.tr()),
      content: Form(
        key: _formKey,
        autovalidateMode: state.showErrorMessages
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.note),
          ),
          keyboardType: TextInputType.name,
          maxLines: 3,
          autocorrect: false,
          onChanged: (value) => context
              .read<ChildrenLookupBloc>()
              .add(ChildrenLookupEvent.noteChanged(value)),
          validator: (_) => context
              .read<ChildrenLookupBloc>()
              .state
              .notesStep
              .noteBody
              .value
              .fold(
                (f) => f.maybeMap(
                  orElse: () => LocaleKeys.location_form_note_error.tr(),
                ),
                (_) => null,
              ),
        ),
      ),
    );
  }

  Step buildStepRendezVous(ChildrenLookupState state, BuildContext context) {
    return Step(
      isActive: state.rendezVousStep.isActive,
      state: getCurrentStepState(
        isActive: state.rendezVousStep.isActive,
        isValid: state.rendezVousStep.rendezVous.isValid(),
      ),
      title: MyText(LocaleKeys.ask_childlookup_stepper_date_selection.tr()),
      content: DateTimePicker(
        type: DateTimePickerType.dateTimeSeparate,
        controller: dateCtl,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 300)),
        //locale: const Locale(FR),
        icon: const Icon(Icons.event),
        onSaved: (date) {
          final DateTime dateTime =
              rendezVousConverterWithDateTimePickerToDate(date).toNullable()!;
          context
              .read<ChildrenLookupBloc>()
              .add(ChildrenLookupEvent.rendezVousChanged(dateTime));
        },
        onChanged: (val) {
          final DateTime dateTime =
              rendezVousConverterWithDateTimePickerToDate(val).toNullable()!;
          context
              .read<ChildrenLookupBloc>()
              .add(ChildrenLookupEvent.rendezVousChanged(dateTime));
        },
      ),
    );
  }

  Step buildStepLocationsSelection(
    ChildrenLookupState state,
    double radius,
    BuildContext context,
  ) {
    return Step(
      isActive: state.locationsStep.isActive,
      state: getCurrentStepState(
        isActive: state.locationsStep.isActive,
        isValid: state.locationsStep.selectedLocation != null,
      ),
      title: MyText(LocaleKeys.ask_childlookup_stepper_place_selection.tr()),
      content: state.locationsStep.optionEitherLocations.fold(
        () => const LoadingContent(),
        (eitherLocations) => eitherLocations.fold(
          (failure) => const ErrorContent(),
          (locations) => Column(
            children: locations
                .map(
                  (location) => Column(
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          MyAvatar(
                            imageTag: "TAG_LOCATION_${location.id}",
                            photoUrl: location.photoUrl,
                            radius: radius / 2,
                            onTapCallback: () =>
                                BlocProvider.of<ChildrenLookupBloc>(context)
                                    .add(
                              ChildrenLookupEvent.locationSelected(
                                location,
                              ),
                            ),
                            defaultImage: defaultLocationImages,
                          ),
                          const MyHorizontalSeparator(),
                          InkWell(
                            onTap: () =>
                                BlocProvider.of<ChildrenLookupBloc>(context)
                                    .add(
                              ChildrenLookupEvent.locationSelected(
                                location,
                              ),
                            ),
                            child: MyText(
                              location.title.getOrCrash(),
                              alignment: TextAlign.start,
                              maxLines: 5,
                            ),
                          ),
                        ],
                      ),
                      if (location.id ==
                          state.locationsStep.selectedLocation?.id) ...[
                        buildDivider(context),
                      ],
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Step buildStepChildrenSelection(
    ChildrenLookupState state,
    double radius,
    BuildContext context,
  ) {
    return Step(
      title: MyText(LocaleKeys.ask_childlookup_stepper_child_selection.tr()),
      isActive: state.childrenStep.isActive,
      state: getCurrentStepState(
        isActive: state.childrenStep.isActive,
        isValid: state.childrenStep.selectedChild != null,
      ),
      content: state.childrenStep.optionEitherChildren.fold(
        () => const LoadingContent(),
        (eitherChildren) => eitherChildren.fold(
          (failure) => const ErrorContent(),
          (children) => Column(
            children: children
                .map(
                  (child) => Column(
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          MyAvatar(
                            imageTag: "TAG_CHILD_${child.id}",
                            photoUrl: child.photoUrl,
                            radius: radius / 2,
                            onTapCallback: () =>
                                BlocProvider.of<ChildrenLookupBloc>(context)
                                    .add(
                              ChildrenLookupEvent.childSelected(child),
                            ),
                            defaultImage: defaultUserImages,
                          ),
                          const MyHorizontalSeparator(),
                          InkWell(
                            onTap: () =>
                                BlocProvider.of<ChildrenLookupBloc>(context)
                                    .add(
                              ChildrenLookupEvent.childSelected(child),
                            ),
                            child: MyText(
                              child.displayName,
                              alignment: TextAlign.start,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                      if (child.id == state.childrenStep.selectedChild?.id) ...[
                        buildDivider(context),
                      ],
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Center buildResume(BuildContext context, ChildrenLookupState state) {
    final cardWidth = MediaQuery.of(context).size.width * .7;
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        child: ChildrenLookupWidget(
          connectedUser: widget.connectedUser,
          cardWidth: cardWidth,
          childrenLookup: ChildrenLookup(
            id: "",
            child: state.childrenStep.selectedChild,
            location: state.locationsStep.selectedLocation,
            rendezVous: state.rendezVousStep.rendezVous,
            noteBody: state.notesStep.noteBody,
            state: MissionState.waiting(),
            creationDate: TimestampVo.now(),
          ),
        ),
      ),
    );
  }

  Divider buildDivider(BuildContext bc) {
    return Divider(
      color: Theme.of(bc).primaryColor,
      height: 10,
      thickness: 5,
    );
  }

  StepState getCurrentStepState({
    required bool isActive,
    required bool isValid,
  }) {
    if (isActive) {
      return StepState.editing;
    } else {
      return isValid ? StepState.complete : StepState.error;
    }
  }
}
