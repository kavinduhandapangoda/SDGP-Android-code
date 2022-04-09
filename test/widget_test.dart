// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('API connection test', () async {

      var url = Uri.parse('https://agroscan.loopweb.lk/reportLog/100,100/test');
      var response = await http.get(url, headers: {});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');


    expect(response.statusCode, 200);
  });
}
