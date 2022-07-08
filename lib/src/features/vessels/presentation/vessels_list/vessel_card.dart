import 'package:flutter/material.dart';
import 'package:my_vessels/src/common_widgets/custom_image.dart';
import 'package:my_vessels/src/constants/app_sizes.dart';
import 'package:my_vessels/src/features/vessels/domain/vessel.dart';

/// Used to show a single product inside a card.
class VesselCard extends StatelessWidget {
  const VesselCard({Key? key, required this.vessel, this.onPressed})
      : super(key: key);
  final Vessel vessel;
  final VoidCallback? onPressed;

  // * Keys for testing using find.byKey()
  static const productCardKey = Key('product-card');

  @override
  Widget build(BuildContext context) {
    // TODO: Inject formatter
    return Card(
      child: InkWell(
        key: productCardKey,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomImage(imageUrl: vessel.imageUrl),
              gapH8,
              const Divider(),
              gapH8,
              Text(vessel.name, style: Theme.of(context).textTheme.headline6),
              if (vessel.imo > 0) ...[
                gapH8,
                Text(vessel.imo.toString(),
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
              if (vessel.mmsi > 0) ...{
                Text(vessel.mmsi.toString(),
                    style: Theme.of(context).textTheme.bodyMedium),
              }
            ],
          ),
        ),
      ),
    );
  }
}
