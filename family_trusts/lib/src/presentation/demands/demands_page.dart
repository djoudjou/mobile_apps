import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/demands/bloc.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/error_content.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/core/my_drawer.dart';
import 'package:familytrusts/src/presentation/demands/widgets/demands_in_progress_tab.dart';
import 'package:familytrusts/src/presentation/demands/widgets/demands_passed_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DemandsPage extends StatelessWidget {
  final User user;
  final User? spouse;

  const DemandsPage({Key? key, required this.user, this.spouse})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<DemandsBloc>()
            ..add(DemandsEvent.loadDemands(user.familyId)),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<DemandsBloc, DemandsState>(
            listener: (context, state) {
              state.maybeMap(
                demandsLoaded: (s) {
                  s.demands.fold(
                    (notificationFailure) => showErrorMessage(
                      LocaleKeys.global_serverError.tr(),
                      context,
                    ),
                    (_) => null,
                  );
                },
                demandsNotLoaded: (s) => showErrorMessage(
                  LocaleKeys.global_serverError.tr(),
                  context,
                ),
                orElse: () => null,
              );
            },
          ),
        ],
        child: BlocBuilder<DemandsBloc, DemandsState>(
          builder: (context, state) {
            return DefaultTabController(
              length: 2, // This is the number of tabs.
              child: Scaffold(
                drawer: MyDrawer(user: user, spouse: spouse),
                appBar: MyAppBar(
                  context: context,
                  pageTitle: LocaleKeys.demands_title.tr(),
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: <Tab>[
                      Tab(
                        text: LocaleKeys.demands_tabs_in_progress_tab.tr(),
                        icon: const Icon(FontAwesomeIcons.paperPlane),
                      ),
                      Tab(
                        text: LocaleKeys.demands_tabs_passed_tab.tr(),
                        icon: const Icon(FontAwesomeIcons.archive),
                      )
                    ],
                  ),
                ),
                body: TabBarView(
                  // These are the contents of the tab views, below the tabs.
                  children: state.map(
                    demandsLoading: (DemandsLoading value) => const <Widget>[
                      LoadingContent(),
                      LoadingContent(),
                    ],
                    demandsNotLoaded: (state) => const <Widget>[
                      LoadingContent(),
                      LoadingContent(),
                    ],
                    demandsLoaded: (state) {
                      return state.demands.fold(
                        (_) => const [
                          ErrorContent(),
                          ErrorContent(),
                        ],
                        (demands) => <Widget>[
                          DemandsInProgressTab(
                            childrenLookups: demands.inProgressChildrenLookups,
                          ),
                          DemandsPassedTab(
                            childrenLookups: demands.passedChildrenLookups,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
