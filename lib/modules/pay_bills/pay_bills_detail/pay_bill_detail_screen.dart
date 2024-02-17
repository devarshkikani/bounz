import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/models/pay_bills/product_model.dart';
import 'package:bounz_revamp_app/models/pay_bills/recent_transaction.dart';
import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/modules/claim_rewards/view_details_screen.dart';
import 'package:bounz_revamp_app/modules/pay_bills/countries/countries_list_presenter.dart';
import 'package:bounz_revamp_app/modules/pay_bills/pay_bills_detail/pay_bill_detail_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/pay_bills_detail/pay_bill_detail_view.dart';
import 'package:bounz_revamp_app/modules/pay_bills/pay_bills_detail/pay_bill_details_presenter.dart';
import 'package:bounz_revamp_app/modules/pay_bills/paybill_checkout/checkout_presenter.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/my_behavior.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class PayBillDetailScreen extends StatefulWidget {
  final String? serviceId;
  final String? serviceName;
  final String? serviceImgUrl;
  final String? category;
  final String? categoryId;
  final bool fromSplash;
  const PayBillDetailScreen(
      {Key? key,
      @PathParam('serviceId') this.serviceId,
      @PathParam('serviceName') this.serviceName,
      @PathParam('fromSplash') this.fromSplash = false,
      this.serviceImgUrl,
      this.category,
      this.categoryId})
      : super(key: key);

  @override
  State<PayBillDetailScreen> createState() => _PayBillDetailScreenState();
}

class _PayBillDetailScreenState extends State<PayBillDetailScreen>
    implements PayBillDetailView {
  late PayBillDetailModel model;
  PayBillDetailPresenter presenter =
      BasicPayBillDetailPresenter(ServiceModel());

  @override
  void initState() {
    super.initState();
    presenter = BasicPayBillDetailPresenter(ServiceModel(
        serviceId: int.parse(widget.serviceId.toString()),
        serviceName: widget.serviceName));
    presenter.updateView = this;
    if (GlobalSingleton.transactionList == null) {
      presenter.getRecentTransaction(context);
    } else {
      model.transactionList = GlobalSingleton.transactionList!;
    }
  }

  @override
  void refreshModel(PayBillDetailModel payBillDetailModel) {
    if (mounted) {
      setState(() {
        model = payBillDetailModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true, index: 1),
              predicate: (_) => false);
        } else {
          AutoRouter.of(context).canPop();
        }
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: AppBackGroundWidget(
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
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
                Text(
                  model.serviceModel.serviceName.toString(),
                  style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
                ),
                const SizedBox(
                  height: AppSizes.size22,
                ),
                Image.asset(
                  AppAssets.bannerPayBills,
                  width: MediaQuery.of(context).size.width,
                ),
                const SizedBox(
                  height: AppSizes.size22,
                ),
                selectCountryContainer(),
                const SizedBox(
                  height: AppSizes.size22,
                ),
                if (model.transactionList.isNotEmpty)
                  recentTransactionListView()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectCountryContainer() {
    return GestureDetector(
      onTap: () {
        MoenageManager.logScreenEvent(name: 'Countries List');
        AutoRouter.of(context).push(
          CountriesListScreenRoute(
            countryListPresenter:
                BasicCountriesListPresenter(model.serviceModel),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(58, 33, 57, 0.23),
              Color.fromRGBO(22, 9, 19, 0.23),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppConstString.selectCountry,
              style: AppTextStyle.light16,
            ),
            SvgPicture.asset(AppAssets.locationIcon)
          ],
        ),
      ),
    );
  }

  Widget recentTransactionListView() {
    List<RecentTransaction> list = model.transactionList
        .where((e) => e.serviceId == model.serviceModel.serviceId)
        .toList();
    return list.isEmpty
        ? const SizedBox()
        : Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstString.recentRecharge,
                  style: AppTextStyle.bold16,
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await presenter.getRecentTransaction(null);
                    },
                    child: Stack(
                      children: [
                        ListView(),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: model.transactionList.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return model.serviceModel.serviceId ==
                                    model.transactionList[index].serviceId
                                ? recentRechargeContainer(index)
                                : const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget recentRechargeContainer(int index) {
    return InkWell(
      onTap: () {
        final RecentTransaction rT = model.transactionList[index];
        if (rT.productName?.contains('Open_Range') == true) {
          AutoRouter.of(context).push(
            BillsScreenRoute(
              productModel: ProductModel(
                productId: rT.productId,
                pricesRetailAmount: rT.pricesRetailAmount,
                requiredPoints: rT.requiredPoints,
                convesFees: rT.convesFees,
                totalAmount: rT.totalAmount,
                serviceName: rT.serviceName,
                earnPoint: rT.earnPoint,
                supportsStatementInquiry: rT.supportsStatementInquiry,
                requiredCreditPartyIdentifierFields:
                    rT.requiredCreditPartyIdentifierFields,
              ),
              redemptionRate: rT.redemptionRate,
              countryCode: rT.countryCode ?? '',
              accountQualifier: rT.accountQualifier ?? '',
              actNumberController: rT.accountNumber ?? '',
              phoneController: rT.mobileNumber ?? '',
            ),
          );
        } else {
          MoenageManager.logScreenEvent(name: 'Checkout');
          AutoRouter.of(context).push(
            CheckoutScreenRoute(
              fromRecentTransaction: true,
              countryDetails: {
                "iso_code": rT.isoCode,
                "country_name": rT.countryName,
                "country_img_url": rT.countryImgUrl,
                "countryCode": rT.countryCode,
                "mobile_number_length": rT.mobileNumberLength
              },
              presenter: BasicCheckoutPresenter(
                productModel: ProductModel(
                  productId: rT.productId,
                  pricesRetailAmount: rT.pricesRetailAmount,
                  requiredPoints: rT.requiredPoints,
                  convesFees: rT.convesFees,
                  totalAmount: rT.totalAmount.toDouble(),
                  earnPoint: rT.earnPoint,
                  country: rT.country,
                  isoCode: rT.isoCode,
                  operatorName: rT.operatorName,
                  operatorId: rT.operatorId,
                  operatorImgUrl: rT.operatorImage,
                  name: rT.productName,
                  serviceName: rT.serviceName,
                  serviceId: rT.serviceId,
                  supportsStatementInquiry: rT.supportsStatementInquiry,
                  requiredCreditPartyIdentifierFields:
                      rT.requiredCreditPartyIdentifierFields,
                ),
                redemptionRate: rT.redemptionRate,
                phoneNumber: rT.mobileNumber,
                accountNumber: rT.accountNumber,
                accountQualifier: rT.accountQualifier,
                countryCode: '+${rT.countryCode}',
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppSizes.size12),
        margin: const EdgeInsets.only(bottom: AppSizes.size16),
        decoration: BoxDecoration(
          color: AppColors.primaryContainerColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppSizes.size40,
              width: AppSizes.size40,
              child: ClipOval(
                child: networkImage(
                  model.transactionList[index].operatorImage.toString(),
                ),
              ),
            ),
            const SizedBox(
              width: 14.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.transactionList[index].productName.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.semiBold16,
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  // SizedBox(
                  //   width: 100.0,
                  //   child:
                  Text(
                    model.transactionList[index].transactionsId.toString(),
                    // maxLines: 2,
                    style: AppTextStyle.light12,
                    // ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    DateTime.parse(model.transactionList[index].transactionDate
                            .toString())
                        .ymddateFormat,
                    style: AppTextStyle.light12,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: AppSizes.size10,
            ),
            Column(
              children: [
                Text(
                  'AED ${model.transactionList[index].transactionType! == 'redemption' ? num.parse(model.transactionList[index].pricesRetailAmount.toString()).toStringAsFixed(2) : model.transactionList[index].amount == null ? '${model.transactionList[index].amount}' : num.parse(model.transactionList[index].amount.toString()).toStringAsFixed(2)}',
                  style: AppTextStyle.bold16,
                ),
                Text(
                  model.transactionList[index].transactionStatus.toString(),
                  style: AppTextStyle.regular14,
                ),
                if (model.transactionList[index].productType ==
                    'FIXED_VALUE_PIN_PURCHASE')
                  Column(
                    children: [
                      const SizedBox(
                        height: AppSizes.size10,
                      ),
                      InkWell(
                        onTap: () {
                          MoenageManager.logScreenEvent(
                              name: 'Fixed Value Pin Purchase Details');
                          Map fixedValueData = {
                            'code': model.transactionList[index].code,
                            'serial': model.transactionList[index].serial,
                            'usage_info':
                                model.transactionList[index].usageInfo,
                            'validity': model.transactionList[index].validity,
                          };
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewDetailsScreen(
                                fixedValueData: fixedValueData,
                                fromRecentTrasaction: true,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'View Details',
                          style: AppTextStyle.regular12.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
