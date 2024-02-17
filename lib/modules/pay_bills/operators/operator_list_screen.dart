import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/modules/pay_bills/operators/operator_list_view.dart';
import 'package:bounz_revamp_app/modules/pay_bills/operators/operator_list_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/operators/operator_list_presenter.dart';
import 'package:bounz_revamp_app/modules/pay_bills/select_product/select_product_presenter.dart';

@RoutePage()
class OperatorListScreen extends StatefulWidget {
  final OperatorListPresenter presenter;
  const OperatorListScreen(
    this.presenter, {
    Key? key,
  }) : super(key: key);

  @override
  State<OperatorListScreen> createState() => _OperatorListScreenState();
}

class _OperatorListScreenState extends State<OperatorListScreen>
    implements OperatorListView {
  TextEditingController searchController = TextEditingController();
  int? select;

  late OperatorListModel model;

  @override
  void initState() {
    super.initState();
    widget.presenter.updateModel = this;
    widget.presenter.operatorList(context);
  }

  @override
  void refreshModel(OperatorListModel operatorlistModel) {
    if(mounted) {
      setState(() {
      model = operatorlistModel;
    });
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      model.dublicateOpreterList = model.opreterList
          .where((item) => item.operatorName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
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
              "Select Operator",
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
      child: model.dublicateOpreterList == null
          ? const SizedBox()
          : model.dublicateOpreterList!.isEmpty
              ? Center(
                  child: Text(
                    'Operator not found',
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
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: model.dublicateOpreterList!.length,
      padding: const EdgeInsets.only(
        bottom: AppSizes.size16,
        left: AppSizes.size10,
        right: AppSizes.size10,
      ),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: AppSizes.size16,
        );
      },
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              select = index;
            });
            MoenageManager.logScreenEvent(name: 'Select Product');

            AutoRouter.of(context).push(
              SelectProductScreenRoute(
                presenter: BasicSelectProductPresenter(
                  serviceModel: model.serviceModel,
                  country: model.country,
                  operatorModel: model.dublicateOpreterList![index],
                ),
              ),
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: networkImage(
                    model.dublicateOpreterList![index].operatorImgUrl
                        .toString(),
                  ),
                ),
              ),
              const SizedBox(
                width: AppSizes.size20,
              ),
              Flexible(
                child: Text(
                  model.dublicateOpreterList![index].operatorName.toString(),
                  style: AppTextStyle.semiBold16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
