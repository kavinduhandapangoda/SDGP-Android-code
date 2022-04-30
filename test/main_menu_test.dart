import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_kit_obkm/main.dart' as app;

void main() {

    testWidgets("Flutter Widget Test",  (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      
    });

}
