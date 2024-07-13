import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String title = '';
  String key = '';
  dynamic result = [];

  Future<dynamic> postSQL(String sql) async {
    final response = await http.post(
      Uri.parse('http://localhost:55016/datasnap/rest/TServerMethods2/query/sql'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sql': sql,
      }),
    );

    if ([200, 201].contains(response.statusCode)) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      setState(() {
        final res = jsonDecode(response.body);
        print(res['result'][0]['result']);
        result = [
          {
            'INDEXID': 'INDEXID', 
            'SITEID': 'SITEID'
          },
        ];
        // result = res[0]['result'];
      });
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to post SQL.');
      setState(() {
        result = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    title = arg['title'];
    key = arg['key'];

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
            result.isEmpty
                ? const CircularProgressIndicator()
                : ListView.builder(
                  // Let the ListView know how many items it needs to build.
                  // itemCount: result.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (context, index) {
                    final item = result[index];

                    return ListTile(
                      title: Text(item['INDEXID']),
                      subtitle: Text(item[key]),
                    );
                  },
                ),
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