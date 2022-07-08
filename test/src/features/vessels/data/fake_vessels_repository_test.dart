import 'package:flutter_test/flutter_test.dart';
import 'package:my_vessels/src/constants/test_vessels.dart';
import 'package:my_vessels/src/features/vessels/data/fake_vessels_repository.dart';

void main() {
  test('getVesselsList returns global list', () {
    final vesselsRepository = FakeVesselsRepository();
    expect(vesselsRepository.getVesselsList(), kTestVessels);
  });
  test('getVessel(1) returns first vessel', () {
    final vesselsRepository = FakeVesselsRepository();
    expect(vesselsRepository.getVessel('1'), kTestVessels[0]);
  });
  test('getVessel(100) returns null', () {
    final vesselRepository = FakeVesselsRepository();
    expect(vesselRepository.getVessel('100'), null);
  });
}
