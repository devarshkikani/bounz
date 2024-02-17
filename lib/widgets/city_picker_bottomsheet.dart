import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/city/city_model.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/properties.dart';

void showCityPicker({
  required String text,
  required BuildContext buildContext,
  required Function(City city) onSelect,
}) async {
  List<City> cityList =
      GlobalSingleton.cityList ?? await getCityList(buildContext);
  List<City> searchCity = cityList;
  List<City> search(String query) {
    return cityList
        .where((e) => e.cityName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  showModalBottomSheet(
    backgroundColor: AppColors.secondaryContainerColor,
    isScrollControlled: true,
    shape: const OutlineInputBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: buildContext,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter stx) {
          final viewInsets = MediaQuery.of(context).viewInsets;
          return Padding(
            padding: EdgeInsets.only(
              bottom: viewInsets.bottom,
            ),
            child: SizedBox(
              height: 350.0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.size20, AppSizes.size20, AppSizes.size20, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          text,
                          style: AppTextStyle.bold16.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSizes.size20,
                    ),
                    TextFormFieldWidget(
                      suffixIconConstraints: BoxConstraints.loose(
                        const Size(50, 50),
                      ),
                      labelText: "Search",
                      suffixIcon: const Center(
                        child: Icon(
                          Icons.search,
                          color: AppColors.whiteColor,
                          size: AppSizes.size24,
                        ),
                      ),
                      onChanged: (String? value) {
                        if (value != null) {
                          searchCity = search(value);
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
                          searchCity = cityList;
                        } else {
                          searchCity = cityList;
                        }

                        stx(() {});
                      },
                    ),
                    const SizedBox(
                      height: AppSizes.size10,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: searchCity.length,
                        padding: const EdgeInsets.only(
                          top: AppSizes.size10,
                        ),
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: AppSizes.size20,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            child: Row(
                              children: [
                                Text(
                                  searchCity[index].cityName.toString(),
                                  style: AppTextStyle.semiBold16.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              onSelect(searchCity[index]);
                              Navigator.of(context).pop();
                            },
                          );
                        },
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
  );
}

Future<List<City>> getCityList(BuildContext context) async {
  List<City> cityList = [];
  final Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
    context: context,
    url: ApiPath.apiEndPoint + ApiPath.city,
  );
  if (response != null) {
    for (Map<String, dynamic> i in response['data']['values']) {
      cityList.add(City.fromJson(i));
    }
    GlobalSingleton.cityList = cityList;
  }
  return cityList;
}
