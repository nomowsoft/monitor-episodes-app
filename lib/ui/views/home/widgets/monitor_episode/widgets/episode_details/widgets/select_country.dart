import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/countries/country.dart';
import 'package:monitor_episodes/model/core/shared/constants.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';

class SelectCountry extends StatefulWidget {
  final String? readOnlyCountry;
  const SelectCountry({Key? key, this.readOnlyCountry}) : super(key: key);

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  late List<Country> listCountries;
  String searchText = '';

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    searchText = '';
    listCountries = Constants.listCountries;
    super.initState();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    searchText = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqDataNew = Get.mediaQuery.copyWith(textScaleFactor: SizeConfig.textScaleFactor );
    return Column(
      children: [
        MediaQuery(
          data: mqDataNew,
          child: TextField(
            autofocus: true,
            onChanged: (val) {
              setState(() {
                searchText = val.toLowerCase().trim();
              });
            },
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.4),
            textAlign: TextAlign.start,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'search_here'.tr,
              hintStyle: const TextStyle(color: Colors.black),
              contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Expanded(
            child: listCountriesForShow.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        ...listCountriesForShow.map((e) => InkWell(
                              onTap: (() {
                                Get.back(result: e);
                              }),
                              child: Column(
                                children: [
                                  Text(
                                    e.name.toString(),
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        height: 1.4),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: SizeConfig.textScaleFactor,
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    height: 10.h,
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      'there_are_no'.tr,
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.4),
                      textAlign: TextAlign.center,
                      textScaleFactor: SizeConfig.textScaleFactor,
                    ),
                  )),
      ],
    );
  }

  List<Country> get listCountriesForShow {
    return listCountries
        .where((element) => (searchText.isNotEmpty)
            ? (element.name.toLowerCase().contains(searchText))
            : true)
        .toList();
  }
}
