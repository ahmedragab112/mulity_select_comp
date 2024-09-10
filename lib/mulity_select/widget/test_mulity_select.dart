import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uitraning/mulity_select/cubit/mulity_select_cubit.dart';

import '../cubit/mulity_select_state.dart';

class MultiSelectComponent extends StatelessWidget {
  const MultiSelectComponent({
    super.key,
    required this.majors,
    required this.selectedIndexes,
    required this.onSelectionChanged,
  });

  final List<String> majors;
  final List<int> selectedIndexes;
  final Function(List<int>) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MajorsCubit(majors, selectedIndexes),
      child: Builder(
        builder: (context) => _multiSelectBody(
          context,
          context.read<MajorsCubit>(),
        ),
      ),
    );
  }

  Widget _multiSelectBody(BuildContext context, MajorsCubit cubit) =>
      GestureDetector(
        onTap: () => _showBottomSheet(context, cubit),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black12),
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildSelectedMajorsChips(context, cubit)),
              const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            ],
          ),
        ),
      );

  Widget _buildSelectedMajorsChips(BuildContext context, MajorsCubit cubit) {
    return BlocBuilder<MajorsCubit, MajorsState>(
      builder: (context, state) {
        final selectedMajors =
            state.selectedIndexes.map((index) => state.majors[index]).toList();
        final showEllipsis = selectedMajors.length > 5;

        return Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: selectedMajors.isEmpty
              ? [
                  const Text('No selected options',
                      style: TextStyle(color: Colors.black))
                ]
              : List<Widget>.generate(
                  state.showAllChips
                      ? selectedMajors.length
                      : showEllipsis
                          ? 5
                          : selectedMajors.length,
                  (index) => Chip(
                    label: Text(
                      selectedMajors[index],
                      style: const TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.3),
                    deleteIconColor: Colors.red,
                    onDeleted: () {
                      final updatedIndexes = List<int>.from(
                          state.selectedIndexes)
                        ..remove(state.majors.indexOf(selectedMajors[index]));
                      cubit.updateSelection(updatedIndexes);
                      onSelectionChanged(updatedIndexes);
                    },
                  ),
                )
            ..addIf(
                showEllipsis,
                GestureDetector(
                  onTap: () => cubit.updateShowAllChips(!state.showAllChips),
                  child: const Chip(label: Text('...')),
                )),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, MajorsCubit cubit) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              minChildSize: 0.6,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return BlocProvider.value(
                  value: cubit,
                  child: _majorBottomSheet(cubit, scrollController),
                );
              },
            ),
          );
        },
      ).then((value) {
        cubit.filterMajors('');
      });

  Widget _majorBottomSheet(
      MajorsCubit cubit, ScrollController scrollController) {
    return BlocBuilder<MajorsCubit, MajorsState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.red.withOpacity(0.5)),
                      ),
                      hintText: "Search options...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.red.withOpacity(0.5)),
                      ),
                    ),
                    onChanged: (text) => cubit.filterMajors(text),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final allIndexes = List<int>.generate(
                            state.majors.length, (index) => index);
                        context.read<MajorsCubit>().updateSelection(allIndexes);
                        onSelectionChanged(allIndexes);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.pinkAccent, Colors.red],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: const Text(
                          "Select All",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<MajorsCubit>().updateSelection([]);
                        onSelectionChanged([]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.grey, Colors.black38],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: const Text(
                          "Unselect All",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red, width: 1)),
                  child: _buildSelectedMajorsChips(context, cubit),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              state.filteredMajors.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(child: Text("No majors found")))
                  : SliverList.builder(
                      itemCount: state.filteredMajors.length,
                      itemBuilder: (context, index) {
                        final major = state.filteredMajors[index];
                        final isSelected = state.selectedIndexes.contains(
                          state.majors.indexOf(major),
                        );
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 6.0),
                          title: Text(
                            major,
                            style: TextStyle(
                              color: isSelected ? Colors.red : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: _customCheckbox(isSelected),
                          onTap: () {
                            final updatedIndexes =
                                List<int>.from(state.selectedIndexes);
                            final originalIndex = state.majors.indexOf(major);
                            if (isSelected) {
                              updatedIndexes.remove(originalIndex);
                            } else {
                              updatedIndexes.add(originalIndex);
                            }
                            context
                                .read<MajorsCubit>()
                                .updateSelection(updatedIndexes);
                            onSelectionChanged(updatedIndexes);
                          },
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _customCheckbox(bool isSelected) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
            color: isSelected ? Colors.red : Colors.grey, width: 1.5),
        color: isSelected ? Colors.red : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )
          : null,
    );
  }
}

extension ListExtension<T> on List<T> {
  void addIf(bool condition, T value) {
    if (condition) add(value);
  }
}
