// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Some things we need.
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'count_down.dart';

@CustomTag('tute-count-down')
class CountDownComponent extends PolymerElement {
  
  // Observe errorMsg.
  // It displays a message for the user.
  @observable String errorMsg = '';

  // These are bound to input elements.
  @observable String newMilestoneName = "New Year's Day 2020";
  @observable String newMilestoneDate = '2020-01-01';
  @observable String newMilestoneTime = '00:00:00';
  
  @observable MilestoneApp appObj = appObject;
  
  CountDownComponent.created() : super.created();
  /*
   * Click handlers.
   * NOTE: Minus - button handler is in xmilestone web component.
   */
  // Plus + button click handler.
  void addMilestone(Event e, var detail, Node target) {
    String str = newMilestoneDate + ' ' + newMilestoneTime;  
    DateTime occursOn = DateTime.parse(str);

    if (occursOn.isAfter(new DateTime.now())) {
      appObject.addMilestone(newMilestoneName, occursOn);
    } else { // TODO: improve error message
      print("Can't add a date in the past.");
    }
  }

  // Clear button click handler.
  void clear(Event e, var detail, Node target) {
    errorMsg = '';
    appObject.clear();
  }
   
  /*
   * Life-cycle bizness
   */
  void attached() {
    super.attached();
    appObject.start()
      .catchError((e) {
        ($['addbutton'] as ButtonElement).disabled = true;
        ($['clearbutton'] as ButtonElement).disabled = true;

        errorMsg = e.toString();
      });
  }
  
  void detached() {
    super.detached();
    appObject.stop();
  }
} // end class
