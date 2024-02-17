import 'package:bounz_revamp_app/models/country/country_model.dart';
import 'package:bounz_revamp_app/models/link_smile_acc/link_smile_account.dart';
import 'package:bounz_revamp_app/models/reward_exchange/all_member_data.dart';

class LinkAccRewardExchangeViewModel {
  LinkSmileAccModel? linkSmileAccModel;
  bool? status;
  Country? country;
  DataAllMember? allMemberModel;

  LinkAccRewardExchangeViewModel({this.linkSmileAccModel,this.status = false,this.country,this.allMemberModel});
}