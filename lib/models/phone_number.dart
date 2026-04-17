/// Represents a phone number associated with a SIM slot.
class PhoneNumber {
  /// The SIM slot index (0-based).
  final int simSlot;

  /// The phone number associated with the SIM card.
  /// May be empty if the carrier does not store it on the SIM.
  final String phoneNumber;

  /// Creates a [PhoneNumber] instance.
  const PhoneNumber({
    required this.simSlot,
    required this.phoneNumber,
  });

  /// Creates a [PhoneNumber] from a [Map].
  factory PhoneNumber.fromMap(Map<String, dynamic> map) {
    return PhoneNumber(
      simSlot: map['simSlot'] as int? ?? 0,
      phoneNumber: map['phoneNumber'] as String? ?? '',
    );
  }

  @override
  String toString() =>
      'PhoneNumber(simSlot: $simSlot, phoneNumber: $phoneNumber)';
}
