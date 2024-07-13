import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var loading = 0;
  var title = '';
  var key = '';
  List result = [
    {'INDEXID': '1', 'SITEID': 's1'},
    {'INDEXID': '2', 'SITEID': 's2'},
    {'INDEXID': '3', 'SITEID': 's3'},
    {'INDEXID': '4', 'SITEID': 's4'},
    {'INDEXID': '5', 'SITEID': 's5'},
    {'INDEXID': '6', 'SITEID': 's6'},
    {'INDEXID': '7', 'SITEID': 's7'},
    {'INDEXID': '8', 'SITEID': 's8'},
    {'INDEXID': '9', 'SITEID': 's9'},
    {'INDEXID': '10', 'SITEID': 's10'},
  ];

  Future<dynamic> postSQL(String sql) async {
    final response = await http.get(
      // Uri.parse('http://localhost:55016/datasnap/rest/TServerMethods2/query/sql'),
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      // body: jsonEncode(<String, String>{
      //   'sql': sql,
      // }),
    );
    final res = jsonDecode(response.body);
    print(res);

    if ([200, 201].contains(response.statusCode)) {
      setState(() {
        loading = 2;
        // print(res['result'][0]['result']);
        // result = [
        //   {'INDEXID': 'INDEXID', 'SITEID': 'SITEID'},
        // ];
        // result = res[0]['result'];
      });
    } else {
      setState(() {
        loading = 2;
        result = [];
      });
    }
  }

  Widget itemList() {
    if (loading < 2) {
      return const CircularProgressIndicator();
    } else {
      return result.isEmpty
          ? const Text('No data found')
          : SizedBox(
              height: 300.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(result[index]['INDEXID']),
                    subtitle: Text(result[index]['SITEID']),
                  );
                },
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    title = arg['title'];
    key = arg['key'];

    if (loading == 0) {
      postSQL('SELECT TOP 10 * FROM sites;');
      loading = 1;
    }
    // switch (key) {
    //   case 'SITEID':
    //     postSQL('SELECT TOP 10 * FROM sites;');
    //     break;
    //   default:
    //     postSQL('SELECT TOP 10 * FROM job;');
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            Center(child: itemList()),
            const SizedBox(height: 30),
            ElevatedButton(
              style: style,
              onPressed: () {
                Navigator.pop(context, 'BACK from "$title"');
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
