import 'package:flutter/material.dart';

class DropDownMenu<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> dropdownMenuItemList;
  final ValueChanged<T> onChanged;
  final T value;
  final bool isEnabled;
  DropDownMenu({
    Key key,
    @required this.dropdownMenuItemList,
    @required this.onChanged,
    @required this.value,
    this.isEnabled = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return IgnorePointer(
      ignoring: !isEnabled,
      child: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
        child: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              itemHeight: 50.0,
              dropdownColor: Colors.white,
              iconEnabledColor: Colors.black,
              style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: "Montserrat",
                  color: Colors.black),
              items: dropdownMenuItemList,
              onChanged: onChanged,
              value: value,
            ),
          ),
        ),
      ),
    );
  }
}