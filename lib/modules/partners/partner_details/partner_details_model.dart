import 'package:bounz_revamp_app/models/partner/emirates_draw_model.dart';
import 'package:bounz_revamp_app/models/partner/new_partner_detail_model.dart';
import 'package:bounz_revamp_app/models/partner/partner_outlet_detail_model.dart';

class PartnerDetailsModel {
  List<double> distance;
  NewPartnerDetailModel? newPartnerDetailModel;
  PartneroOutletDetailModel? partneroOutletDetailModel;
  EmiratesDrawModel? emirates;
  List<AllBranchLobType> collectList;
  List<AllBranchLobType> redeemList;
  String merchantCode;
  String brandCode;
  double branchlat;
  double branchlong;
  String? emiratesUrl;
  String? partnerUrl;
  int selectedBranchIndex;
  PartnerDetailsModel({
    required this.distance,
    required this.merchantCode,
    required this.brandCode,
    required this.branchlat,
    required this.branchlong,
    required this.collectList,
    required this.redeemList,
    required this.selectedBranchIndex,
    this.newPartnerDetailModel,
    this.emirates,
    this.emiratesUrl,
    this.partnerUrl,
  });
}
