import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

import '../theme/text_style.dart';

/*
  Expanded(
    child: DropdownSearchField(
      label: 'Cidade Nascimento',
      items: ['Sao Paulo', 'Campinas', 'Salvador', 'Sao Jose dos Campos', 'Pindorama'],
      onChanged: (value) {
        widget.birthCityEC.text = value ?? '';
      },
      initialValue: widget.birthCityEC.text,
      placeholder: 'Selecione',
      validator: Validatorless.required('Preenchimento é obrigatório'),
    ),
  ),
*/

class DropdownSearchField extends StatefulWidget {
  final List<String> items;
  final String? label;
  final String? placeholder;
  final String? initialValue;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const DropdownSearchField({
    super.key,
    required this.items,
    this.label,
    this.placeholder,
    this.initialValue,
    required this.onChanged,
    this.validator,
  });

  @override
  State<DropdownSearchField> createState() => _DropdownSearchFieldState();
}

class _DropdownSearchFieldState extends State<DropdownSearchField> {
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    print('.... INIT DROPSEARCH widget.initialValue=${widget.initialValue}');
    if (widget.initialValue != null && widget.initialValue != '') {
      selectedValue = widget.initialValue;
    }
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('... BUILD selectedValue=$selectedValue');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label ?? '',
            style: greyonboardingBody1Style,
          ),
          const SizedBox(height: 10),
        ],
        DropdownButtonHideUnderline(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(width: 1, color: Colors.black),
            ),
            width: double.infinity,
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                widget.placeholder ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: widget.items
                  .map((item) => DropdownMenuItem(
                        value: removeDiacritics(item),
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                  widget.onChanged(value);
                });
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                width: 200,
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 500,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),

              dropdownSearchData: DropdownSearchData(
                searchController: textEditingController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: widget.placeholder ?? '',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value
                      .toString()
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                },
              ),
              //This to clear the search value when you close the menu
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textEditingController.clear();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
