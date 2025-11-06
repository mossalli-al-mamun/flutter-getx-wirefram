import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:flutter_getx_wireframe/Widgets/form/unified_dropdown_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../Config/themes/appStyles/form_style.dart';
import '../../Config/themes/text_styles.dart';
import '../../Constants/customData/address_fields_json.dart';
import '../../Controller/locale/localization_service_controller.dart';
import '../../Models/address/address_model.dart';
import '../../Utils/app_logger.dart';
import '../../Utils/device_dimension.dart';
import '../app_toast.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

class AddressForm extends StatefulWidget {
  final Function? onSubmit;
  final Function? onCancel;
  final Address? address;

  const AddressForm({super.key, this.address, this.onSubmit, this.onCancel});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final countriesData = 'assets/countries-with-states.json';

  bool isButtonDisabled = true;
  bool areAllFieldsFilled = false;
  List<dynamic> data = [];
  List<dynamic> countryState = [];

  String? selectedCountry;
  String? selectedCountryCode;
  String? selectedState;
  bool showState = true;

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future readJson() async {
    final String response = await rootBundle.loadString(countriesData);
    final jsonData = await json.decode(response);
    final states = findStatesByCountryCode(
      jsonData,
      widget.address?.country ?? "United States",
    );
    final country = findCountryNameByCountryCode(
      jsonData,
      widget.address?.country ?? "United States",
    );
    if (states.isNotEmpty) {
      setState(() {
        countryState = states;
      });
    } else {
      showState = false;
    }
    setState(() {
      data = jsonData;
      selectedState = widget.address?.state;
      selectedCountry = country;
      selectedCountryCode = widget.address?.country;
    });
  }

  dynamic isStateRequired() {
    return countryState.isNotEmpty && selectedState == null;
  }

  List<String> findStatesByCountryCode(dynamic countries, String countryCode) {
    List<String> foundStates = [];
    countries.forEach((country) {
      if (country['code'] == countryCode) {
        foundStates = List<String>.from(country['states']);
      }
    });
    return foundStates;
  }

  String findCountryNameByCountryCode(dynamic countries, String countryCode) {
    String foundCountry = '';
    countries.forEach((country) {
      if (country['code'] == countryCode) {
        foundCountry = country['country'];
      }
    });
    return foundCountry;
  }

  @override
  Widget build(BuildContext context) {
    List formArray = addressFieldJson(widget, showState, context);

    List<String> exclusionsRequired = ['address2', 'phone'];

    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            ...formArray.map((fieldItem) {
              final index = formArray.indexOf(fieldItem);
              final isLastItem = index == formArray.length - 1;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fieldItem['isShowing'] == true
                      ? Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: fieldItem['title']!.toString(),
                                style: AppTextStyle.labelMedium,
                              ),
                              TextSpan(
                                text: fieldItem['isRequired'] ? ' *' : '',
                                style: AppTextStyle.labelMedium.copyWith(
                                  color: context.dangerColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(height: fieldItem['isShowing'] == true ? 10 : 0),
                  (fieldItem['name'] == 'country' ||
                          fieldItem['name'] == 'state')
                      ? fieldItem['isShowing'] == true
                            ? UnifiedDropdownField(
                                name: fieldItem['name'],
                                options: convertToDropdownOptions(fieldItem['name'] == 'state'
                                    ? countryState
                                    : data),
                                // placeholder: fieldItem['placeHolder'],
                                initialValue: fieldItem['name'] == 'state'
                                    ? selectedState
                                    : selectedCountry,
                                onChanged: (value) {
                                  fieldItem['name'] == 'country'
                                      ? setState(() {
                                          selectedCountry = value['country'];
                                          selectedCountryCode = value['code'];
                                          selectedState = null;
                                          if (value['states'].isEmpty) {
                                            showState = false;
                                          } else {
                                            showState = true;
                                          }
                                        })
                                      : setState(() {
                                          selectedState = value;
                                        });
                                  value.runtimeType != String
                                      ? setState(() {
                                          countryState = value['states'];
                                        })
                                      : null;
                                },
                              )
                            : Container()
                      : FormBuilderTextField(
                          initialValue: fieldItem['initialValue'] ?? '',
                          name: fieldItem['name']!,
                          decoration: appFormStyle(
                            context: context,
                            hintText: fieldItem['placeHolder'],
                          ),
                          validator: FormBuilderValidators.compose([
                            if (!exclusionsRequired.contains(fieldItem['name']))
                              FormBuilderValidators.required(),
                          ]),
                          cursorColor: context.primary,
                        ),
                  SizedBox(
                    height: fieldItem['isShowing'] == true
                        ? isLastItem
                              ? 5
                              : 24
                        : 0,
                  ),
                ],
              );
            }),
            20.height,
            Column(
              children: [
                SizedBox(
                  width: deviceDimension(context).width - 40,
                  child: PrimaryButton(
                    onPressed: () {
                      if (_formKey.currentState!.saveAndValidate()) {
                        Map<String, dynamic> formData =
                            _formKey.currentState!.value;
                        Map<String, dynamic> countryItems = {
                          'country': selectedCountryCode,
                          'state': selectedState,
                        };
                        Map<String, dynamic> concatenatedMap = {
                          ...formData,
                          ...countryItems,
                        };
                        appLogger('The state is required ${isStateRequired()}');
                        if (isStateRequired()) {
                          AppToast.show(
                            context,
                            "${tr.state} ${tr.isRequired}",
                          );
                          return;
                        } else {
                          widget.onSubmit!(concatenatedMap);
                        }
                      }
                    },
                    label: tr.saveChanges,
                  ),
                ),
                15.height,
                SizedBox(
                  width: deviceDimension(context).width - 40,
                  child: SecondaryButton(
                    onPressed: () {
                      widget.onCancel!();
                    },
                    label: tr.cancel,
                  ),
                ),
                20.height,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
