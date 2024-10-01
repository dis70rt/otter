import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:otter/ui/widgets/otp_buttons.dart';
import '../../services/auth_provider.dart';
import '../widgets/auth_widget.dart';

class AddPhone extends StatefulWidget {
  const AddPhone({super.key});

  @override
  State<AddPhone> createState() => _AddPhoneState();
}

class _AddPhoneState extends State<AddPhone> {
  final FlCountryCodePicker countryPicker = FlCountryCodePicker(
    title: const Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Center(
        child: Text(
          "Select Country",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    ),
    searchBarDecoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      hintText: "India",
      hintStyle: const TextStyle(color: Colors.white30),
      suffixIcon: const Icon(Icons.search),
      fillColor: const Color.fromRGBO(20, 20, 20, 1),
      filled: true,
    ),
  );

  CountryCode? selectedCountryCode;
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user?.phoneNumber?.isNotEmpty ?? false) {
      // Phone number already exists, send OTP directly
      authProvider.sendOTP(authProvider.user!.phoneNumber!, context);
      return const SizedBox();
    }

    return AuthWidget(
      resizeToAvoidBottomInset: false,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "Add phone number",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            const Text(
              "Input a phone number you'd like to add to your account",
              style: TextStyle(
                color: Colors.white30,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Phone",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (value.length != 10) {
                            return 'Phone number must be exactly 10 digits';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: country(),
                          hintText: "Enter phone number",
                          hintStyle: const TextStyle(color: Colors.white38),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 350),
            Align(
              alignment: Alignment.bottomCenter,
              child: buttonConfirm("Continue", () async {
                if (_formKey.currentState!.validate()) {
                  String phoneNumber =
                      "${selectedCountryCode?.dialCode ?? "+91"}${_phoneController.text.trim()}";

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  // Send OTP using the AuthProvider
                  // await context.read<AuthProvider>().checkPhoneNumberAndSendOTP(phoneNumber, context);
                  authProvider.sendOTP(phoneNumber, context);
                  Navigator.of(context).pop();
                }
              }, width: MediaQuery.of(context).size.width),
            ),
          ],
        ),
      ),
    );
  }

  Widget country() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: GestureDetector(
        onTap: () async {
          final code = await countryPicker.showPicker(
              context: context,
              backgroundColor: Colors.grey.shade900,
              initialSelectedLocale: "IN",
              pickerMaxHeight: 400);
          setState(() {
            selectedCountryCode = code;
          });
        },
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedCountryCode != null
                    ? selectedCountryCode!.dialCode
                    : "+91",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
              const VerticalDivider(
                color: Colors.white70,
                thickness: 1.5,
                indent: 6,
                endIndent: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
