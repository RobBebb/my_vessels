// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_vessels/src/constants/test_vessels.dart';
import 'package:my_vessels/src/features/vessels/domain/vessel.dart';
import 'package:my_vessels/src/utils/delay.dart';

class FakeVesselsRepository {
  FakeVesselsRepository({this.addDelay = true});
  final bool addDelay;
  final List<Vessel> _vessels = kTestVessels;

  List<Vessel> getVesselsList() {
    return _vessels;
  }

  Vessel? getVessel(String id) {
    return _getVessel(_vessels, id);
  }

  Future<List<Vessel>> fetchVesselsList() async {
    await delay(addDelay);
    return Future.value(_vessels);
  }

  Stream<List<Vessel>> watchVesselsList() async* {
    await delay(addDelay);
    yield _vessels;
  }

  Stream<Vessel?> watchVessel(String id) {
    return watchVesselsList().map((vessels) => _getVessel(vessels, id));
  }

  static Vessel? _getVessel(List<Vessel> vessels, String id) {
    try {
      return vessels.firstWhere((vessel) => vessel.id == id);
    } catch (e) {
      return null;
    }
  }
}

final vesselsRepositoryProvider = Provider<FakeVesselsRepository>((ref) {
  return FakeVesselsRepository();
});

final vesselsListStreamProvider =
    StreamProvider.autoDispose<List<Vessel>>((ref) {
  final vesselsRepository = ref.watch(vesselsRepositoryProvider);
  return vesselsRepository.watchVesselsList();
});

final vesselsListFutureProvider =
    FutureProvider.autoDispose<List<Vessel>>((ref) {
  final vesselsRepository = ref.watch(vesselsRepositoryProvider);
  return vesselsRepository.fetchVesselsList();
});

final vesselProvider =
    StreamProvider.autoDispose.family<Vessel?, String>((ref, id) {
  debugPrint('Created vesselProvider with idL $id');
  final vesselsRepository = ref.watch(vesselsRepositoryProvider);
  return vesselsRepository.watchVessel(id);
});
