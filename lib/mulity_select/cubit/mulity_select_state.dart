import 'package:equatable/equatable.dart';

class MajorsState extends Equatable {
  final List<String> majors;
  final List<int> selectedIndexes;
  final List<String> filteredMajors;
  final bool showAllChips;
  const MajorsState(
      {required this.majors,
      required this.selectedIndexes,
      required this.filteredMajors,
      required this.showAllChips});

  @override
  List<Object?> get props => [majors, selectedIndexes, filteredMajors, showAllChips];

  MajorsState copyWith({
    List<String>? majors,
    List<int>? selectedIndexes,
    bool? showAllChips,
    List<String>? filteredMajors,
  }) {
    return MajorsState(
      majors: majors ?? this.majors,
      showAllChips: showAllChips ?? this.showAllChips,
      selectedIndexes: selectedIndexes ?? this.selectedIndexes,
      filteredMajors: filteredMajors ?? this.filteredMajors,
    );
  }
}
