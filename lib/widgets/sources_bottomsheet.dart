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
        children: [
          Text("Filter by Sources"),
          Divider(),
          Expanded(
            child: ListView.builder(
                itemCount: data.sources.length,
                itemBuilder: (context,index) {
               final instance = data.sources[index];
              return CheckboxListTile(
                  title: Text(instance.name),
                  value: data.sourcesToBeFetched.contains(instance.id),
                  onChanged: (bool result){
                    if(result == false)
                     setState(() {
                       data.sourcesToBeFetched.remove(instance.id);
                     });
                    else setState(() {
                      data.sourcesToBeFetched.add(instance.id);
                    });
                  });

            }),
                    ),
          MaterialButton(onPressed: () {
            context.read<NewsProvider>().populateFromSources();
            Navigator.of(context).pop();
          },
            child: Text("APPLY"),)
        ],
      ),

    );
  }
}