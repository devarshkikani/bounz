import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:flutter/material.dart';
import 'package:xml2json/xml2json.dart';

import 'rssfeed_web_view_screen.dart';

@RoutePage()
class RssFeedDemo extends StatefulWidget {
  final bool fromSplash;
  final String? urlLink;
  final String? titleName;
  const RssFeedDemo(
      {@PathParam('urlLink') this.urlLink,
      @PathParam('titleName') this.titleName,
      @PathParam('fromSplash') this.fromSplash = false,
      super.key});

  @override
  State<RssFeedDemo> createState() => _RssFeedDemoState();
}

class _RssFeedDemoState extends State<RssFeedDemo> {
  final Xml2Json xml2json = Xml2Json();
  List topStoryList = [];

  Future topStories() async {
    String baseURL =
        "https://simplikaapi.bounzrewards.com/target/GulfNewsRSS/rss/?generatorName=nrss&categories=";
    String response = await NetworkDio.getRssFeed(
      url: baseURL + (widget.urlLink ?? ""),
    );
    log(response);
    xml2json.parse(response.toString());
    var jsonData = xml2json.toGData();
    var data = json.decode(jsonData);
    topStoryList = data['rss']['channel']['item'];
    log(data.toString());
  }

  @override
  void initState() {
    topStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Column(
          children: [
            Row(
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
                  width: 30,
                ),
                Text(
                  widget.titleName != null
                      ? widget.titleName!.replaceAll('%20', ' ')
                      : '',
                  style: AppTextStyle.black22,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                future: topStories(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.75,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                height:
                                    MediaQuery.of(context).size.height / 1.1,
                                child: topStoryList.isEmpty
                                    ? Center(
                                        child: Text(
                                          AppConstString.noDataFound,
                                          style: AppTextStyle.bold20
                                              .copyWith(letterSpacing: 0),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: topStoryList.length,
                                        itemBuilder:
                                            ((BuildContext context, int index) {
                                          return Container(
                                            height: 80,
                                            width: 80,
                                            margin: EdgeInsets.only(
                                                bottom: topStoryList[
                                                            topStoryList
                                                                    .length -
                                                                1] ==
                                                        topStoryList[index]
                                                    ? 60
                                                    : 10),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RssFeedWebView(
                                                      urlLink:
                                                          topStoryList[index]
                                                                      ['link']
                                                                  ['\$t']
                                                              .toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.network(
                                                        (topStoryList[index]
                                                                    ["image"]
                                                                is List)
                                                            ? (topStoryList[index]
                                                                        ["image"])
                                                                    .elementAt(
                                                                        0)["fullUrl"]
                                                                ["\$t"]
                                                            : topStoryList[index]
                                                                        [
                                                                        "image"]
                                                                    ["fullUrl"]
                                                                ["\$t"],
                                                        fit: BoxFit.cover,
                                                        height: 60,
                                                        width: 60,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        topStoryList[index]
                                                                    ['title']
                                                                ['__cdata']
                                                            .toString(),
                                                        style: AppTextStyle
                                                            .light16,
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              // child: ListTile(
                                              //   onTap: () async {
                                              //     if (!await launchUrl(Uri.parse(
                                              //         topStoryList[index]['link']
                                              //                 ['\$t']
                                              //             .toString()))) {
                                              //       throw Exception(
                                              //           'Could not launch ${topStoryList[index]['link']['\$t'].toString()}');
                                              //     }
                                              //   },
                                              // horizontalTitleGap: 10,
                                              // minVerticalPadding: 20,
                                              // contentPadding:
                                              //     const EdgeInsets.symmetric(
                                              //   vertical: 10,
                                              // horizontal: 10,
                                              // ),
                                              // title: Text(
                                              //   topStoryList[index]['title']
                                              //           ['__cdata']
                                              //       .toString(),
                                              //   maxLines: 2,
                                              //   overflow: TextOverflow.ellipsis,
                                              // ),
                                              // leading: Image.network(
                                              //   (topStoryList[index]["image"]
                                              //           is List)
                                              //       ? (topStoryList[index]["image"])
                                              //               .elementAt(0)["fullUrl"]
                                              //           ["\$t"]
                                              //       : topStoryList[index]["image"]
                                              //           ["fullUrl"]["\$t"],
                                              //   fit: BoxFit.cover,
                                              //   height: 80,
                                              //   width: 80,
                                              // ),
                                            ),
                                          );
                                        })),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
