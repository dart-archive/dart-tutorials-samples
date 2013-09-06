// Some things we need.
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'count_down.dart';

@CustomTag('x-count-down')
class CountDownComponent extends PolymerElement with ObservableMixin {
  
  // Observe errorMsg.
  // It displays a message for the user.
  @observable String errorMsg = '';

  // These are bound to input elements.
  @observable String newMilestoneName = "New Year's Day";
  @observable String newMilestoneDate = '2014-01-01';
  @observable String newMilestoneTime = '00:00:00';
  
  @observable MilestoneApp appObj = appObject;
  
  /*
   * Click handlers.
   * NOTE: Minus - button handler is in xmilestone web component.
   */
  // Plus + button click handler.
  void addMilestone(Event e, var detail, Node target) {
    String str = newMilestoneDate + ' ' + newMilestoneTime;  
    DateTime occursOn = DateTime.parse(str);

    appObject.addMilestone(newMilestoneName, occursOn);
  }

  // Clear button click handler.
  void clear(Event e, var detail, Node target) {
    errorMsg = '';
    appObject.clear();
  }
   
  /*
   * Life-cycle bizness
   */
  void inserted() {
    appObject.start()
      .catchError((e) {
        (getShadowRoot("tute-stopwatch").query('.addbutton') as ButtonElement).disabled = true;
        (getShadowRoot("tute-stopwatch").query('.clearbutton') as ButtonElement).disabled = true;

        errorMsg = e.toString();
      });
  }
  
  void removed() {
    appObject.stop();
  }
} // end class
