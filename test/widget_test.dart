import "package:flutter_test/flutter_test.dart";
import "package:sticky_notes/main.dart";

void main() {
  testWidgets("App loads", (tester) async {
    await tester.pumpWidget(const StickyNotesApp());
    expect(find.text("StickyNotes"), findsOneWidget);
  });
}
