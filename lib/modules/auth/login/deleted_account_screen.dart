import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/modules/auth/login/login_registration_presenter.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DeletedAccountScreen extends StatefulWidget {
  final bool isFromSplash;
  const DeletedAccountScreen({Key? key, required this.isFromSplash})
      : super(key: key);

  @override
  _DeletedAccountScreenState createState() => _DeletedAccountScreenState();
}

class _DeletedAccountScreenState extends State<DeletedAccountScreen> {
  String? deletedText;
  bool isBackFromBtn = false;

  @override
  void initState() {
    super.initState();
    deletedText =
        StorageManager.getStringValue(AppStorageKey.deletedAccountText);
    navigateBack();
    // if (widget.isFromSplash) {
    //   getProfileData();
    // }
  }

  void navigateBack() async {
    Future.delayed(const Duration(seconds: 20), () {
      if (!isBackFromBtn) {
        StorageManager.removeValue(
          AppStorageKey.deletedAccountText,
        );
        AutoRouter.of(context).pushAndPopUntil(
            LoginRegistrationScreenRoute(
              presenter: BasicLoginRegistrationPresenter(),
            ),
            predicate: (_) => false);
      }
    });
  }

  // void getProfileData() async {
  //   Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
  //     url: ApiPath.apiEndPoint + ApiPath.getProfile,
  //     context: context,
  //     noRedirect: true,
  //     queryParameters: {
  //       'membership_no': GlobalSingleton.userInformation.membershipNo,
  //     },
  //   );
  //   if (response != null) {
  //     GlobalSingleton.userInformation = UserInformation.fromJson(
  //       response['data']['values'][0],
  //     );
  //     StorageManager.setStringValue(
  //       key: AppStorageKey.userInformation,
  //       value: userInformationToJson(GlobalSingleton.userInformation),
  //     );
  //     StorageManager.removeValue(AppStorageKey.deletedAccountText);
  //     AutoRouter.of(context).pushAndPopUntil(
  //         predicate: (_) => false, MainHomeScreenRoute(isFirstLoad: true));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isBackFromBtn = true;
                });
                StorageManager.removeValue(
                  AppStorageKey.deletedAccountText,
                );
                AutoRouter.of(context).pushAndPopUntil(
                    LoginRegistrationScreenRoute(
                      presenter: BasicLoginRegistrationPresenter(),
                    ),
                    predicate: (_) => false);
              },
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.blackColor,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  deletedText ?? "",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bold22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
