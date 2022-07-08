// ignore_for_file: public_member_api_docs, sort_constructors_first
/// * The vessel identifier is an important concept and can have its own type.
typedef VesselID = String;

/// Class representing a vessel
class Vessel {
  const Vessel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.length,
    required this.year,
    this.aisVesselType = 37,
    this.flag = "KY",
    this.imo = 0,
    this.mmsi = 0,
  });

  /// Unique vessel id
  final VesselID id;
  final String imageUrl;
  final String name;
  final int aisVesselType;
  final String flag;
  final double length;
  final int year;
  final int imo;
  final int mmsi;

  @override
  String toString() {
    return 'Vessel(id: $id, imageUrl: $imageUrl, name: $name, aisVesselType: $aisVesselType, flag: $flag, length: $length, year: $year, imo: $imo, mmsi: $mmsi)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vessel &&
        other.id == id &&
        other.imageUrl == imageUrl &&
        other.name == name &&
        other.aisVesselType == aisVesselType &&
        other.flag == flag &&
        other.length == length &&
        other.year == year &&
        other.imo == imo &&
        other.mmsi == mmsi;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        imageUrl.hashCode ^
        name.hashCode ^
        aisVesselType.hashCode ^
        flag.hashCode ^
        length.hashCode ^
        year.hashCode ^
        imo.hashCode ^
        mmsi.hashCode;
  }
}
