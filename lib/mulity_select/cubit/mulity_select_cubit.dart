// Cubit class
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uitraning/mulity_select/cubit/mulity_select_state.dart';

class MajorsCubit extends Cubit<MajorsState> {
  MajorsCubit(List<String> majors, List<int> selectedIndexes)
      : super(MajorsState(
          majors: majors,
          selectedIndexes: selectedIndexes,
          showAllChips: false,
          filteredMajors: majors,
        ));

  void updateSelection(List<int> newIndexes) {
    emit(state.copyWith(selectedIndexes: newIndexes));
  }

  void updateShowAllChips(bool show) {
    emit(state.copyWith(showAllChips: show));
  }

  void filterMajors(String query) {
    final filteredMajors = state.majors
        .where((major) => major.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(state.copyWith(filteredMajors: filteredMajors));
  }
}
