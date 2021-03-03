import 'package:flutter/material.dart';
import 'package:news/utils/provider.dart';
import 'package:provider/provider.dart';


class LocationSelector extends StatefulWidget {
  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {

  String _radioValue = NewsProvider.country;

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              "Choose your Location",
              style: TextStyle(
                  color: Color(0xFF303F60),
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ),
          Divider(
            color: Color(0xFF303F60),
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            // child: Container(
            //   height: MediaQuery.of(context).size.height * 0.5,
            child: ListView(
              children: [
                ListTile(
                  title: Text("India"),
                  trailing: Radio(
                    activeColor: Color(0xFF0C54BE),
                    value: "in",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                ListTile(
                  title: Text("Netherlands"),
                  trailing: Radio(
                    activeColor: Color(0xFF0C54BE),
                    value: "nl",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                ListTile(
                  title: Text("USA"),
                  trailing: Radio(
                    activeColor: Color(0xFF0C54BE),
                    value: "us",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                ListTile(
                  title: Text("South Africa"),
                  trailing: Radio(
                    activeColor: Color(0xFF0C54BE),
                    value: "za",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                ListTile(
                  title: Text("France"),
                  trailing: Radio(
                    activeColor: Color(0xFF0C54BE),
                    value: "fr",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: MaterialButton(
              color: Color(0xFF0C54BE),
              textColor: Colors.white,
              onPressed: () {
                Provider.of<NewsProvider>(context, listen: false)
                    .updateCountry(_radioValue);
                Navigator.of(context).pop();
              },
              child: Text("APPLY"),
            ),
          )
        ],
      ),

    );
  }
}