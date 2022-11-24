import 'package:charter_app/charter/addCharter.dart';
import 'package:charter_app/charter/bloc/charter_bloc.dart';
import 'package:charter_app/charter/models/charter_list_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharterList extends StatefulWidget {
  CharterList({Key? key}) : super(key: key);

  @override
  State<CharterList> createState() => _CharterListState();
}

class _CharterListState extends State<CharterList> {
  final TextEditingController searchController = TextEditingController();

  List<CharterData> charterList = <CharterData>[];

  @override
  void initState() {
    BlocProvider.of<CharterBloc>(context).add(LoginEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 200,
        child: Center(
          child: InkWell(
            onTap: () {
              showSheet(context);
            },
            child: const Text("tap here!"),
          ),
        ),
      ),
    );
  }

  void showSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: BlocProvider(
              create: (BuildContext context) => CharterBloc(),
              child: Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.5),
                              color: const Color.fromRGBO(198, 235, 246, 1)),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Charterer",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Noto Sans'),
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      TextField(
                        onChanged: (str) {
                          BlocProvider.of<CharterBloc>(context).add(
                              GetCharterEvent(search: searchController.text));
                        },
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          fillColor: const Color.fromRGBO(233, 238, 240, 1),
                          filled: true,
                          hintText: "Search...",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 18.0),
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
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Color.fromRGBO(118, 128, 138, 1),
                          ),
                        ),
                        controller: searchController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: BlocConsumer<CharterBloc, CharterState>(
                              builder: (context, state) {
                            if (state is Loading) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: CupertinoActivityIndicator(
                                  color: Color.fromRGBO(12, 171, 223, 1),
                                ),
                              );
                            } else {
                              return charterList.isEmpty
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        "Search for your charterer or add them!",
                                        style: TextStyle(
                                            fontFamily: 'Noto Sans',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: charterList.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            charterList[index].chartererName!,
                                            style: const TextStyle(
                                                fontFamily: 'Noto Sans',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        );
                                        // return CharterItem();
                                      },
                                    );
                            }
                          }, listener: (context, state) {
                            if (state is GetCharterSuccessState) {
                              charterList.clear();
                              charterList = state.response.data!;
                            }
                            if (state is LoadingEnd) {
                              if (state.error) charterList.clear();
                            }
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: " Can’t find your Charterer? ",
                            style: TextStyle(
                                color: Color.fromRGBO(117, 128, 138, 1))),
                        TextSpan(
                            text: "Add now",
                            style: const TextStyle(
                                color: Color.fromRGBO(12, 171, 223, 1)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return AddCharter();
                                }));
                              })
                      ])),
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }
}
