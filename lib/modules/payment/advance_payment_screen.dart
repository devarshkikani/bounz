import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/modules/pay_bills/operators/operator_list_presenter.dart';
import 'package:bounz_revamp_app/modules/pay_bills/countries/countries_list_presenter.dart';

@RoutePage()
class AdvancePaymentScreen extends StatefulWidget {
  final ServiceModel? serviceModel;
  final String? country;
  const AdvancePaymentScreen({
    Key? key,
    this.serviceModel,
    this.country,
  }) : super(key: key);

  @override
  State<AdvancePaymentScreen> createState() => _AdvancePaymentScreenState();
}

class _AdvancePaymentScreenState extends State<AdvancePaymentScreen> {
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController elecBoardController = TextEditingController();
  TextEditingController actNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController numberController = TextEditingController();
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
              AppConstString.advancePayment.toUpperCase(),
              style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
            ),
            const SizedBox(
              height: AppSizes.size20,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: bodyView(),
              ),
            ),
            confirmButton(),
          ],
        ),
      ),
    );
  }

  Widget bodyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        countryWidget(),
        const SizedBox(
          height: AppSizes.size20,
        ),
        stateWidget(),
        const SizedBox(
          height: AppSizes.size20,
        ),
        elecBoardsWidget(),
        const SizedBox(
          height: AppSizes.size20,
        ),
        actNumberInputTxt(),
        const SizedBox(
          height: AppSizes.size20,
        ),
        actNumberInputTxt(),
        const SizedBox(
          height: AppSizes.size20,
        ),
      ],
    );
  }

  Widget countryWidget() {
    return TextFormFieldWidget(
      controller: countryController,
      onTap: null,
      labelText: AppConstString.country,
      suffixIconConstraints: BoxConstraints.loose(
        const Size(53, 35),
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          MoenageManager.logScreenEvent(name: 'Countries List');

          AutoRouter.of(context).push(
            CountriesListScreenRoute(
              countryListPresenter:
                  BasicCountriesListPresenter(widget.serviceModel!),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.size8),
          child: Text(
            AppConstString.change,
            style: AppTextStyle.bold12.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  Widget elecBoardsWidget() {
    return TextFormFieldWidget(
      controller: elecBoardController,
      onTap: null,
      labelText: AppConstString.elecBoards,
      suffixIconConstraints: BoxConstraints.loose(
        const Size(53, 35),
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          if (widget.serviceModel != null && widget.country != null) {
            MoenageManager.logScreenEvent(name: 'Operator List');

            AutoRouter.of(context).push(
              OperatorListScreenRoute(
                presenter: BasicOpreterListPresenter(
                  country: {},
                  serviceModel: ServiceModel(),
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.size8),
          child: Text(
            AppConstString.change,
            style: AppTextStyle.bold12.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  Widget stateWidget() {
    return TextFormFieldWidget(
      controller: stateController,
      onTap: null,
      labelText: AppConstString.state,
      suffixIconConstraints: BoxConstraints.loose(
        const Size(53, 35),
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          if (widget.country != null) {
            // AutoRouter.of(context).push(
            // StateListScreenRoute(
            //   country: widget.country!,
            //   serviceModel: widget.serviceModel,
            // ),
            // );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.size8),
          child: Text(
            AppConstString.change,
            style: AppTextStyle.bold12.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  Widget actNumberInputTxt() {
    return TextFormFieldWidget(
      labelText: "Account or Premise Number",
      controller: actNumberController,
    );
  }

  Widget amountInputTxt() {
    return TextFormFieldWidget(
      labelText: "Enter Amount you want to pay",
      controller: amountController,
    );
  }

  Widget confirmButton() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: AppSizes.size12,
          ),
          Center(
            child: PrimaryButton(
              onTap: () {
                // AutoRouter.of(context).push(
                //   CheckoutScreenRoute(screenName: 'billsScreen'),
                // );
              },
              text: AppConstString.confirm,
              showShadow: true,
            ),
          ),
          const SizedBox(
            height: AppSizes.size30,
          ),
        ],
      ),
    );
  }
}
