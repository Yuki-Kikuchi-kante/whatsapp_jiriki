import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_jiriki/common/utils/colors.dart';
import 'package:whatsapp_jiriki/common/utils/utils.dart';
import 'package:whatsapp_jiriki/common/widgets/custom_button.dart';
import 'package:whatsapp_jiriki/features/auth/controller/auth_controller.dart';


class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController controller = TextEditingController();
  Country? country;

  void countryPiked() {
    showCountryPicker(
      context: context,
      onSelect: (Country selectedCountry) {
        setState(() {
          country = selectedCountry;
        });
      },
    );
  }

  void sendPhoneNumber(){
   String phoneNumber = controller.text.trim();
   if(country != null && phoneNumber.isNotEmpty){
    ref.read(authControllerProvider).sendPhoneNumber(
          phoneNumber: '+${country!.phoneCode}$phoneNumber',
          context: context,
        );
   }else{
    showSnackBar(context: context, content: '空欄を埋めてください');
   }
    
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('WhatsApp will need to verify your phone number.'),
              const SizedBox(height: 10),
              TextButton(
                onPressed: countryPiked,
                child: const Text('Pick Country'),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  country != null
                      ? Text('+${country!.phoneCode}')
                      : const SizedBox(),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'phone number',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.5),
              SizedBox(
                width: 90,
                child: CustomButton(
                  onPressed: sendPhoneNumber,
                  text: 'NEXT',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
