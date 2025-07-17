import 'package:flutter/material.dart';

class BookingDetailsPage extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onNext;

  const BookingDetailsPage({
    Key? key,
    required this.initialData,
    required this.onNext,
  }) : super(key: key);

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _bookingDate;
  String? _timeSlot;
  int _hoursBooked = 1;
  int _numberOfGuests = 1;
  String? _eventType;
  String _specialRequirements = '';

  final List<String> _timeSlots = [
    'Morning (8AM-12PM)',
    'Afternoon (12PM-4PM)',
    'Evening (4PM-8PM)',
  ];

  final List<String> _eventTypes = [
    'Wedding',
    'Birthday',
    'Corporate',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    if (data.isNotEmpty) {
      _bookingDate =
          data['bookingDate'] != null
              ? DateTime.tryParse(data['bookingDate'])
              : null;
      _timeSlot = data['timeSlot'];
      _hoursBooked = data['hoursBooked'] ?? 1;
      _numberOfGuests = data['numberOfGuests'] ?? 1;
      _eventType = data['eventType'];
      _specialRequirements = data['specialRequirements'] ?? '';
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _bookingDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (selected != null) {
      setState(() {
        _bookingDate = selected;
      });
    }
  }

  void _next() {
    if (_formKey.currentState?.validate() == true &&
        _bookingDate != null &&
        _timeSlot != null &&
        _eventType != null) {
      _formKey.currentState?.save();

      widget.onNext({
        'bookingDate': _bookingDate!.toIso8601String(),
        'timeSlot': _timeSlot,
        'hoursBooked': _hoursBooked,
        'numberOfGuests': _numberOfGuests,
        'eventType': _eventType,
        'specialRequirements': _specialRequirements,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: _pickDate,
              child: Text(
                _bookingDate == null
                    ? 'Select Booking Date *'
                    : 'Booking Date: ${_bookingDate!.toLocal()}'.split(' ')[0],
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Time Slot *'),
              items:
                  _timeSlots
                      .map(
                        (slot) =>
                            DropdownMenuItem(value: slot, child: Text(slot)),
                      )
                      .toList(),
              value: _timeSlot,
              onChanged: (val) => setState(() => _timeSlot = val),
              validator:
                  (val) => val == null ? 'Please select a time slot' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Hours Booked *'),
              keyboardType: TextInputType.number,
              initialValue: _hoursBooked.toString(),
              onSaved: (val) => _hoursBooked = int.tryParse(val ?? '1') ?? 1,
              validator: (val) {
                final n = int.tryParse(val ?? '');
                if (n == null || n < 1) return 'Enter valid hours';
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Number of Guests *',
              ),
              keyboardType: TextInputType.number,
              initialValue: _numberOfGuests.toString(),
              onSaved: (val) => _numberOfGuests = int.tryParse(val ?? '1') ?? 1,
              validator: (val) {
                final n = int.tryParse(val ?? '');
                if (n == null || n < 1) return 'Enter valid guests';
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Event Type *'),
              items:
                  _eventTypes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              value: _eventType,
              onChanged: (val) => setState(() => _eventType = val),
              validator: (val) => val == null ? 'Select event type' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Special Requirements',
              ),
              maxLines: 3,
              initialValue: _specialRequirements,
              onSaved: (val) => _specialRequirements = val ?? '',
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _next,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
