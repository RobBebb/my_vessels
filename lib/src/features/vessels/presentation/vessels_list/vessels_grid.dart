import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_vessels/src/common_widgets/async_value_widget.dart';
import 'package:my_vessels/src/constants/app_sizes.dart';
import 'package:my_vessels/src/features/vessels/data/fake_vessels_repository.dart';
import 'package:my_vessels/src/features/vessels/domain/vessel.dart';
import 'package:my_vessels/src/features/vessels/presentation/vessels_list/vessel_card.dart';
import 'package:my_vessels/src/localization/string_hardcoded.dart';
import 'package:my_vessels/src/routing/app_router.dart';

/// A widget that displays the list of products that match the search query.
class VesselsGrid extends ConsumerWidget {
  const VesselsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vesselsListValue = ref.watch(vesselsListStreamProvider);
    return AsyncValueWidget<List<Vessel>>(
      value: vesselsListValue,
      data: (vessels) => vessels.isEmpty
          ? Center(
              child: Text(
                'No vessels found'.hardcoded,
                style: Theme.of(context).textTheme.headline4,
              ),
            )
          : VesselsLayoutGrid(
              itemCount: vessels.length,
              itemBuilder: (_, index) {
                final vessel = vessels[index];
                return VesselCard(
                  vessel: vessel,
                  onPressed: () => context.goNamed(
                    AppRoute.vessel.name,
                    params: {'id': vessel.id},
                  ),
                );
              },
            ),
    );
  }
}

/// Grid widget with content-sized items.
/// See: https://codewithandrea.com/articles/flutter-layout-grid-content-sized-items/
class VesselsLayoutGrid extends StatelessWidget {
  const VesselsLayoutGrid({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  /// Total number of items to display.
  final int itemCount;

  /// Function used to build a widget for a given index in the grid.
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    // use a LayoutBuilder to determine the crossAxisCount
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      // 1 column for width < 500px
      // then add one more column for each 250px
      final crossAxisCount = max(1, width ~/ 250);
      // once the crossAxisCount is known, calculate the column and row sizes
      // set some flexible track sizes based on the crossAxisCount with 1.fr
      final columnSizes = List.generate(crossAxisCount, (_) => 1.fr);
      final numRows = (itemCount / crossAxisCount).ceil();
      // set all the row sizes to auto (self-sizing height)
      final rowSizes = List.generate(numRows, (_) => auto);
      // Custom layout grid. See: https://pub.dev/packages/flutter_layout_grid
      return LayoutGrid(
        columnSizes: columnSizes,
        rowSizes: rowSizes,
        rowGap: Sizes.p24, // equivalent to mainAxisSpacing
        columnGap: Sizes.p24, // equivalent to crossAxisSpacing
        children: [
          // render all the items with automatic child placement
          for (var i = 0; i < itemCount; i++) itemBuilder(context, i),
        ],
      );
    });
  }
}
