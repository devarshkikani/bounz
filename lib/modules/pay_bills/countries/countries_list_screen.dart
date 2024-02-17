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
import 'package:bounz_revamp_app/modules/pay_bills/countries/countries_list_view.dart';
import 'package:bounz_revamp_app/modules/pay_bills/countries/countries_list_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/operators/operator_list_presenter.dart';
import 'package:bounz_revamp_app/modules/pay_bills/countries/countries_list_presenter.dart';

@RoutePage()
class CountriesListScreen extends StatefulWidget {
  final CountriesListPresenter countryListPresenter;
  const CountriesListScreen(
    this.countryListPresenter, {
    Key? key,
  }) : super(key: key);

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen>
    implements CountriesListView {
  TextEditingController searchController = TextEditingController();
  int? select;

  late CountryListModel model;

  @override
  void refreshModel(CountryListModel countryListModel) {
    if(mounted) {
      setState(() {
      model = countryListModel;
    });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.countryListPresenter.updateModel = this;
    widget.countryListPresenter.countryList(context: context);
  }

  void filterSearchResults(String query) {
    setState(() {
      model.dublicateCountryList = model.countryList
          .where((item) =>
              item['country_name'].toLowerCase().contains(query.toLowerCase()))
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
              AppConstString.selectCountry.toUpperCase(),
              style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
            ),
            const SizedBox(
              height: AppSizes.size20,
            ),
            SizedBox(
              height: 55.0,
              child: searchTextFieldWidget(),
            ),
            const SizedBox(
              height: AppSizes.size20,
            ),
            listOfCountryWidget(),
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
        filterSearchResults(value!);
      },
    );
  }

  Widget listOfCountryWidget() {
    return Expanded(
      child: model.dublicateCountryList == null
          ? const SizedBox()
          : model.dublicateCountryList!.isEmpty
              ? Center(
                  child: Text(
                    'Country list is empty',
                    style: AppTextStyle.bold22.copyWith(
                      color: AppColors.brownishColor,
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    bottom: AppSizes.size16,
                    left: AppSizes.size10,
                    right: AppSizes.size10,
                  ),
                  itemCount: model.dublicateCountryList!.length,
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
                        MoenageManager.logScreenEvent(name: 'Oprator List');

                        AutoRouter.of(context).push(
                          OperatorListScreenRoute(
                            presenter: BasicOpreterListPresenter(
                              serviceModel: model.serviceModel,
                              country: model.dublicateCountryList![index],
                            ),
                          ),
                        );
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: networkImage(
                                model.dublicateCountryList![index]
                                    ['country_img_url'],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: AppSizes.size20,
                          ),
                          Text(
                            model.dublicateCountryList![index]['country_name']
                                .toString(),
                            style: AppTextStyle.semiBold16,
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
