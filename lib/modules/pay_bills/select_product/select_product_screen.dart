import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/modules/mobile_recharge/mobile_recharge_one_screen.dart';
import 'package:bounz_revamp_app/modules/pay_bills/select_product/select_product_view.dart';
import 'package:bounz_revamp_app/modules/pay_bills/select_product/select_product_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/select_product/select_product_presenter.dart';

@RoutePage()
class SelectProductScreen extends StatefulWidget {
  final SelectProductPresenter presenter;
  const SelectProductScreen(
    this.presenter, {
    Key? key,
  }) : super(key: key);

  @override
  State<SelectProductScreen> createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen>
    implements SelectProductView {
  TextEditingController searchController = TextEditingController();
  int? select;

  late SelectProductModel model;

  @override
  void initState() {
    super.initState();
    widget.presenter.updateModel = this;
    widget.presenter.getProductList(context);
  }

  @override
  void refreshModel(SelectProductModel operatorlistModel) {
    if(mounted) {
      setState(() {
      model = operatorlistModel;
      // model.productList['']
    });
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      model.dublicateProductList = model.productList
          .where((item) =>
              item.name.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
                Navigator.of(context).pop();
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
              "Select Plans",
              style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
            ),
            const SizedBox(
              height: AppSizes.size20,
            ),
            SizedBox(
              height: AppSizes.size60,
              child: searchTextFieldWidget(),
            ),
            const SizedBox(
              height: AppSizes.size20,
            ),
            listOfStateWidget()
          ],
        ),
      ),
    );
  }

  Widget searchTextFieldWidget() {
    return TextFormFieldWidget(
      labelText: AppConstString.search,
      suffixIcon: const Icon(
        Icons.search,
        color: AppColors.whiteColor,
        size: AppSizes.size26,
      ),
      controller: searchController,
      onChanged: (value) {
        filterSearchResults(value ?? '');
      },
    );
  }

  Widget listOfStateWidget() {
    return Expanded(
      child: model.dublicateProductList == null
          ? const SizedBox()
          : model.dublicateProductList!.isEmpty
              ? Center(
                  child: Text(
                    'Plans not found',
                    style: AppTextStyle.bold22.copyWith(
                      color: AppColors.brownishColor,
                    ),
                  ),
                )
              : listViewWidget(),
    );
  }

  Widget listViewWidget() {
    return ListView.separated(
      itemCount: model.dublicateProductList!.length,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.size20),
          child: HorizontalDottedLine(
            height: 1.5,
            color: AppColors.blackColor.withOpacity(0.2),
            width: MediaQuery.of(context).size.width,
          ),
        );
      },
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              select = index;
            });
            MoenageManager.logScreenEvent(name: 'Add Details');

            AutoRouter.of(context).push(
              AddDetailsScreenRoute(
                productModel: model.dublicateProductList![index],
                calulationDetails: model.calulationDetails ?? {},
                country: model.country,
                accountNumbe: null,
                accountQualifier: null,
                phoneNumber: null,
              ),
            );
          },
          child: listDecoration(index),
        );
      },
    );
  }

  Widget listDecoration(int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                height: 40,
                width: 40,
                child: networkImage(
                  model.operatorModel.operatorImgUrl.toString(),
                ),
              ),
            ),
            const SizedBox(
              width: AppSizes.size16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.dublicateProductList![index].name.toString(),
                    style: AppTextStyle.semiBold14
                        .copyWith(color: AppColors.secondaryBackgroundColor),
                  ),
                  const SizedBox(
                    height: AppSizes.size4,
                  ),
                  Text(
                    model.dublicateProductList![index].description.toString(),
                    style: AppTextStyle.regular12.copyWith(
                      color:
                          AppColors.secondaryBackgroundColor.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size6,
                  ),
                  Text(
                    '${model.dublicateProductList![index].sourceCurrency} ${model.dublicateProductList![index].pricesRetailAmount}',
                    style: AppTextStyle.bold14
                        .copyWith(color: AppColors.secondaryBackgroundColor),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: AppSizes.size12,
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.size4),
              child: select == index
                  ? Image.asset(AppAssets.greenTick)
                  : const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: AppSizes.size14,
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
