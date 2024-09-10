import 'package:equatable/equatable.dart';

class OptionsState extends Equatable {
  final List<String> options;
  final List<int> selectedIndexes;
  final List<String> filteredOptions;
  final bool showAllChips;
  const OptionsState(
      {required this.options,
      required this.selectedIndexes,
      required this.filteredOptions,
      required this.showAllChips});

  @override
  List<Object?> get props =>
      [options, selectedIndexes, filteredOptions, showAllChips];

  OptionsState copyWith({
    List<String>? options,
    List<int>? selectedIndexes,
    bool? showAllChips,
    List<String>? filteredOptions,
  }) {
    return OptionsState(
      options: options ?? this.options,
      showAllChips: showAllChips ?? this.showAllChips,
      selectedIndexes: selectedIndexes ?? this.selectedIndexes,
      filteredOptions: filteredOptions ?? this.filteredOptions,
    );
  }
}
