import 'package:flutter/material.dart';
import 'package:sms_sender/sms_sender.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SmsExampleApp(),
    );
  }
}

class SmsExampleApp extends StatefulWidget {
  const SmsExampleApp({super.key});

  @override
  State<SmsExampleApp> createState() => _SmsExampleAppState();
}

class _SmsExampleAppState extends State<SmsExampleApp> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  List<SimCard> _simCards = [];
  List<PhoneNumber> _phoneNumbers = [];
  SimCard? _selectedSim;
  String _statusMessage = '';

  Future<void> _fetchSimCards() async {
    try {
      final sims = await SmsSender.getSimCards();
      if (mounted) {
        setState(() => _simCards = sims);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _statusMessage = 'Error getting SIM cards: $e');
      }
    }
  }

  Future<void> _fetchPhoneNumbers() async {
    try {
      final numbers = await SmsSender.getPhoneNumbers();
      if (mounted) {
        setState(() => _phoneNumbers = numbers);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _statusMessage = 'Error getting phone numbers: $e');
      }
    }
  }

  String _getPhoneNumber(int simSlot) {
    final match = _phoneNumbers.where((pn) => pn.simSlot == simSlot);
    if (match.isEmpty) return 'No number available';
    return match.first.phoneNumber.isEmpty
        ? 'No number available'
        : match.first.phoneNumber;
  }

  Future<void> _sendSms() async {
    final phoneNumber = _phoneController.text.trim();
    final message = _messageController.text.trim();

    if (phoneNumber.isEmpty || message.isEmpty) {
      setState(() => _statusMessage = 'Numbers and messages cannot be empty!');
      return;
    }

    if (_selectedSim == null) {
      setState(() => _statusMessage = 'Select SIM before sending SMS!');
      return;
    }

    try {
      final result = await SmsSender.sendSms(
        phoneNumber: phoneNumber,
        message: message,
        simSlot: _selectedSim!.simSlot,
      );
      setState(() => _statusMessage = result);
    } catch (e) {
      setState(() => _statusMessage = 'Failed to send SMS: $e');
    }
  }

  void _showSimSelection() {
    if (_simCards.isEmpty) {
      setState(() => _statusMessage = 'No SIM detected!');
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _simCards.map((sim) {
              return ListTile(
                title: Text('${sim.carrierName} (SIM ${sim.simSlot})'),
                subtitle: Text(_getPhoneNumber(sim.simSlot)),
                onTap: () {
                  setState(() => _selectedSim = sim);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SMS Sender Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone number'),
            ),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Message'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await Future.wait([_fetchSimCards(), _fetchPhoneNumbers()]);
                _showSimSelection();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _selectedSim == null
                        ? 'Select SIM'
                        : '${_selectedSim!.carrierName} (SIM ${_selectedSim!.simSlot})',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _sendSms,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Send SMS',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _statusMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
