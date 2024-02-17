import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:barcode_widgets/barcode_flutter.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/degital_receipts/new_receipt_model.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/modules/digital_receipts/receipt_view/text_widget.dart';
import 'package:bounz_revamp_app/modules/digital_receipts/receipt_view/receipts_view_view.dart';
import 'package:bounz_revamp_app/modules/digital_receipts/receipt_view/receipts_view_presenter.dart';

@RoutePage()
class ReceiptViewScreen extends StatefulWidget {
  final ReceiptViewPresenter presenter;
  const ReceiptViewScreen(this.presenter, {Key? key}) : super(key: key);

  @override
  State<ReceiptViewScreen> createState() => _ReceiptViewScreenState();
}

class _ReceiptViewScreenState extends State<ReceiptViewScreen>
    implements ReceiptsView {
  late Digitalreceiptmodel model;

  @override
  void refreshModel(Digitalreceiptmodel downloadPdfModel) {
    if(mounted) {
      setState(() {
      model = downloadPdfModel;
    });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.presenter.updateView = this;
    widget.presenter.getReceiptDetail(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: AppSizes.size20, top: AppSizes.size20),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(40)),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppAssets.backgroundLayer,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppConstString.receipts,
                            style: AppTextStyle.regular36.copyWith(
                              fontFamily: 'Bebas',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (await canLaunchUrl(
                                Uri.parse(model.downloadURL ?? ''))) {
                              final properties = MoEProperties();
                              properties
                                  .addAttribute(
                                      TriggeringCondition.downloadStatus,
                                      'download')
                                  .addAttribute(TriggeringCondition.screenName,
                                      "Receipts View")
                                  .addAttribute(TriggeringCondition.billNumber,
                                      model.billNumber.toString())
                                  .addAttribute(TriggeringCondition.amount,
                                      model.sumTotal?.billAmount.toString())
                                  .setNonInteractiveEvent();
                              MoenageManager.logEvent(
                                MoenageEvent.receiptsDownload,
                                properties: properties,
                              );
                              await launchUrl(
                                Uri.parse(model.downloadURL ?? ''),
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          child: const Icon(
                            Icons.file_download_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: AppSizes.size40,
                  // ),
                  model.apiLogin == true ? const SizedBox() : _body()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                            color: const Color(0xff3E3D40), width: 1)),
                    child: Column(
                      children: [
                        // Icon(Icons.add_box),
                        if (model.merchantLogo != null)
                          Container(
                            height: 60,
                            margin: const EdgeInsets.symmetric(vertical: 25),
                            // color: red_color,
                            // width: MediaQuery.of(context).size.width / 2.3,
                            child: CachedNetworkImage(
                                // width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                imageUrl: model.merchantLogo != null
                                    ? model.merchantLogo.toString()
                                    : "",

                                // placeholder: (context, url) => Container(
                                //   height: 50,
                                //       margin: EdgeInsets.all(2),
                                //       child: PlaceHolder(),
                                //     ),
                                errorWidget: (context, url, error) {
                                  return Container(
                                    color: Colors.transparent,
                                  );
                                },
                                fit: BoxFit.cover),
                          ),

                        // SizedBox(height: 5),
                        Container(
                          color: const Color(0xffd9d9d9),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (model.merchantName != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, bottom: 0),
                                      child: TextWidget(
                                        // text: "T CHOITHRAM & SONS L.L.C",
                                        text: model.merchantName ?? "",
                                        size: 14,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (model.storeAddress != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, bottom: 0),
                                      child: TextWidget(
                                        // text: "P.O.BOX 5249, DUBAI, U.A.E.",
                                        text: model.storeAddress.toString(),
                                        size: 14,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (model.storeTrn != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, bottom: 0),
                                      child: TextWidget(
                                        // text: "TRN : 12345678901234567890",
                                        text: "TRN : " +
                                            model.storeTrn.toString(),
                                        size: 14,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff3E3D40)),
                      color: const Color(0xffd9d9d9),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        children: [
                          const SizedBox(height: 3),
                          if (model.storeName != null)
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, bottom: 0),
                                  child: TextWidget(
                                    text: model.storeName ?? "",
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 1),
                          if (model.storeEmail != null)
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, bottom: 0),
                                  child: TextWidget(
                                      text: model.storeEmail ?? "",
                                      weight: FontWeight.w400,
                                      size: 14),
                                ),
                              ],
                            ),
                          const SizedBox(height: 1),
                          if (model.storePhone != null)
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, bottom: 0),
                                  child: TextWidget(
                                    text: "Phone : " + model.storePhone!,
                                    weight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 1),
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 0, bottom: 0),
                                child: TextWidget(
                                  text: "Dubai, U.A.E.",
                                  weight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff3E3D40)),
                      color: const Color(0xffd9d9d9),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (model.billNumber != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, bottom: 0),
                                      child: TextWidget(
                                          text: "Bill No : " +
                                              model.billNumber.toString(),
                                          weight: FontWeight.bold,
                                          size: 15),
                                    ),
                                  const SizedBox(height: 5),
                                  if (model.cashierId != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, bottom: 0),
                                      child: TextWidget(
                                        text: "Cashier : " +
                                            model.cashierId.toString(),
                                        size: 15,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (model.billDate != null &&
                                        model.billDate
                                                .toString()
                                                .toLowerCase() !=
                                            "invalid date")
                                      TextWidget(
                                          // text: "Date : 05/08/2022",
                                          text: "Date : " +
                                              model.billDate.toString(),
                                          weight: FontWeight.bold,
                                          size: 15),
                                    const SizedBox(height: 5),
                                    if (model.billTime != null &&
                                        model.billTime
                                                .toString()
                                                .toLowerCase() !=
                                            "invalid date")
                                      TextWidget(
                                          text: "Time : " +
                                              model.billTime.toString(),
                                          weight: FontWeight.bold,
                                          size: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (model.invoiceDetails != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff3E3D40))),
                      child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(10.8),
                            2: FlexColumnWidth(5),
                            3: FlexColumnWidth(5),
                            4: FlexColumnWidth(5),
                          },
                          // border: TableBorder.symmetric(outside: ),
                          children: [
                            TableRow(
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    border: const Border(
                                      left: BorderSide(
                                        color: Colors.black,
                                      ),
                                      bottom: BorderSide(
                                        color: Colors.black,
                                      ),
                                      right: BorderSide(
                                        color: Colors.black,
                                      ),
                                    )),
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(left: 7.0, top: 5),
                                    child: TextWidget(
                                      text: 'Srl',
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 5.0, bottom: 2),
                                    child: TextWidget(
                                      text: 'PRODUCT DETAILS',
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0, top: 5),
                                    child: TextWidget(
                                      text: 'QTY',
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: TextWidget(
                                      text: 'PRICE',
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: TextWidget(
                                      text: 'AMOUNT',
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                            for (int i = 0;
                                i < model.invoiceDetails!.length;
                                i++)
                              TableRow(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 9.0, top: 7),
                                  child: TextWidget(
                                    text: model.invoiceDetails?[i].srNo
                                                .toString() ==
                                            "null"
                                        ? ""
                                        : model.invoiceDetails![i].srNo
                                            .toString(),
                                    weight: FontWeight.w400,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: SizedBox(
                                    width: 80,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (model.invoiceDetails?[i].skuBarcode
                                                .toString() !=
                                            "null")
                                          TextWidget(
                                            text: model.invoiceDetails?[i]
                                                        .skuBarcode
                                                        .toString() ==
                                                    "null"
                                                ? ""
                                                : model.invoiceDetails![i]
                                                    .skuBarcode
                                                    .toString(),
                                            weight: FontWeight.w400,
                                          ),
                                        if (model.invoiceDetails?[i].skuItemName
                                                .toString() !=
                                            "null")
                                          TextWidget(
                                            text: model.invoiceDetails?[i]
                                                        .skuItemName
                                                        .toString() ==
                                                    "null"
                                                ? ""
                                                : model.invoiceDetails![i]
                                                    .skuItemName
                                                    .toString(),
                                            weight: FontWeight.w400,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 11.5, top: 7),
                                  child: TextWidget(
                                    text: model.invoiceDetails?[i].skuQuantity
                                                .toString() ==
                                            "null"
                                        ? ""
                                        : model.invoiceDetails![i].skuQuantity
                                            .toString(),
                                    weight: FontWeight.w400,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (model.invoiceDetails?[i].skuPrice
                                                  .toString() !=
                                              "null" ||
                                          model.invoiceDetails?[i].skuPrice
                                                  .toString() !=
                                              null)
                                        TextWidget(
                                          text: model.invoiceDetails?[i]
                                                      .skuPrice
                                                      .toString() ==
                                                  "null"
                                              ? ""
                                              : model
                                                  .invoiceDetails![i].skuPrice!
                                                  .toStringAsFixed(2),
                                          weight: FontWeight.w400,
                                        ),
                                      const SizedBox(
                                        height: AppSizes.size2,
                                      ),
                                      if (model.invoiceDetails?[i].vatRate
                                                  .toString() !=
                                              "null" ||
                                          model.invoiceDetails?[i].vatRate
                                                  .toString() !=
                                              null)
                                        TextWidget(
                                          text: model.invoiceDetails?[i].vatRate
                                                      .toString() ==
                                                  "null"
                                              ? ""
                                              : model.invoiceDetails?[i].vatRate
                                                      .toString() ??
                                                  "",
                                          // "(TAX 5%)",
                                          weight: FontWeight.w400, size: 12,
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 7),
                                  child: TextWidget(
                                    text: model.invoiceDetails?[i].amount
                                                .toString() ==
                                            "null"
                                        ? ""
                                        : model.invoiceDetails![i].amount
                                            .toString(),
                                    weight: FontWeight.w400,
                                  ),
                                ),
                              ]),
                          ]),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff3E3D40)),
                        color: const Color(0xffd9d9d9)),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        if (model.sumTotal?.quantity != null)
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: TextWidget(
                                    text: "Quantity : " +
                                        model.sumTotal!.quantity.toString()),
                              )
                            ],
                          ),
                        if (model.sumTotal != null)
                          Container(
                            margin: const EdgeInsets.only(left: 110),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (model.sumTotal?.totalExclVat !=
                                              null)
                                            const TextWidget(
                                              text: "Total(excl of vat)",
                                              weight: FontWeight.w700,
                                            ),
                                          //const SizedBox(width: 10),
                                          if (model.sumTotal?.totalExclVat !=
                                              null)
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              alignment: Alignment.centerLeft,
                                              width: 100,
                                              child: TextWidget(
                                                  text: "AED " +
                                                      model.sumTotal!
                                                          .totalExclVat
                                                          .toString(),
                                                  weight: FontWeight.w700),
                                            ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (model.sumTotal?.taxAmount != null)
                                            const TextWidget(
                                                text: "Tax Amount",
                                                weight: FontWeight.w700),
                                          //const SizedBox(width: 30),
                                          if (model.sumTotal?.taxAmount != null)
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              alignment: Alignment.centerLeft,
                                              width: 100,
                                              child: TextWidget(
                                                  text: "AED " +
                                                      model.sumTotal!.taxAmount
                                                          .toString(),
                                                  weight: FontWeight.w700),
                                            ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (model.sumTotal?.billAmount !=
                                              null)
                                            const TextWidget(
                                                text: "Bill Amount",
                                                weight: FontWeight.w700),
                                          const SizedBox(width: 10),
                                          if (model.sumTotal?.billAmount !=
                                              null)
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              alignment: Alignment.centerLeft,
                                              width: 100,
                                              child: TextWidget(
                                                  text: "AED " +
                                                      model.sumTotal!.billAmount
                                                          .toString(),
                                                  weight: FontWeight.w700),
                                            ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (model.sumTotal?.paidAmount !=
                                              null)
                                            const TextWidget(
                                                text: "Paid Amount",
                                                weight: FontWeight.w700),
                                          const SizedBox(width: 10),
                                          if (model.sumTotal?.paidAmount !=
                                              null)
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              alignment: Alignment.centerLeft,
                                              width: 100,
                                              child: TextWidget(
                                                text: "AED " +
                                                    model.sumTotal!.paidAmount
                                                        .toString(),
                                                weight: FontWeight.w700,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                if (model.paymentDetails != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: model.paymentDetails!.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xff3E3D40)),
                                color: const Color(0xffd9d9d9)),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child:
                                          TextWidget(text: "Payment Details"),
                                    )
                                  ],
                                ),
                                Column(
                                  children: _paymentoptions(),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                if (model.promotionalDetails != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: model.promotionalDetails!.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xff3E3D40)),
                                color: const Color(0xffd9d9d9)),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.0, bottom: 25),
                                      child:
                                          TextWidget(text: "Promotion Details"),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: _promotionoptions(),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: FittedBox(
                    child: BarCodeImage(
                      params: Code39BarCodeParams(
                        // "20223543645324",
                        model.barcode ?? "",
                        barHeight: 60.0,
                        withText: false,
                      ),
                      onError: (error) {},
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (model.receiptNumber != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(
                          text: "Receipt Number : ",
                          size: 15,
                        ),
                        Flexible(
                          child: TextWidget(
                            text: model.receiptNumber ?? "",
                            size: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                if (model.footerMessageLine0 != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: model.footerMessageLine0 ?? "",
                          size: 13,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                if (model.footerMessageLine1 != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: model.footerMessageLine1 ?? "",
                          size: 13,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _promotionoptions() {
    List<Widget> _promoList = [];
    int length = model.promotionalDetails?.length ?? 0;
    for (int j = 0; j < length; j++) {
      // ignore: unused_local_variable
      // var _roomData = _roomtype[i];
      _promoList.add(Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        margin: const EdgeInsets.only(left: 110), //here
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (model.promotionalDetails?[j].promoType != null)
                    TextWidget(
                        text: model.promotionalDetails![j].promoType.toString(),
                        weight: FontWeight.w700),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              width: 100,
              child: Column(
                children: [
                  if (model.promotionalDetails?[j].value != null)
                    TextWidget(
                        text: model.promotionalDetails![j].value.toString(),
                        weight: FontWeight.w700),
                ],
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ));
    }
    return _promoList;
  }

  List<Widget> _paymentoptions() {
    List<Widget> _payList = [];
    int length = model.paymentDetails?.length ?? 0;
    for (int j = 0; j < length; j++) {
      // ignore: unused_local_variable
      // var _roomData = _roomtype[i];
      _payList.add(Container(
        margin: const EdgeInsets.only(left: 110),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (model.paymentDetails?[j].paymentType != null)
                    TextWidget(
                        text: model.paymentDetails![j].paymentType.toString(),
                        weight: FontWeight.w700),
                  // TextWidget(text: "**********1234", weight: FontWeight.w700),
                  // TextWidget(text: "Bounz Redeem", weight: FontWeight.w700),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              width: 100,
              child: Column(
                children: [
                  if (model.paymentDetails?[j].amount != null)
                    TextWidget(
                        text:
                            "AED " + model.paymentDetails![j].amount.toString(),
                        weight: FontWeight.w700),
                  // TextWidget(
                  //     text: "AED 1000.00", weight: FontWeight.w700),
                  // TextWidget(
                  //     text: "AED 100.00", weight: FontWeight.w700),
                ],
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ));
    }
    return _payList;
  }

  reciptContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(AppAssets.receipt), fit: BoxFit.fill),
      ),
    );
  }
}
