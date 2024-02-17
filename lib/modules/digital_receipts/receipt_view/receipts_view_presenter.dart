import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import '../../../models/degital_receipts/new_receipt_model.dart';
import 'package:bounz_revamp_app/modules/digital_receipts/receipt_view/receipts_view_view.dart';

class ReceiptViewPresenter {
  Future getReceiptDetail(BuildContext context) async {}
  set updateView(ReceiptsView receiptsView) {}
}

class BasicReceiptViewPresenter implements ReceiptViewPresenter {
  late Digitalreceiptmodel model;
  late ReceiptsView view;

  BasicReceiptViewPresenter({
    required String billNumber,
    required String partnerId,
  }) {
    view = ReceiptsView();
    model = Digitalreceiptmodel(
      billNumber: billNumber,
      partnerId: partnerId,
      apiLogin: true,
    );
  }

  @override
  Future<void> getReceiptDetail(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.getPosReceipt,
      queryParameters: {
        "bill_number": model.billNumber,
        "partner_id": model.partnerId,
      },
      context: context,
    );
    if (response != null) {
      final pdfUrl = await getDownloadPdfURL(context);
      model = Digitalreceiptmodel.fromJson(response['data']['values']);
      model.downloadURL = pdfUrl;
    }
    model.apiLogin = false;
    view.refreshModel(model);
  }

  @override
  set updateView(ReceiptsView receiptsView) {
    view = receiptsView;
    view.refreshModel(model);
  }

  Future getDownloadPdfURL(BuildContext context) async {
    String pdfPath = '';
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.downloadPDF,
      queryParameters: {
        "bill_number": model.billNumber,
        "partner_id": model.partnerId,
      },
      context: context,
    );

    if (response != null) {
      pdfPath = response['data']['values']['pdf_path'];
    }
    return pdfPath;
  }
}
