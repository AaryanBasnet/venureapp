import 'package:flutter/material.dart';

const Color _primaryRed = Color(0xFFE74C3C);
const Color _textDark = Color(0xFF333333);
const Color _inputFill = Color(0xFFF9F9F9);
const double _cornerRadius = 14.0;

class PaymentPage extends StatelessWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const PaymentPage({
    super.key,
    required this.initialData,
    required this.onNext,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = initialData['totalPrice'] ?? 0;

    final _formKey = GlobalKey<FormState>();
    final contactNameController = TextEditingController(
      text: initialData['contactName'] ?? '',
    );
    final phoneNumberController = TextEditingController(
      text: initialData['phoneNumber'] ?? '',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 20),

            // Contact Name
            TextFormField(
              controller: contactNameController,
              decoration: InputDecoration(
                labelText: 'Contact Name *',
                filled: true,
                fillColor: _inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_cornerRadius),
                  borderSide: BorderSide.none,
                ),
              ),
              validator:
                  (val) =>
                      val == null || val.isEmpty ? 'Enter contact name' : null,
            ),
            const SizedBox(height: 16),

            // Phone Number
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                filled: true,
                fillColor: _inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_cornerRadius),
                  borderSide: BorderSide.none,
                ),
              ),
              validator:
                  (val) =>
                      val == null || val.isEmpty ? 'Enter phone number' : null,
            ),
            const SizedBox(height: 32),

            // Total Price
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _primaryRed.withOpacity(0.08),
                borderRadius: BorderRadius.circular(_cornerRadius),
              ),
              child: Text(
                'Total Price: Nrs. $totalPrice',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _primaryRed,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBack,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _primaryRed),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_cornerRadius),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: _primaryRed,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      onNext({
                        'contactName': contactNameController.text,
                        'phoneNumber': phoneNumberController.text,
                      });

                      onSubmit();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_cornerRadius),
                      ),
                    ),
                    child: const Text(
                      'Confirm & Pay',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
