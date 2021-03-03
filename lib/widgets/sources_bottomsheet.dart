import 'package:flutter/material.dart';
import 'package:news/utils/provider.dart';
import 'package:provider/provider.dart';


class SourcesFilter extends StatefulWidget {
  @override
  _SourcesFilterState createState() => _SourcesFilterState();
}

class _SourcesFilterState extends State<SourcesFilter> {

  @override
  Widget build(BuildContext context) {
    final data= Provider.of<NewsProvider>(context);
    
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
              "Filter by Sources",
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
            child: ListView.builder(
                itemCount: data.sources.length,
                itemBuilder: (context, index) {
                  final instance = data.sources[index];
                  return CheckboxListTile(
                      activeColor: Color(0xFF0C54BE),
                      title: Text(instance.name),
                      value: data.sourcesToBeFetched.contains(instance.id),
                      onChanged: (bool result) {
                        if (result == false)
                          setState(() {
                            data.sourcesToBeFetched.remove(instance.id);
                          });
                        else
                          setState(() {
                            data.sourcesToBeFetched.add(instance.id);
                          });
                      });
                }),
          ),
          Center(
            child: MaterialButton(
              color: Color(0xFF0C54BE),
              textColor: Colors.white,
              onPressed: () {
                data.updateCriteria("Sources");
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