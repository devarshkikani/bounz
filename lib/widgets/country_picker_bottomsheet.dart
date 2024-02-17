import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/models/country/country_model.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/employment/employment_model.dart';
import 'package:moengage_flutter/properties.dart';

Future<void> countryPickerBottomsheet({
  required BuildContext buildContext,
  required String text,
  required bool location,
  required Function(Country country) passValue,
}) async {
  List<Country> countryList =
      GlobalSingleton.countryList ?? await getCountryList(buildContext);

  List<Country> searchCountry = countryList;
  var notMatchCountryText = AppConstString.noResultFound;

  List<Country> search(String query) {
    return countryList
        .where((e) =>
            e.name!.toLowerCase().contains(query) ||
            e.code!.toLowerCase().contains(query) ||
            e.nationality!.toLowerCase().contains(query) ||
            e.countryCode!.toLowerCase().contains(query))
        .toList();
  }

  showModalBottomSheet(
    backgroundColor: AppColors.secondaryContainerColor,
    context: buildContext,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              top: AppSizes.size20,
              right: AppSizes.size20,
              left: AppSizes.size20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: SizedBox(
              height: 350,
              width: MediaQuery.of(ctx).size.width,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: AppTextStyle.bold16.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldWidget(
                        hintText: AppConstString.search,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.size20,
                            vertical: AppSizes.size16),
                        suffixIconConstraints: BoxConstraints.loose(
                          const Size(50, 50),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            AutoRouter.of(ctx).pop();
                          },
                          child: const Center(
                            child: Icon(
                              Icons.search,
                              size: 24,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            searchCountry = search(value.toLowerCase());

                            final properties = MoEProperties();
                            properties
                                .addAttribute(
                                    TriggeringCondition.searchKeyword, value)
                                .setNonInteractiveEvent();
                            MoenageManager.logEvent(
                              MoenageEvent.search,
                              properties: properties,
                            );
                          } else if (value!.isEmpty) {
                            searchCountry = countryList;
                          } else {
                            searchCountry = countryList;
                            final properties = MoEProperties();
                            properties
                                .addAttribute(
                                    TriggeringCondition.searchKeyword, value)
                                .setNonInteractiveEvent();
                            MoenageManager.logEvent(
                              MoenageEvent.searchFailed,
                              properties: properties,
                            );
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: searchCountry.isNotEmpty
                        ? ListView.builder(
                            itemCount: searchCountry.length,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onTap: () {
                                  StorageManager.setStringValue(
                                      key: AppStorageKey
                                          .mobileNumberCountryImage,
                                      value: searchCountry[index]
                                          .image
                                          .toString());
                                  passValue(searchCountry[index]);
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 15.0,
                                        backgroundImage: NetworkImage(
                                            searchCountry[index]
                                                .image
                                                .toString()),
                                      ),
                                      const SizedBox(
                                        width: AppSizes.size16,
                                      ),
                                      Flexible(
                                        child: Text(
                                          searchCountry[index].name.toString(),
                                          style: AppTextStyle.semiBold16
                                              .copyWith(
                                                  color: AppColors.blackColor),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: AppSizes.size6,
                                      ),
                                      Container(
                                        height: 1,
                                        width: 7,
                                        color: AppColors.blackColor,
                                      ),
                                      const SizedBox(
                                        width: AppSizes.size6,
                                      ),
                                      location
                                          ? const SizedBox()
                                          : Text(
                                              '(+${searchCountry[index].countryCode})',
                                              style: AppTextStyle.semiBold16
                                                  .copyWith(
                                                      color:
                                                          AppColors.blackColor),
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                            notMatchCountryText,
                            style: AppTextStyle.bold22.copyWith(
                              color: AppColors.brownishColor,
                            ),
                          )),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<List<Country>> getCountryList(BuildContext context) async {
  List<Country> countryList = [];
  final Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
    context: context,
    url: ApiPath.apiEndPoint + ApiPath.country,
  );
  if (response != null) {
    for (Map<String, dynamic> i in response['data']['values']['top_country']) {
      countryList.add(Country.fromJson(i));
    }
    for (Map<String, dynamic> i in response['data']['values']
        ['other_country']) {
      countryList.add(Country.fromJson(i));
    }
    GlobalSingleton.countryList = countryList;
  }
  return countryList;
}

Future<List<EmploymentModel>> getEmploymentTypeList(
    BuildContext context) async {
  List<EmploymentModel> employmentList = [];
  final Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
    context: context,
    url: ApiPath.apiEndPoint + ApiPath.employmentType,
  );
  if (response != null) {
    for (Map<String, dynamic> i in response['data']['values']) {
      employmentList.add(EmploymentModel.fromJson(i));
    }
    GlobalSingleton.employmentTypeList = employmentList;
  }
  return employmentList;
}
