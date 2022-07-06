// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:todoapp/ui/size_config.dart';
import 'package:todoapp/ui/theme.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.hint,
    this.controller,
    this.widget,
    required this.title,
  }) : super(key: key);

  final String hint;
  final String title;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // used to initialize
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child:
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
        Text(
          title,
          style: Titlestyle,
        ),
        Container(
          padding: const EdgeInsets.only(left: 14),
          margin: const EdgeInsets.only(top: 8),
          width: SizeConfig.screenWidth,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey)),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  autofocus: false,
                  cursorColor: Get.isDarkMode ? Colors.grey[200] : Colors.grey[700],
                  readOnly: widget != null ? true : false,
                  style: Subtitlestyle,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: Subtitlestyle,
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: context.theme.backgroundColor,
                            width: 0
                            )
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: context.theme.backgroundColor,
                            width: 0)
                    ),
                  ),
                ),
              ),
              widget ?? Container(),
            ],
          ),
        ),
      ]),
    );
  }
}
