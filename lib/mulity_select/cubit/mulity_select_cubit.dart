// Cubit class
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uitraning/mulity_select/cubit/mulity_select_state.dart';

class OptionsCubit extends Cubit<OptionsState> {
  OptionsCubit(List<String> options, List<int> selectedIndexes)
      : super(OptionsState(
          options: options,
          selectedIndexes: selectedIndexes,
          showAllChips: false,
          filteredOptions: options,
        ));

  void updateSelection(List<int> newIndexes) {
    emit(state.copyWith(selectedIndexes: newIndexes));
  }

  void updateShowAllChips(bool show) {
    emit(state.copyWith(showAllChips: show));
  }

  void filterOptions(String query) {
    final filteredOptions = state.options
        .where((major) => major.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(state.copyWith(filteredOptions: filteredOptions));
  }
}
