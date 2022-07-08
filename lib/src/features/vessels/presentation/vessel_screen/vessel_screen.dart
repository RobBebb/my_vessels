import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_vessels/src/common_widgets/async_value_widget.dart';
import 'package:my_vessels/src/common_widgets/custom_image.dart';
import 'package:my_vessels/src/common_widgets/empty_placeholder_widget.dart';
import 'package:my_vessels/src/common_widgets/responsive_center.dart';
import 'package:my_vessels/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_vessels/src/constants/app_sizes.dart';
import 'package:my_vessels/src/features/vessels/data/fake_vessels_repository.dart';
import 'package:my_vessels/src/features/vessels/domain/vessel.dart';
import 'package:my_vessels/src/features/vessels/presentation/home_app_bar/home_app_bar.dart';
import 'package:my_vessels/src/localization/string_hardcoded.dart';

/// Shows the product page for a given product ID.
class VesselScreen extends StatelessWidget {
  const VesselScreen({Key? key, required this.vesselId}) : super(key: key);
  final String vesselId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Consumer(
        builder: (context, ref, _) {
          final vesselValue = ref.watch(vesselProvider(vesselId));
          return AsyncValueWidget<Vessel?>(
            value: vesselValue,
            data: (product) => product == null
                ? EmptyPlaceholderWidget(
                    message: 'Product not found'.hardcoded,
                  )
                : CustomScrollView(
                    slivers: [
                      ResponsiveSliverCenter(
                        padding: const EdgeInsets.all(Sizes.p16),
                        child: VesselDetails(vessel: product),
                      ),
                      // ProductReviewsList(productId: productId),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

/// Shows all the product details along with actions to:
/// - leave a review
/// - add to cart
class VesselDetails extends StatelessWidget {
  const VesselDetails({Key? key, required this.vessel}) : super(key: key);
  final Vessel vessel;

  @override
  Widget build(BuildContext context) {
    return ResponsiveTwoColumnLayout(
      startContent: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: CustomImage(imageUrl: vessel.imageUrl),
        ),
      ),
      spacing: Sizes.p16,
      endContent: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(vessel.name, style: Theme.of(context).textTheme.headline6),
              gapH8,
              if (vessel.imo > 0) ...[
                gapH8,
                Text(vessel.imo.toString(),
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
              if (vessel.mmsi > 0) ...[
                gapH8,
                Text(vessel.mmsi.toString(),
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
              gapH8,
              const Divider(),
              gapH8,
              Text(vessel.length.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.bodyMedium),
              gapH8,
              Text(vessel.year.toString(),
                  style: Theme.of(context).textTheme.bodyMedium),
              const Divider(),
              gapH8,
              Text(vessel.aisVesselType.toString(),
                  style: Theme.of(context).textTheme.bodyMedium),
              gapH8,
              Text(vessel.flag, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
