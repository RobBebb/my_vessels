import 'package:flutter_test/flutter_test.dart';
import 'package:my_vessels/src/constants/test_vessels.dart';
import 'package:my_vessels/src/features/vessels/data/fake_vessels_repository.dart';

void main() {
  FakeVesselsRepository makeVesselsRepository() => FakeVesselsRepository(
        addDelay: false,
      );
  group('FakeProductRepository', () {
    test('getVesselsList returns global list', () {
      final vesselsRepository = makeVesselsRepository();
      expect(vesselsRepository.getVesselsList(), kTestVessels);
    });
    test('getVessel(1) returns first vessel', () {
      final vesselsRepository = makeVesselsRepository();
      expect(vesselsRepository.getVessel('1'), kTestVessels[0]);
    });
    test('getVessel(100) returns null', () {
      final vesselRepository = makeVesselsRepository();
      expect(vesselRepository.getVessel('100'), null);
    });
  });

  test('fetchVesselsList returns global list', () async {
    final vesselsRepository = makeVesselsRepository();
    expect(await vesselsRepository.fetchVesselsList(), kTestVessels);
  });

  test('watchVesselsList emits global list', () {
    final vesselsRepository = makeVesselsRepository();
    expect(vesselsRepository.watchVesselsList(), emits(kTestVessels));
  });

  test('watchVessel(1) emits first item', () {
    final vesselsRepository = makeVesselsRepository();
    expect(vesselsRepository.watchVessel('1'), emits(kTestVessels[0]));
  });

  test('watchVessel(100) emits null', () {
    final vesselsRepository = makeVesselsRepository();
    expect(vesselsRepository.watchVessel('100'), emits(null));
  });
}
