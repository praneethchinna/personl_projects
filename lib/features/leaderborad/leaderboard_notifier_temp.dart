import 'dart:async';

import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_providers.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_response_model.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ysr_project/services/user/user_data.dart';

import 'leaderboard_notifier.dart';

final leaderBoardNotifierProvider =
    AutoDisposeAsyncNotifierProvider<LeaderBoardNotifierTemp, LeaderBoardState>(
        LeaderBoardNotifierTemp.new);

class LeaderBoardNotifierTemp
    extends AutoDisposeAsyncNotifier<LeaderBoardState> {
  String stateName = '';
  String parliament = '';
  String assembly = '';
  Types currentType = Types.state;
  int page = 1;
  @override
  FutureOr<LeaderBoardState> build() async {
    final value = await ref.watch(futurePointsProvider.future);
    stateName = value.state!;
    parliament = value.parliament!;
    assembly = value.constituency!;

    final topLevels = await ref
        .read(repoProvider)
        .getTopLevels(level: currentType.description, value: stateName);

    final leaderboardData = await ref
        .read(repoProvider)
        .getLevels(level: currentType.description, value: stateName, page: 1);

    final userRank = await ref.read(repoProvider).getLoggedUserRank(
        level: currentType.description,
        value: stateName,
        userId: ref.read(userProvider).userId);

    return LeaderBoardState(
        loggedUserRank: userRank,
        topLevels: topLevels.leaderboard,
        leaderBoards: LeaderBoards(
            leaderBoards: leaderboardData.leaderboard,
            hasNext: leaderboardData.hasNext),
        type: Types.state,
        names: indianStatesAndUnionTerritories,
        selectedName: stateName);
  }

  Future<void> updateType(Types type) async {
    page = 1;
    currentType = type;
    state = AsyncValue.loading();
    final selectedName = switch (type) {
      Types.state => stateName,
      Types.parliament => parliament,
      Types.assembly => assembly,
    };
    final topLevels = await ref
        .read(repoProvider)
        .getTopLevels(level: currentType.description, value: selectedName);

    final leaderboardData = await ref.read(repoProvider).getLevels(
        level: currentType.description, value: selectedName, page: 1);
    final userRank = await ref.read(repoProvider).getLoggedUserRank(
        level: currentType.description,
        value: selectedName,
        userId: ref.read(userProvider).userId);

    final names = switch (type) {
      Types.state => indianStatesAndUnionTerritories,
      Types.parliament => parliamentNames,
      Types.assembly => assemblies,
    };

    state = AsyncValue.data(LeaderBoardState(
        loggedUserRank: userRank,
        topLevels: topLevels.leaderboard,
        leaderBoards: LeaderBoards(
            leaderBoards: leaderboardData.leaderboard,
            hasNext: leaderboardData.hasNext),
        type: type,
        names: names,
        selectedName: selectedName));
  }

  Future<void> updateValue(String value) async {
    page = 1;
    state = AsyncValue.loading();
    final topLevels = await ref
        .read(repoProvider)
        .getTopLevels(level: currentType.description, value: value);

    final leaderboardData = await ref
        .read(repoProvider)
        .getLevels(level: currentType.description, value: value, page: 1);

    final userRank = await ref.read(repoProvider).getLoggedUserRank(
        level: currentType.description,
        value: value,
        userId: ref.read(userProvider).userId);

    state = AsyncData(state.value!.copyWith(
        loggedUserRank: userRank,
        topLevels: topLevels.leaderboard,
        leaderBoards: LeaderBoards(
            leaderBoards: leaderboardData.leaderboard,
            hasNext: leaderboardData.hasNext),
        selectedName: value));
  }

  Future<void> loadMore() async {
    page++;
    final leaderboardData = await ref.read(repoProvider).getLevels(
        level: currentType.description,
        value: state.value!.selectedName,
        page: page);
    List<LeaderboardEntry> value = state.value!.leaderBoards.leaderBoards;
    value.addAll(leaderboardData.leaderboard);

    state = AsyncData(state.value!.copyWith(
        leaderBoards: state.value!.leaderBoards
            .copyWith(hasNext: leaderboardData.hasNext, leaderBoards: value),
        selectedName: state.value!.selectedName));
  }
}

List<String> indianStatesAndUnionTerritories = [
  "Andhra Pradesh",
  "Arunachal Pradesh",
  "Assam",
  "Bihar",
  "Chhattisgarh",
  "Goa",
  "Gujarat",
  "Haryana",
  "Himachal Pradesh",
  "Jharkhand",
  "Karnataka",
  "Kerala",
  "Madhya Pradesh",
  "Maharashtra",
  "Manipur",
  "Meghalaya",
  "Mizoram",
  "Nagaland",
  "Odisha",
  "Punjab",
  "Rajasthan",
  "Sikkim",
  "Tamil Nadu",
  "Telangana",
  "Tripura",
  "Uttar Pradesh",
  "Uttarakhand",
  "West Bengal",
  "Andaman and Nicobar Islands",
  "Chandigarh",
  "Dadra and Nagar Haveli and Daman and Diu",
  "Delhi",
  "Jammu and Kashmir",
  "Ladakh",
  "Lakshadweep",
  "Puducherry",
];

List<String> parliamentNames = [
  'Eluru',
  'Amalapuram',
  'Bapatla',
  'Ongole',
  'Nellore',
  'Tirupati',
  'Kadapa',
  'Rajampet',
  'Nandyal',
  'Kurnool',
  'Anantapur',
  'Hindupur',
  'Chittoor',
  'Anakapalli',
  'Kakinada',
  'Rajahmundry',
  'Narasapuram',
  'Vijayawada',
  'Machilipatnam',
  'Narasaraopet',
  'Guntur',
  'Visakhapatnam',
  'Araku',
  'Srikakulam',
  'Vizianagaram'
];

List<String> assemblies = [
  'Achanta',
  'Addanki',
  'Adoni',
  'Allagadda',
  'Alur',
  'Amadalavalasa',
  'Amalapuram',
  'Anakapalle',
  'Anantapur Urban',
  'Anaparthy',
  'Araku Valley',
  'Atmakur',
  'Avanigadda',
  'Badvel',
  'Banaganapalle',
  'Bapatla',
  'Bhimavaram',
  'Bhimili',
  'Bobbili',
  'Chandragiri',
  'Cheepurupalli',
  'Chilakaluripet',
  'Chintalapudi',
  'Chirala',
  'Chittoor',
  'Chodavaram',
  'Darsi',
  'Denduluru',
  'Dharmavaram',
  'Dhone',
  'Elamanchili',
  'Eluru',
  'Etcherla',
  'Gajapathinagaram',
  'Gajuwaka',
  'Gangadhara Nellore',
  'Gannavaram',
  'Gannavaram',
  'Giddalur',
  'Gopalapuram',
  'Gudivada',
  'Gudur',
  'Guntakal',
  'Guntur East',
  'Guntur West',
  'Gurajala',
  'Hindupur',
  'Ichchapuram',
  'Jaggampeta',
  'Jaggayyapeta',
  'Jammalamadugu',
  'Kadapa',
  'Kadiri',
  'Kaikalur',
  'Kakinada City',
  'Kakinada Rural',
  'Kalyandurg',
  'Kamalapuram',
  'Kandukur',
  'Kanigiri',
  'Kavali',
  'Kodumur',
  'Kodur',
  'Kondapi',
  'Kothapeta',
  'Kovur',
  'Kovvur',
  'Kuppam',
  'Kurnool',
  'Kurupam',
  'Macherla',
  'Machilipatnam',
  'Madakasira',
  'Madanapalle',
  'Madugula',
  'Mandapeta',
  'Mangalagiri',
  'Mantralayam',
  'Markapuram',
  'Mummidivaram',
  'Mydukur',
  'Mylavaram',
  'Nagari',
  'Nandigama',
  'Nandikotkur',
  'Nandyal',
  'Narasannapeta',
  'Narasapuram',
  'Narasaraopet',
  'Narsipatnam',
  'Nellimarla',
  'Nellore City',
  'Nellore Rural',
  'Nidadavole',
  'Nuzvid',
  'Ongole',
  'Paderu',
  'Palakollu',
  'Palakonda',
  'Palamaner',
  'Palasa',
  'Pamarru',
  'Panyam',
  'Parchur',
  'Parvathipuram',
  'Pathapatnam',
  'Pattikonda',
  'Payakaraopet',
  'Pedakurapadu',
  'Pedana',
  'Peddapuram',
  'Penamaluru',
  'Pendurthi',
  'Penukonda',
  'Pileru',
  'Pithapuram',
  'Polavaram',
  'Ponnuru',
  'Prathipadu',
  'Prathipadu',
  'Proddatur',
  'Pulivendla',
  'Punganur',
  'Puthalapattu',
  'Puttaparthi',
  'Rajahmundry City',
  'Rajahmundry Rural',
  'Rajam',
  'Rajampet',
  'Rajanagaram',
  'Ramachandrapuram',
  'Rampachodavaram',
  'Raptadu',
  'Rayachoti',
  'Rayadurg',
  'Razole',
  'Repalle',
  'Salur',
  'Santhanuthalapadu',
  'Sarvepalli',
  'Sathyavedu',
  'Sattenapalle',
  'Singanamala',
  'Srikakulam',
  'Srikalahasti',
  'Srisailam',
  'Srungavarapukota',
  'Sullurpeta',
  'Tadepalligudem',
  'Tadikonda',
  'Tadipatri',
  'Tanuku',
  'Tekkali',
  'Tenali',
  'Thamballapalle',
  'Tirupati',
  'Tiruvuru',
  'Tuni',
  'Udayagiri',
  'Undi',
  'Unguturu',
  'Uravakonda',
  'Vemuru',
  'Venkatagiri',
  'Vijayawada Central',
  'Vijayawada East',
  'Vijayawada West',
  'Vinukonda',
  'Visakhapatnam East',
  'Visakhapatnam North',
  'Visakhapatnam South',
  'Visakhapatnam West',
  'Vizianagaram',
  'Yemmiganur',
  'Yerragondapalem',
];
