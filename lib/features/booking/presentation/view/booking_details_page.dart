import 'package:flutter/material.dart';
import 'package:venure/features/booking/presentation/widget/premium_dropdown.dart';

class BookingDetailsPage extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onNext;

  const BookingDetailsPage({
    super.key,
    required this.initialData,
    required this.onNext,
  });

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

  final List<Map<String, dynamic>> _timeSlots = [
    {'label': 'Morning (8AM-12PM)', 'hours': 4},
    {'label': 'Afternoon (12PM-4PM)', 'hours': 4},
    {'label': 'Evening (4PM-8PM)', 'hours': 4},
  ];
  List<String> get _timeSlotLabels =>
      _timeSlots.map((e) => e['label'] as String).toList();

  final List<String> _eventTypes = [
    'Wedding',
    'Birthday',
    'Corporate',
    'Other',
  ];

  static const Color _primaryRed = Color(0xFFB22222);
  static const Color _darkOrange = Color(0xFFCC5500);
  static const Color _lightPeach = Color(0xFFFFE5B4);
  static const Color _charcoal = Color(0xFF2C2C2C);
  static const Color _lightGray = Color(0xFFF9F9F9);
  
  static const Color _mediumGray = Color(0xFFE0E0E0);
  static const Color _textDark = Color(0xFF1A1A1A);
  static const Color _textLight = Color(0xFF666666);

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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryRed,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
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
        SnackBar(
          content: const Text(
            'Please fill all required fields',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: _charcoal,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Widget _buildPremiumCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(24),
        child: child,
      ),
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: _mediumGray, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: _lightGray,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: _primaryRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Date',
                    style: TextStyle(
                      fontSize: 12,
                      color: _textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _bookingDate == null
                        ? 'Select your preferred date'
                        : _formatDate(_bookingDate!),
                    style: TextStyle(
                      fontSize: 16,
                      color: _bookingDate == null ? _textLight : _textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: _textLight, size: 16),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  Widget _buildPremiumTextField({
    required String label,
    required String initialValue,
    required Function(String?) onSaved,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onSaved: onSaved,
          validator: validator,
          style: const TextStyle(
            fontSize: 16,
            color: _textDark,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            prefixIcon:
                icon != null
                    ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(icon, color: _primaryRed, size: 20),
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _mediumGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _mediumGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primaryRed, width: 2),
            ),
            filled: true,
            fillColor: _lightGray,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: maxLines > 1 ? 20 : 20,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFAFAFA), Color(0xFFF5F5F5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please provide your event details for a personalized experience',
                style: TextStyle(fontSize: 16, color: _textLight),
              ),

              const SizedBox(height: 32),

              // Date & Time
              _buildPremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateSelector(),
                    const SizedBox(height: 20),
                    PremiumDropdown(
                      textDark: _textDark,
                      primaryRed: _primaryRed,
                      mediumGray: _mediumGray,
                      lightGray: _lightGray,
                      label: 'Time Slot',
                      value: _timeSlot,
                      items: _timeSlotLabels,
                      onChanged: (val) {
                        setState(() {
                          _timeSlot = val;
                          _hoursBooked =
                              _timeSlots.firstWhere(
                                (slot) => slot['label'] == val,
                              )['hours'];
                        });
                      },
                      validator:
                          (val) =>
                              val == null ? 'Please select a time slot' : null,
                      icon: Icons.access_time,
                    ),
                  ],
                ),
              ),

              // Event Info
              _buildPremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hours Booked',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _textDark,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: _lightGray,
                                  border: Border.all(color: _mediumGray),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.schedule,
                                      color: _primaryRed,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '$_hoursBooked hour${_hoursBooked > 1 ? 's' : ''}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildPremiumTextField(
                            label: 'Number of Guests',
                            initialValue: _numberOfGuests.toString(),
                            keyboardType: TextInputType.number,
                            icon: Icons.people,
                            onSaved:
                                (val) =>
                                    _numberOfGuests =
                                        int.tryParse(val ?? '1') ?? 1,
                            validator: (val) {
                              final n = int.tryParse(val ?? '');
                              return (n == null || n < 1)
                                  ? 'Enter valid guests'
                                  : null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    PremiumDropdown(
                      textDark: _textDark,
                      primaryRed: _primaryRed,
                      mediumGray: _mediumGray,
                      lightGray: _lightGray,
                      label: 'Event Type',
                      value: _eventType,
                      items: _eventTypes,
                      onChanged: (val) => setState(() => _eventType = val),
                      validator:
                          (val) => val == null ? 'Select event type' : null,
                      icon: Icons.event,
                    ),
                  ],
                ),
              ),

              // Special Requirements
              _buildPremiumCard(
                child: _buildPremiumTextField(
                  label: 'Additional Notes (Optional)',
                  initialValue: _specialRequirements,
                  maxLines: 4,
                  onSaved: (val) => _specialRequirements = val ?? '',
                ),
              ),

              // Next Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Continue to Review',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.arrow_forward, size: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
