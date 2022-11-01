import 'package:flutter/material.dart';

import 'home.dart';


class ProvidedSolutions extends StatefulWidget {
  const ProvidedSolutions({Key? key}) : super(key: key);

  @override
  State<ProvidedSolutions> createState() => _ProvidedSolutionsState();
}

class _ProvidedSolutionsState extends State<ProvidedSolutions> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = <String>[];

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = <String>[];
    dummySearchList.addAll(duplicateItems);
    if(query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      dummySearchList.forEach((item) {
        if((item[0]+item).toLowerCase().contains(query) || item[0].toUpperCase().contains(query) || item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>HomeScreen(),),);
          },
        ),
        title: new Text("Provided Solutions"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${items[index]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}