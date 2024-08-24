
import 'package:flutter/material.dart';

import '../model/episodebyseasonmodel.dart';
import '../webservice/apiservices.dart';

class EpisodeProvider extends ChangeNotifier {
  EpisodeBySeasonModel episodeBySeasonModel = EpisodeBySeasonModel();

  bool loading = false;

  Future<void> getEpisodeBySeason(seasonId, showId) async {
    loading = true;
    episodeBySeasonModel = await ApiService().episodeBySeason(seasonId, showId);
    loading = false;
    notifyListeners();
  }

  clearProvider() {
    debugPrint("<================ clearProvider ================>");
    episodeBySeasonModel = EpisodeBySeasonModel();
  }
}
