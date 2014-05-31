// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:indexed_db';
import 'milestone.dart';
import 'package:polymer/polymer.dart';

/*
 * The VIEW-MODEL for the app.
 * 
 * Implements the business logic 
 * and manages the information exchanges
 * between the MODEL (Milestone & MilestoneStore)
 * and the VIEW (CountDownComponent & MilestoneComponent).
 * 
 * Manages a Timer to update the milestones.
 */

MilestoneApp appObject = new MilestoneApp();


class MilestoneApp extends Observable {
  /****
   * Some things we need...
   */
  // When there are no active milestones, timer is null.
  Timer timer = null;
  
  // Is IndexedDB supported in this browser?
  bool idbAvailable = IdbFactory.supported;
  
  // A place to save the milestones (is the MODEL).
  MilestoneStore _store = new MilestoneStore();
  
  // Called from the VIEW.
  @observable bool hazMilestones;
  
  // The list of milestones in the MODEL.
  List<Milestone> get milestones => _store.milestones;
 
  /****
   * Life-cycle methods...
   */
  
  // Called from the VIEW when the element is inserted into the DOM.
  Future start() {
    if (!idbAvailable) {
      return new Future.error('IndexedDB not supported.');
    }
    
    return _store.open().then((_) {
      _startMilestoneTimer();
      hazMilestones = notifyPropertyChange(const Symbol('hazMilestones'),
          hazMilestones, (milestones.length == 0) ? false : true);

    });
  }
  
  // Called from the VIEW when the element is removed from the DOM.
  void stop() {
    _stopMilestoneTimer(true);
  }

  /****
   * Click handlers...
   * Called from the VIEW (tute_countdown) when the user clicks a button.
   * Delegates to MODEL.
   */
  
  void addMilestone(String milestoneName, DateTime occursOn) {
    // Make sure milestone is in the future, and not in the past.
    if (occursOn.isAfter(new DateTime.now())) {
      _store.add(milestoneName, occursOn).then((_) {
        _startMilestoneTimer();
        hazMilestones = notifyPropertyChange(const Symbol('hazMilestones'),
            hazMilestones, (milestones.length == 0) ? false : true);
      },
      onError: (e) { print('duplicate key'); } );
    }
  }

  Future removeMilestone(Milestone milestone) {
    return _store.remove(milestone).then((_) {
      _stopMilestoneTimer(false);
      hazMilestones = notifyPropertyChange(const Symbol('hazMilestones'),
          hazMilestones, (milestones.length == 0) ? false : true);
   });
  }
  
  Future clear() {
    return _store.clear().then((_) {
      _stopMilestoneTimer(false);
      hazMilestones = notifyPropertyChange(const Symbol('hazMilestones'),
          hazMilestones, (milestones.length == 0) ? false : true);
    });
  }
   
  /****
   * Timer stuff.
   */
  // Starts the timer if it's off and there are milestones.
  void _startMilestoneTimer() {
    if (timer == null && milestones.length > 0) {
      // The timer goes off every second.
      var oneSecond = new Duration(seconds:1);
      timer = new Timer.periodic(oneSecond, _tick);
    }
  }
  
  // Turn off the timer if no milestones or they are all elapsed.
  void _stopMilestoneTimer(bool quitting) {
    if (quitting || (timer != null && milestones.where((m) => !m.elapsed).isEmpty)) {
      timer.cancel();
      timer = null;
    }
  }
  
  // Update the display for each milestone.
  void _tick(Timer _) {
    // For each milestone, update the time remaining...
    for (int i = 0; i < milestones.length; i++) {
      milestones[i].tick();
    }
  }
}
