import 'package:flutter_test/flutter_test.dart';
import 'package:test_2/controllers/main_layout_controller.dart';

void main() {
  group('MainLayoutController Tests', () {
    test('Initial index should be 0', () {
      final controller = MainLayoutController();
      expect(controller.selectedIndex.value, 0);
    });

    test('changeTabIndex should update index', () {
      final controller = MainLayoutController();
      controller.changeTabIndex(2);
      expect(controller.selectedIndex.value, 2);
    });
  });
}
