import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/presentation/core/avatar_widget.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/core/my_drawer.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';

class AskPageTab extends StatelessWidget {
  final User user;
  final User? spouse;

  const AskPageTab({super.key, required this.user, this.spouse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(user: user, spouse: spouse),
      appBar: MyAppBar(
        pageTitle: LocaleKeys.ask_title.tr(),
        context: context,
      ),
      body: FractionallySizedBox(
        alignment: Alignment.topCenter,
        widthFactor: 0.5,
        heightFactor: 0.5,
        //color: Colors.red,
        child: InkWell(
          onTap: () => gotoChildrenLookup(
            context,
          ),
          child: Card(
            margin: const EdgeInsets.all(10),
            //color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyAvatar(
                  defaultImage: childrenLookupImages,
                  onTapCallback: () => gotoChildrenLookup(
                    context,
                  ),
                  radius: 70,
                  imageTag: "CHILDREN_LOOKUP",
                ),
                SizedBox(
                  width: 100,
                  child: MyText(
                    LocaleKeys.ask_childlookup_title.tr(),
                    fontSize: 13,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void gotoChildrenLookup(BuildContext context) {
    AutoRouter.of(context).push(
      ChildrenLookupPageRoute(
        key: const ValueKey("ChildrenLookupPage"),
        connectedUser: user,
        currentFamilyId: user.family?.id,
      ),
    );
  }
}
