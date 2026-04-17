/// Represents a SIM card installed on the device.
class SimCard {
  /// The carrier name (e.g., "Telkomsel", "XL").
  final String carrierName;

  /// The ICC ID of the SIM card.
  final String iccId;

  /// The SIM slot index (0-based).
  final int simSlot;

  /// Creates a [SimCard] instance.
  const SimCard({
    required this.carrierName,
    required this.iccId,
    required this.simSlot,
  });

  /// Creates a [SimCard] from a [Map].
  factory SimCard.fromMap(Map<String, dynamic> map) {
    return SimCard(
      carrierName: map['carrierName'] as String? ?? 'Unknown',
      iccId: map['iccId'] as String? ?? 'Unknown',
      simSlot: map['simSlot'] as int? ?? 0,
    );
  }

  /// Converts this [SimCard] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'carrierName': carrierName,
      'iccId': iccId,
      'simSlot': simSlot,
    };
  }

  @override
  String toString() =>
      'SimCard(carrierName: $carrierName, simSlot: $simSlot)';
}
