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
        children: [
          Text("Choose your location"),
          Divider(),
          Expanded(
            // child: Container(
            //   height: MediaQuery.of(context).size.height * 0.5,
            child: ListView(
              children: [
                ListTile(
                  title: Text("India"),
                  trailing: Radio(
                    value: "in",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                ListTile(
                  title: Text("Netherlands"),
                  trailing: Radio(
                    value: "nl",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                ListTile(
                  title: Text("USA"),
                  trailing: Radio(
                    value: "us",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                ListTile(
                  title: Text("South Africa"),
                  trailing: Radio(
                    value: "za",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                ListTile(
                  title: Text("France"),
                  trailing: Radio(
                    value: "fr",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
              ],
            ),
          ),
          MaterialButton(onPressed: () {
            NewsProvider.country = _radioValue;
            context.read<NewsProvider>().populateTopHeadlines();
            Navigator.of(context).pop();
          },
            child: Text("APPLY"),)
        ],
      ),

    );
  }
}