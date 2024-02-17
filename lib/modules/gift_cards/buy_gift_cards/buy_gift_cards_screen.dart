import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/enum.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/gif_card_voucher/category_model.dart';
import 'package:bounz_revamp_app/modules/gift_cards/buy_gift_cards/buy_gift_cards_model.dart';
import 'package:bounz_revamp_app/modules/gift_cards/buy_gift_cards/buy_gift_cards_view.dart';
import 'package:bounz_revamp_app/modules/gift_cards/gift_card_details/gift_card_details_presenter.dart';
import 'package:bounz_revamp_app/utils/debounce.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:bounz_revamp_app/widgets/shrimmer_widet.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/properties.dart';

import 'buy_gift_cards_presenter.dart';

@RoutePage()
class BuyGiftCardsScreen extends StatefulWidget {
  final bool fromSplash;
  const BuyGiftCardsScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<BuyGiftCardsScreen> createState() => _BuyGiftCardsScreenState();
}

class _BuyGiftCardsScreenState extends State<BuyGiftCardsScreen>
    implements BuyGiftCardsView {
  late BuyGiftCardsModel model;
  final TextEditingController searchController = TextEditingController();
  final Debounce _debounce = Debounce(const Duration(milliseconds: 1000));
  final BuyGiftCardsPresenter presenter = BasicBuyGiftCardsPresenter();

  @override
  void initState() {
    super.initState();
    presenter.updateModel = this;
    presenter.getVouchersList(null);
  }

  @override
  void refreshModel(BuyGiftCardsModel buyGiftCardModel) {
    if(mounted) {
      setState(() {
      model = buyGiftCardModel;
    });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true),
              predicate: (_) => false);
        } else {
          Navigator.of(context).pop();
        }

        return true;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSizes.size20,
                  right: AppSizes.size20,
                  top: AppSizes.size20,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (widget.fromSplash) {
                      MoenageManager.logScreenEvent(name: 'Main Home');
                      AutoRouter.of(context).pushAndPopUntil(
                          MainHomeScreenRoute(isFirstLoad: true),
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
              ),
              const SizedBox(
                height: AppSizes.size30,
              ),
              purchaseGiftAndFilterWidget(),
              const SizedBox(
                height: AppSizes.size20,
              ),
              searchTxtWidget(),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Expanded(
                child: gridViewWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget purchaseGiftAndFilterWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Purchase gift cards".toUpperCase(),
            style: AppTextStyle.regular36.copyWith(
              fontFamily: "Bebas",
            ),
          ),
          GestureDetector(
            onTap: () async {
              searchController.text = '';
              await presenter.getCategoryList(context);
              selectCategoryBottomSheet();
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                const Icon(
                  Icons.tune_outlined,
                  color: AppColors.whiteColor,
                ),
                if (model.filterApplied &&
                    (model.selectedCategory != null &&
                        model.selectedCategory.toString() != "All"))
                  Container(
                    height: AppSizes.size10,
                    width: AppSizes.size10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.brownishColor,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget searchTxtWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
      child: TextFormFieldWidget(
        labelText: 'Search',
        controller: searchController,
        onChanged: (String? value) {
          _debounce(() {
            presenter.getVouchersList(
              context,
              serachText: value.toString() != '' ? value : null,
            );
          });
        },
      ),
    );
  }

  void selectCategoryBottomSheet() {
    showModalBottomSheet(
      backgroundColor: AppColors.secondaryContainerColor,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setX) {
            return SizedBox(
              height: 500,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Category',
                            style: AppTextStyle.semiBold16.copyWith(
                              color: AppColors.blackColor,
                            ),
                          ),
                          categoryDropDownWidget(setX)
                        ],
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      const Divider(
                        color: AppColors.blackColor,
                      ),
                      const SizedBox(
                        height: AppSizes.size6,
                      ),
                      Text(
                        'Sort By',
                        style: AppTextStyle.bold16.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.size10,
                      ),
                      radioDecoration(
                        'Price - Low to High',
                        Range.lowToHigh,
                        setX,
                      ),
                      radioDecoration(
                        'Price - High to Low',
                        Range.highToLow,
                        setX,
                      ),
                      radioDecoration(
                        'Order A - Z',
                        Range.aToz,
                        setX,
                      ),
                      radioDecoration(
                        'Order Z - A',
                        Range.zToa,
                        setX,
                      ),
                      const Divider(
                        color: AppColors.blackColor,
                      ),
                      Text(
                        'Filters',
                        style: AppTextStyle.bold16
                            .copyWith(color: AppColors.blackColor),
                      ),
                      const SizedBox(
                        height: AppSizes.size16,
                      ),
                      Text(
                        'Select price',
                        style: AppTextStyle.semiBold14
                            .copyWith(color: AppColors.blackColor),
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                          inactiveTrackColor: AppColors.btnBlueColor,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 10,
                          ),
                          showValueIndicator: ShowValueIndicator.always,
                          valueIndicatorColor: AppColors.btnBlueColor,
                          valueIndicatorTextStyle: AppTextStyle.semiBold16,
                        ),
                        child: RangeSlider(
                          min: model.priceRange.start,
                          max: model.priceRange.end,
                          values: model.filterPrice,
                          activeColor: AppColors.primaryContainerColor,
                          inactiveColor: AppColors.whiteColor,
                          labels: RangeLabels(
                            model.filterPrice.start.round().toString(),
                            model.filterPrice.end.round().toString(),
                          ),
                          onChanged: (value) {
                            setX(() {
                              model.filterPrice = value;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'AED ${model.priceRange.start.toInt()}',
                            style: AppTextStyle.semiBold14.copyWith(
                              color: AppColors.blackColor,
                            ),
                          ),
                          Text(
                            'AED ${model.priceRange.end.toInt()}',
                            style: AppTextStyle.semiBold14.copyWith(
                              color: AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.size24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: RoundedBorderButton(
                                text: AppConstString.reset,
                                bColor: AppColors.blueButtonColor,
                                tColor: AppColors.blueButtonColor,
                                onTap: () {
                                  model.filterPrice = RangeValues(
                                    model.priceRange.start,
                                    model.priceRange.end,
                                  );
                                  model.range = Range.lowToHigh;
                                  model.selectedCategory = null;
                                  model.filterApplied = false;
                                  setX(() {});
                                },
                              ),
                            ),
                            const SizedBox(
                              width: AppSizes.size20,
                            ),
                            Expanded(
                              child: PrimaryButton(
                                text: AppConstString.apply,
                                onTap: () {
                                  model.filterApplied = true;
                                  Navigator.of(context).pop();
                                  presenter.getVouchersList(context);
                                  final properties = MoEProperties();
                                  properties
                                      .addAttribute(
                                          TriggeringCondition.category,
                                          model.selectedCategory?.categoryCode)
                                      .addAttribute(
                                          TriggeringCondition.screenName,
                                          "BuyGiftCards")
                                      .addAttribute(
                                          TriggeringCondition.sortBy,
                                          model.range == Range.aToz
                                              ? "Order Ascending"
                                              : "Order Descending")
                                      .addAttribute(
                                          TriggeringCondition.priceFilter,
                                          [
                                            model.filterPrice.start,
                                            model.filterPrice.end
                                          ].toString());
                                  // .setNonInteractiveEvent();
                                  MoenageManager.logEvent(
                                    MoenageEvent.filterApplied,
                                    properties: properties,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value) => setState(() {}));
  }

  Widget categoryDropDownWidget(StateSetter setX) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Text(
          'All',
          style: AppTextStyle.semiBold14.copyWith(color: AppColors.blackColor),
        ),
        value: model.selectedCategory,
        onChanged: (value) {
          setX(() {
            model.selectedCategory = value as CategoryModel;
          });
        },
        items: model.categoryList
            .map((item) => DropdownMenuItem<CategoryModel>(
                  value: item,
                  child: Text(
                    item.categoryName.toString(),
                    style: AppTextStyle.semiBold14.copyWith(
                      color: AppColors.blackColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        buttonStyleData: ButtonStyleData(
          height: 40,
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.dropDownBg,
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
          ),
          iconSize: 20,
          iconEnabledColor: AppColors.blackColor,
          iconDisabledColor: AppColors.blackColor,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 180,
          width: 150,
          elevation: 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: AppColors.dropDownBg,
          ),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(AppColors.whiteColor),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding:
              EdgeInsets.only(left: AppSizes.size16, right: AppSizes.size16),
        ),
      ),
    );
  }

  Widget radioDecoration(String title, Range value, StateSetter setter) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.size8,
        vertical: AppSizes.size4,
      ),
      child: Row(
        children: [
          Radio<Range>(
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: AppColors.backgroundColor,
            value: value,
            groupValue: model.range,
            onChanged: (Range? range) {
              setter(() {
                model.range = range ?? model.range;
              });
            },
          ),
          const SizedBox(
            width: AppSizes.size16,
          ),
          Text(
            title,
            style:
                AppTextStyle.semiBold14.copyWith(color: AppColors.blackColor),
          ),
        ],
      ),
    );
  }

  Widget gridViewWidget() {
    return model.vouchersList == null
        ? GridView.count(
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.size20,
            childAspectRatio: 1.2,
            mainAxisSpacing: AppSizes.size20,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: AppSizes.size20),
            children: List.generate(
              10,
              (index) {
                return Container(
                  padding: const EdgeInsets.only(
                    top: AppSizes.size12,
                    left: AppSizes.size12,
                    right: AppSizes.size12,
                    bottom: AppSizes.size10,
                  ),
                  margin: EdgeInsets.only(
                    left: index.isEven ? AppSizes.size20 : 0,
                    right: index.isOdd ? AppSizes.size20 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainerColor,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                        color: const Color(0xff000029).withOpacity(0.3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color(0xff000029).withOpacity(0.1),
                          ),
                          child: CustomShrimmerWidget.rectangular(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      CustomShrimmerWidget.rectangular(
                        height: 8,
                        width: MediaQuery.of(context).size.width,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      const CustomShrimmerWidget.rectangular(
                        height: 8,
                        width: 100,
                      )
                    ],
                  ),
                );
              },
            ),
          )
        : model.vouchersList!.isEmpty
            ? Center(
                child: Text(
                  'Gift Vouchers Not Found',
                  style: AppTextStyle.bold20.copyWith(
                    color: AppColors.blueButtonColor,
                  ),
                ),
              )
            : GridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.size20,
                childAspectRatio: 1.2,
                mainAxisSpacing: AppSizes.size20,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: AppSizes.size20),
                children: List.generate(
                  model.vouchersList!.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        MoenageManager.logScreenEvent(
                            name: 'Gift Card Details');
                        final properties = MoEProperties();
                        properties
                            .addAttribute(
                                TriggeringCondition.giftOption, "MySelf")
                            .addAttribute(TriggeringCondition.giftName,
                                model.vouchersList![index].name.toString())
                            .addAttribute(
                              TriggeringCondition.firstName,
                              GlobalSingleton.userInformation.firstName
                                  .toString(),
                            )
                            .addAttribute(
                              TriggeringCondition.emailId,
                              GlobalSingleton.userInformation.email.toString(),
                            )
                            .addAttribute(
                              TriggeringCondition.mobileNumber,
                              "${GlobalSingleton.userInformation.countryCode.toString()}${GlobalSingleton.userInformation.mobileNumber.toString()}",
                            )
                            .setNonInteractiveEvent();
                        MoenageManager.logEvent(
                          MoenageEvent.giftOptionSelected,
                          properties: properties,
                        );

                        AutoRouter.of(context).push(
                          GiftCardDetailsScreenRoute(
                            presenter: BasicGiftCardDetailsPresenter(
                              supplierCode: model
                                  .vouchersList![index].supplierCode
                                  .toString(),
                              giftCategory: model
                                  .vouchersList![index].categoryName
                                  .toString(),
                              giftcardId: model.vouchersList![index].giftcardId!
                                  .toInt(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: AppSizes.size12,
                          left: AppSizes.size12,
                          right: AppSizes.size12,
                          bottom: AppSizes.size10,
                        ),
                        margin: EdgeInsets.only(
                          left: index.isEven ? AppSizes.size20 : 0,
                          right: index.isOdd ? AppSizes.size20 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainerColor,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                              color: const Color(0xff000029).withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                height: 80,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color:
                                      const Color(0xff000029).withOpacity(0.1),
                                ),
                                child: networkImage(
                                  model.vouchersList![index].mobileImage
                                      .toString(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              model.vouchersList![index].name.toString(),
                              textScaleFactor: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.bold14.copyWith(
                                color: AppColors.blackColor,
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Expanded(
                              child: Text(
                                model.vouchersList![index].categoryName
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.regular12
                                    .copyWith(color: AppColors.blackColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
  }
}
