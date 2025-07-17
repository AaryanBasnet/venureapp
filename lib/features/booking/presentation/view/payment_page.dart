import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const PaymentPage({
    Key? key,
    required this.initialData,
    required this.onNext,
    required this.onBack,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  String _cardNumber = '';
  String _expiryDate = '';
  String _cvv = '';
  String _cardholderName = '';
  String _contactName = '';
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    _cardNumber = data['paymentDetails']?['cardNumber'] ?? '';
    _expiryDate = data['paymentDetails']?['expiryDate'] ?? '';
    _cvv = data['paymentDetails']?['cvv'] ?? '';
    _cardholderName = data['paymentDetails']?['cardholderName'] ?? '';
    _contactName = data['contactName'] ?? '';
    _phoneNumber = data['phoneNumber'] ?? '';
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    _formKey.currentState?.save();

    widget.onNext({
      'paymentDetails': {
        'cardNumber': _cardNumber,
        'expiryDate': _expiryDate,
        'cvv': _cvv,
        'cardholderName': _cardholderName,
      },
      'contactName': _contactName,
      'phoneNumber': _phoneNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Contact Name *'),
              initialValue: _contactName,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Enter contact name' : null,
              onSaved: (val) => _contactName = val ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone Number *'),
              initialValue: _phoneNumber,
              keyboardType: TextInputType.phone,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Enter phone number' : null,
              onSaved: (val) => _phoneNumber = val ?? '',
            ),
            const SizedBox(height: 20),
            const Text('Payment Details', style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Card Number *'),
              initialValue: _cardNumber,
              keyboardType: TextInputType.number,
              maxLength: 16,
              validator: (val) =>
                  val == null || val.length != 16 ? 'Enter valid card number' : null,
              onSaved: (val) => _cardNumber = val ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY) *'),
              initialValue: _expiryDate,
              maxLength: 5,
              validator: (val) {
                if (val == null ||
                    !RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(val)) {
                  return 'Enter valid expiry date';
                }
                return null;
              },
              onSaved: (val) => _expiryDate = val ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'CVV *'),
              initialValue: _cvv,
              maxLength: 3,
              keyboardType: TextInputType.number,
              validator: (val) =>
                  val == null || val.length != 3 ? 'Enter valid CVV' : null,
              onSaved: (val) => _cvv = val ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Cardholder Name *'),
              initialValue: _cardholderName,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Enter cardholder name' : null,
              onSaved: (val) => _cardholderName = val ?? '',
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: widget.onBack, child: const Text('Back')),
                ElevatedButton(onPressed: _submit, child: const Text('Confirm')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
