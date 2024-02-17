import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/main.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_inbox/inbox_data.dart';
import 'package:moengage_inbox/moengage_inbox.dart';

import '../pay_bills/pay_bill_home/pay_bills_home_screen.dart';

@RoutePage()
class NotificationScreen extends StatefulWidget {
  final bool fromSplash;
  const NotificationScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final MoEngageInbox _moEngageInbox =
      MoEngageInbox("668EZ1ENJ3R8N6YSZNAGIQP0");
  InboxData? notificationData;

  void fetchMessages() async {
    InboxData? data = await _moEngageInbox.fetchAllMessages();
    notificationData = data!;
    if (data.messages.isNotEmpty) {
      for (final message in data.messages) {
        _moEngageInbox.trackMessageClicked(message);
      }
    }
    setState(() {});
  }

  void unClickedCount() async {
    await _moEngageInbox.getUnClickedCount();
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
    unClickedCount();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(
                isFirstLoad: true,
              ),
              predicate: (_) => false);
        } else {
          Navigator.of(context).pop();
        }
        return true;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  if (widget.fromSplash) {
                    MoenageManager.logScreenEvent(name: 'Main Home');
                    AutoRouter.of(context).pushAndPopUntil(
                        MainHomeScreenRoute(
                          isFirstLoad: true,
                        ),
                        predicate: (_) => false);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(
                height: AppSizes.size30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstString.notificationHeader,
                    style: AppTextStyle.regular36.copyWith(
                      fontFamily: 'Bebas',
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          clearNotification();
                          setState(() {
                            final properties = MoEProperties();
                            properties.addAttribute(
                                TriggeringCondition.screenName,
                                "Notification Screen");
                            MoenageManager.logEvent(
                              MoenageEvent.clearNotification,
                              properties: properties,
                            );
                          });
                        },
                        child: notificationData != null
                            ? notificationData!.messages.isNotEmpty
                                ? Text(
                                    AppConstString.clearText,
                                    style: AppTextStyle.bold12.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                  )
                                : const SizedBox()
                            : Container(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size16,
              ),
              notificationData != null
                  ? notificationData!.messages.isNotEmpty
                      ? notificationsListWidget()
                      : noNotificationView()
                  : noNotificationView()
            ],
          ),
        ),
      ),
    );
  }

  void clearNotification() {
    showModalBottomSheet(
      backgroundColor: AppColors.secondaryContainerColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: AppSizes.size20,
            right: AppSizes.size20,
            left: AppSizes.size20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SizedBox(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure?',
                  style: AppTextStyle.semiBold14
                      .copyWith(color: AppColors.darkBlueTextColor),
                ),
                const SizedBox(
                  height: AppSizes.size10,
                ),
                Text(
                  'Do you want clear all notifications?',
                  style: AppTextStyle.semiBold14
                      .copyWith(color: AppColors.darkBlueTextColor),
                ),
                const SizedBox(
                  height: AppSizes.size30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RoundedBorderButton(
                        height: AppSizes.size60,
                        onTap: () {
                          deleteNotifications();
                        },
                        bColor: AppColors.btnBlueColor,
                        tColor: AppColors.btnBlueColor,
                        text: AppConstString.yes,
                      ),
                    ),
                    const SizedBox(
                      width: AppSizes.size10,
                    ),
                    Expanded(
                      child: PrimaryButton(
                        height: AppSizes.size60,
                        text: AppConstString.no,
                        onTap: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteNotifications() async {
    InboxData? data = await _moEngageInbox.fetchAllMessages();
    if (data != null) {
      if (data.messages.isNotEmpty) {
        for (final message in data.messages) {
          // setState(() {
          _moEngageInbox.deleteMessage(message);
          fetchMessages();
          // });
        }
      }
    }
    Navigator.of(context).pop(false);
  }

  Widget notificationsListWidget() {
    return Expanded(
      child: ListView.builder(
        itemCount: notificationData?.messages.length,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (DismissDirection direction) {},
            background: const ColoredBox(
              color: AppColors.lightOrangeColor,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ),
            confirmDismiss: (DismissDirection direction) async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Are you sure you want to delete?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          _moEngageInbox
                              .deleteMessage(notificationData!.messages[index]);
                          final properties = MoEProperties();
                          properties
                              .addAttribute(TriggeringCondition.screenName,
                                  'Notification Screen')
                              .setNonInteractiveEvent();
                          MoenageManager.logEvent(
                            MoenageEvent.deleteNotification,
                            properties: properties,
                          );
                          fetchMessages();
                          Navigator.pop(context, false);
                        },
                        child: const Text('Yes'),
                      )
                    ],
                  );
                },
              );
              return confirmed;
            },
            child: GestureDetector(
              onTap: () {
                final properties = MoEProperties();
                properties
                    .addAttribute(
                        TriggeringCondition.screenName, "Notification Screen")
                    .addAttribute(TriggeringCondition.notificationId,
                        notificationData?.messages[index].id)
                    .addAttribute(TriggeringCondition.notificationType,
                        notificationData?.messages[index].tag)
                    .addAttribute(
                        TriggeringCondition.redirectionType,
                        notificationData?.platform == 'iOS'
                            ? notificationData?.messages[index]
                                .payload['app_extra']['moe_deeplink']
                            : notificationData
                                ?.messages[index].payload['gcm_webUrl'])
                    .addAttribute(TriggeringCondition.notificationTitle,
                        notificationData?.messages[index].textContent.title)
                    .addAttribute(TriggeringCondition.notoificationSource,
                        notificationData?.platform);

                MoenageManager.logEvent(
                  MoenageEvent.openNotification,
                  properties: properties,
                );
                if (notificationData?.platform == 'iOS') {
                  if (notificationData?.messages[index].payload['app_extra']
                          ['moe_deeplink'] ==
                      "/pay_bill_home") {
                    appRouter.pushWidget(const PayBillHome());
                  } else {
                    appRouter.pushNamed(notificationData?.messages[index]
                            .payload['app_extra']['moe_deeplink'] +
                        '/false');
                  }
                  //Android
                } else if (notificationData
                        ?.messages[index].payload['gcm_webUrl'] ==
                    "/pay_bill_home") {
                  appRouter.pushWidget(const PayBillHome());
                } else {
                  appRouter.pushNamed(
                    notificationData?.messages[index].payload['gcm_webUrl'] +
                        '/false',
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.size20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Container(
                        height: AppSizes.size40,
                        width: AppSizes.size40,
                        color: AppColors.backgroundColor,
                        child: notificationData?.messages[index].media?.url ==
                                null
                            ? CircleAvatar(
                                backgroundColor: AppColors.backgroundColor,
                                radius: 20,
                                child: SvgPicture.asset(
                                  AppAssets.bounzWhiteLogo,
                                  height: AppSizes.size24,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : networkImage(
                                notificationData!.messages[index].media!.url,
                                fit: BoxFit.cover,
                                height: 150,
                                width: MediaQuery.of(context).size.width * .39,
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: AppSizes.size10,
                    ),
                    Expanded(
                      child: Text(
                        notificationData?.messages[index].textContent.message ??
                            " ",
                        style: AppTextStyle.regular13,
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     // setState(() async {
                    //       _moEngageInbox.deleteMessage(notificationData!.messages[index]);
                    //       fetchMessages();
                    //     // });
                    //   },
                    //   child: const Icon(
                    //     Icons.delete,
                    //     color: AppColors.errorColor,
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget noNotificationView() {
    return Column(
      children: [
        noNotificationsWidget(),
        const SizedBox(
          height: AppSizes.size20,
        ),
        goBackToAccountButtonWidget(),
        const SizedBox(
          height: AppSizes.size10,
        ),
        homeButtonWidget(),
      ],
    );
  }

  Widget noNotificationsWidget() {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            AppAssets.noNotification,
            height: 300,
          ),
          const SizedBox(
            height: AppSizes.size12,
          ),
          Text(
            AppConstString.noNotificationText,
            style: AppTextStyle.bold16,
          ),
        ],
      ),
    );
  }

  Widget goBackToAccountButtonWidget() {
    return Center(
      child: RoundedBorderButton(
        text: 'Go Back To My Account',
        tColor: AppColors.btnBlueColor,
        onTap: () {
          MoenageManager.logScreenEvent(name: 'Main Home');

          AutoRouter.of(context).pushAndPopUntil(
            MainHomeScreenRoute(index: 4),
            predicate: (_) => false,
          );
        },
        bColor: AppColors.btnBlueColor,
      ),
    );
  }

  Widget homeButtonWidget() {
    return Center(
      child: PrimaryButton(
        text: 'Home',
        bColor: AppColors.secondaryBackgroundColor,
        onTap: () {
          MoenageManager.logScreenEvent(name: 'Main Home');

          AutoRouter.of(context).pushAndPopUntil(
            MainHomeScreenRoute(),
            predicate: (_) => false,
          );
        },
      ),
    );
  }
}
