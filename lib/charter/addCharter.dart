import 'package:charter_app/charter/bloc/charter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCharter extends StatelessWidget {
  AddCharter({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black)),
      ),
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
      body: BlocProvider(
        create: (context) => CharterBloc(),
        child: Builder(builder: (context) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add charterer",
                      style: TextStyle(
                          fontFamily: 'Heebo',
                          fontSize: 34,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 32),
                    getCommonTextField(
                        controller: nameController, hint: "Full name"),
                    getCommonTextField(
                        controller: emailController, hint: "Email"),
                    getCommonTextField(
                        controller: countryController,
                        hint: "Country of residence"),
                    getCommonTextField(
                        controller: mobileController, hint: "Mobile number"),
                    getCommonTextField(
                        controller: addressController, hint: "Address"),
                    getCommonTextField(
                        controller: stateController, hint: "State"),
                    getCommonTextField(
                        controller: cityController, hint: "City"),
                    getCommonTextField(
                        controller: websiteController, hint: "Website"),
                    const SizedBox(height: 12),
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: " Want to search again?",
                          style: TextStyle(
                              color: Color.fromRGBO(117, 128, 138, 1))),
                      TextSpan(
                          text: " Click here.",
                          style: const TextStyle(
                              color: Color.fromRGBO(12, 171, 223, 1)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            })
                    ])),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        print("CLICKING");
                        BlocProvider.of<CharterBloc>(context)
                            .add(AddCharterEvent(data: {
                          "chartererDetails": {
                            "name": nameController.text,
                            "email": emailController.text,
                            "address1": addressController.text,
                            "address2": "",
                            "state": stateController.text,
                            "city": cityController.text,
                            "country": countryController.text,
                            "website": websiteController.text,
                            "contactPerson": "XYZ",
                            "phoneNumber": mobileController.text
                          }
                        }));
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(12, 171, 223, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(12, 171, 223, 0.25),
                              spreadRadius: 0,
                              blurRadius: 20,
                              offset:
                                  Offset(0, 10), // changes position of shadow
                            ),
                          ],
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: const Center(
                          child: Text(
                            "Continue",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              BlocBuilder<CharterBloc, CharterState>(builder: (context, state) {
                if (state is Loading) {
                  return const Center(
                    child: CupertinoActivityIndicator(
                      color: Color.fromRGBO(12, 171, 223, 1),
                      radius: 25,
                    ),
                  );
                }
                return Container();
              }),
              BlocListener<CharterBloc, CharterState>(
                  child: Container(),
                  listener: (context, state) {
                    if (state is AddCharterSuccessState) {
                      showtoast(
                          "Successfully added the charterer! You can now search them!");
                    }
                  })
            ],
          );
        }),
      ),
    );
  }

  Widget getCommonTextField(
      {required TextEditingController controller, required String hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          fillColor: const Color.fromRGBO(233, 238, 240, 1),
          filled: true,
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 18.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        controller: controller,
      ),
    );
  }

  showtoast(String? message, [Toast duration = Toast.LENGTH_SHORT]) {
    Fluttertoast.showToast(
      msg: message!,
      toastLength: duration,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
