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
  var keyfield = '';
  var err = '';
  List result = [
    // {'INDEXID': '1', 'SITEID': 's1'},
    // {'INDEXID': '2', 'SITEID': 's2'},
    // {'INDEXID': '3', 'SITEID': 's3'},
    // {'INDEXID': '4', 'SITEID': 's4'},
    // {'INDEXID': '5', 'SITEID': 's5'},
    // {'INDEXID': '6', 'SITEID': 's6'},
    // {'INDEXID': '7', 'SITEID': 's7'},
    // {'INDEXID': '8', 'SITEID': 's8'},
    // {'INDEXID': '9', 'SITEID': 's9'},
    // {'INDEXID': '10', 'SITEID': 's10'},
  ];

  Future<dynamic> postSQL(String sql) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:55016/datasnap/rest/TServerMethods2/query/sql'),
        // GET Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
        headers: <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': '*/*'
        },
        body: jsonEncode(<String, String>{
          'sql': sql,
        }),
      );
      final res = jsonDecode(response.body);
      // print(res);
      if ([200, 201].contains(response.statusCode)) {
        var status = res['result'][0]['status'];
        if (status == 1) {
          setState(() {
            loading = 2;
            err = '';
            result = res['result'][0]['result'];
          });
          return;
        } else {
          setState(() {
            loading = 3;
            err = res['result'][0]['message'];
            result = [];
          });
          return;
        }
      } else {
        setState(() {
          loading = 3;
          err = 'connection error';
          result = [];
        });
      }
    } catch (e) {
      setState(() {
        loading = 3;
        err = e.toString();
        result = [];
      });
    }
  }

  Widget itemList() {
    if (loading < 2) {
      return const Center(child: CircularProgressIndicator());
    } else {
      switch (loading) {
        case 2:
          return result.isEmpty
            ? const Center(child: Text('No data found'))
            : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: result.length,
              itemBuilder: (context, index) {
                var item = result[index];
                return ListTile(
                  title: Text("${item['INDEXID']}  ${item[keyfield]}"),
                );
              },
            );
        default:
          return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      // Navigator.pop(context, 'BACK from "$title"');
                      setState(() {
                        loading = 0;
                        result = [];
                      });
                    },
                    child: const Text('Reload'),
                  ),
                  const SizedBox(height: 16),
                  Text(err),
                ],
              );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    title = arg['title'];
    keyfield = arg['keyfield'];

    if (loading == 0) {
      switch (keyfield) {
        case 'SITEID':
          postSQL('SELECT TOP 10 * FROM sites;');
          break;
        default:
          postSQL('SELECT TOP 10 * FROM job;');
      }
      loading = 1;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: itemList(),
    );
  }
}
