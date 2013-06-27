// Some things we need.
import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'dart:async';
import 'dart:indexed_db';
import 'milestone.dart';
import 'count_down.dart';

class CountDownComponent extends WebComponent {
  
  // Observe errorMsg.
  // It displays a message for the user.
  @observable String errorMsg = '';

  // These are bound to input elements.
  String newMilestoneName = "New Year's Day";
  String newMilestoneDate = '2014-01-01';
  String newMilestoneTime = '00:00:00';
  
  /*
   * Click handlers.
   * NOTE: Minus - button handler is in xmilestone web component.
   */
  // Plus + button click handler.
  void addMilestone() {
    String str = newMilestoneDate + ' ' + newMilestoneTime;  
    DateTime occursOn = DateTime.parse(str);

    appObject.addMilestone(newMilestoneName, occursOn);
  }

  // Clear button click handler.
  void clear() {
    errorMsg = '';
    appObject.clear();
  }
   
  /*
   * Life-cycle bizness
   */
  void inserted() {
    appObject.start()
      .catchError((e) {
        (query('#addbutton') as ButtonElement).disabled = true;
        (query('#clearbutton') as ButtonElement).disabled = true;
        errorMsg = e.toString();
      });
  }
  
  void removed() {
    appObject.stop();
  }
} // end class
