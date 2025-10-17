import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:flutter/material.dart';

class PhoneInputDialog extends StatefulWidget {
  final Function(String phone) onSendOtp;

  const PhoneInputDialog({Key? key, required this.onSendOtp}) : super(key: key);

  @override
  State<PhoneInputDialog> createState() => _PhoneInputDialogState();
}

class _PhoneInputDialogState extends State<PhoneInputDialog> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() async{
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();

      await AppUserServices().sendOtp(phone);
      //Navigator.of(context).pop();
      widget.onSendOtp(phone);

     // close dialog after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Phone Number'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: '+1234567890',
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            // Basic phone validation (with country code)
            if (!RegExp(r'^\+\d{6,15}$').hasMatch(value)) {
              return 'Enter valid phone number with country code';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close dialog
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _sendOtp,
          child: const Text('Send OTP'),
        ),
      ],
    );
  }
}
