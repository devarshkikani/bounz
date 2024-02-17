import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/pay_bill_home/pay_bills_home_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/pay_bill_home/pay_bills_home_presenter.dart';
import 'package:bounz_revamp_app/modules/pay_bills/pay_bill_home/pay_bills_home_view.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moengage_flutter/properties.dart';

class PayBillHome extends StatefulWidget {
  const PayBillHome({
    Key? key,
  }) : super(key: key);

  @override
  State<PayBillHome> createState() => _PayBillHomeState();
}

final PayBillsPresenter serviceListPresenter = BasicPayBillsPresenter();
PayBillsModel? model;

class _PayBillHomeState extends State<PayBillHome> implements PayBillsView {
  @override
  void refreshModel(PayBillsModel serviceListModel) {
    if (mounted) {
      setState(() {
        model = serviceListModel;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (model == null) {
      serviceListPresenter.updateModel = this;
      serviceListPresenter.serviceList(
        context: context,
      );
    }
    String? data =
        StorageManager.getStringValue(AppStorageKey.storePayBillImage);
    if (data != null) {
      final List<dynamic> jsonData = jsonDecode(data);
      model!.serviceList = jsonData.map<List<ServiceModel>>((jsonList) {
        return jsonList.map<ServiceModel>((jsonItem) {
          return ServiceModel.fromJson(jsonItem);
        }).toList();
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                MoenageManager.logScreenEvent(name: 'Main Home');

                AutoRouter.of(context).pushAndPopUntil(
                  MainHomeScreenRoute(),
                  predicate: (_) => false,
                );
              },
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(
              height: AppSizes.size30,
            ),
            Text(
              AppConstString.payBill.toUpperCase(),
              style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
            ),
            const SizedBox(
              height: AppSizes.size20,
            ),
            model?.serviceList == null
                ? const SizedBox()
                : model!.serviceList!.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'Currently Service is not available',
                            style: AppTextStyle.bold22.copyWith(
                              color: AppColors.brownishColor,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: List.generate(
                            model!.serviceList!.length,
                            (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                index == 0
                                    ? Text(
                                        AppConstString.telAndRec,
                                        style: AppTextStyle.bold16,
                                      )
                                    : Text(
                                        AppConstString.houseAndMore,
                                        style: AppTextStyle.bold16,
                                      ),
                                const SizedBox(
                                  height: AppSizes.size20,
                                ),
                                telAndRecContainer(index),
                                const SizedBox(
                                  height: AppSizes.size20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }

  Widget telAndRecContainer(int index) {
    return Container(
      padding: const EdgeInsets.only(
        right: AppSizes.size6,
        top: AppSizes.size10,
        bottom: AppSizes.size10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: AppColors.primaryContainerColor.withOpacity(0.15),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.greyColor.withOpacity(0.01),
            offset: const Offset(0, AppSizes.size20),
            blurRadius: AppSizes.size20,
          ),
        ],
      ),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: .9,
        children: List.generate(
          model!.serviceList![index].length,
          (i) {
            return InkWell(
              onTap: () {
                MoenageManager.logScreenEvent(name: 'Pay Bill Detail');
                final properties = MoEProperties();
                properties
                    .addAttribute(TriggeringCondition.billType,
                        model!.serviceList![index][i].serviceName)
                    .addAttribute(
                        TriggeringCondition.screenName, "PayBillsHome")
                    .setNonInteractiveEvent();
                MoenageManager.logEvent(
                  MoenageEvent.paybills,
                  properties: properties,
                );
                // AutoRouter.of(context).push(
                //   PayBillDetailScreenRoute(
                //     presenter: BasicPayBillDetailPresenter(
                //         model.serviceList![index][i]),
                //   ),
                // );
                log('/pay_bill_screen/${model!.serviceList![index][i].serviceId}/${model!.serviceList![index][i].serviceName}/false');
                AutoRouter.of(context).pushNamed(
                    '/pay_bill_screen/${model!.serviceList![index][i].serviceId}/${model!.serviceList![index][i].serviceName}/false');
              },
              child: itemDecoration(
                model!.serviceList![index][i],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget itemDecoration(ServiceModel serviceModel) {
    Uint8List? uint8list;
    if ((serviceModel.serviceImgUrl.toString().contains('['))) {
      List dynamicList = jsonDecode(serviceModel.serviceImgUrl);
      List<int> intList = dynamicList.cast<int>().toList();
      uint8list = Uint8List.fromList(intList);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: AppSizes.size10,
        ),
        SizedBox(
          height: 60,
          width: 60,
          child: uint8list == null
              ? SvgPicture.network(
                  serviceModel.serviceImgUrl,
                  placeholderBuilder: (context) {
                    return const CupertinoActivityIndicator();
                  },
                )
              : SvgPicture.memory(
                  uint8list,
                  placeholderBuilder: (context) {
                    return const CupertinoActivityIndicator();
                  },
                ),
        ),
        const SizedBox(
          height: AppSizes.size10,
        ),
        Flexible(
          child: Text(
            serviceModel.serviceName.toString(),
            style: AppTextStyle.semiBold14,
          ),
        ),
      ],
    );
  }
}
