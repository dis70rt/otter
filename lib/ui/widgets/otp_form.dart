import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildOtpTextField(context),
          _buildOtpTextField(context),
          _buildOtpTextField(context),
          _buildOtpTextField(context),
        ],
      ),
    );
  }

  Widget _buildOtpTextField(BuildContext context) {
    return SizedBox(
      height: 68,
      width: 64,
      child: TextFormField(
        cursorColor: Colors.blueAccent,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
          focusColor: Colors.blueAccent,
          hoverColor: Colors.blueAccent,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
          filled: true,
        ),
        style: Theme.of(context).textTheme.headlineMedium,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlign: TextAlign.center,
      ),
    );
  }
}
