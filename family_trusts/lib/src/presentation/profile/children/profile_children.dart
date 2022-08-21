import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/family/children/bloc.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/avatar_widget.dart';
import 'package:familytrusts/src/presentation/core/error_content.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileChildren extends StatelessWidget {
  final double radius;
  final User connectedUser;
  final _key = const PageStorageKey<String>('children');

  ProfileChildren({
    Key? key,
    required this.radius,
    required this.connectedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt<ChildrenBloc>()
        ..add(ChildrenEvent.loadChildren(connectedUser.family!.id)),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ChildrenBloc, ChildrenState>(
            listener: (context, state) {
              state.map(
                childrenLoading: (_) {},
                childrenLoaded: (_) {},
                childrenNotLoaded: (_) => showErrorMessage(
                  LocaleKeys.profile_childrenNotLoaded.tr(),
                  context,
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<ChildrenBloc, ChildrenState>(
          builder: (childrenBlocContext, state) {
            return state.maybeMap(
              orElse: () => Column(
                children: <Widget>[
                  MyText(LocaleKeys.profile_tabs_children_loading.tr()),
                  const LoadingContent(),
                ],
              ),
              childrenNotLoaded: (childrenNotLoaded) => Container(
                color: Colors.blue,
                child: MyText(LocaleKeys.profile_tabs_children_error.tr()),
              ),
              childrenLoaded: (childrenLoaded) =>
                  childrenLoaded.eitherChildren.fold(
                (childrenFailure) => const ErrorContent(),
                (eitherChildren) => eitherChildren.isEmpty
                    ? Align(
                        child: MyText(
                          LocaleKeys.profile_tabs_children_noChildren.tr(),
                          maxLines: 3,
                        ),
                      )
                    : ListView.separated(
                        key: _key,
                        padding: const EdgeInsets.all(8),
                        itemCount: eitherChildren.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemBuilder: (BuildContext context, int index) {
                          return eitherChildren[index].fold(
                            (error) => const MyHorizontalSeparator(),
                            (child) => Container(
                              //color: Colors.green,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  MyAvatar(
                                    imageTag: "TAG_CHILD_${child.id}",
                                    photoUrl: child.photoUrl,
                                    radius: radius / 2,
                                    onTapCallback: () => gotoEditChild(
                                      currentUser: connectedUser,
                                      context: context,
                                      editing: true,
                                      child: child,
                                    ),
                                    defaultImage: defaultUserImages,
                                  ),
                                  const MyHorizontalSeparator(),
                                  InkWell(
                                    onTap: () => gotoEditChild(
                                      currentUser: connectedUser,
                                      context: context,
                                      editing: true,
                                      child: child,
                                    ),
                                    child: MyText(
                                      child.displayName,
                                      alignment: TextAlign.start,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
