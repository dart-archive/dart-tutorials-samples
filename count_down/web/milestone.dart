// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library milestone;

import 'dart:async';
import 'dart:html';
import 'dart:indexed_db' as idb;

import 'package:observe/observe.dart';

/// The MODEL for the app.
///
/// Contains two classes:
/// Milestone to hold info for an individual milestone.
/// MilestoneStore to manage a list of milestones in memory
/// and in the IndexedDB.

/// A class to hold the info for an individual milestone.
class Milestone extends Observable {
  final String milestoneName;
  final DateTime happensOn;
  var dbKey;

  Duration timeRemaining = new Duration();
  @observable String timeRemainingAsString;

  Milestone(this.milestoneName, this.happensOn);

  String toString() => '$milestoneName $happensOn';

  // Constructor which creates a milestone
  // from the value (a Map) stored in the database.
  Milestone.fromRaw(key, Map value)
      : dbKey = key,
        milestoneName = value['milestoneName'],
        happensOn = DateTime.parse(value['happensOn']) {
    tick();
  }

  // Serialize this to an object (a Map) to insert into the database.
  Map toRaw() {
    return {
      'milestoneName': milestoneName,
      'happensOn': happensOn.toString(),
    };
  }

  bool get elapsed {
    return new DateTime.now().isAfter(happensOn);
  }

  // Called from the VIEW-MODEL to update the time remaining.
  void tick() {
    timeRemaining = happensOn.difference(new DateTime.now());
    timeRemainingAsString = formatTimeRemainingAsString();
  }

  // This should really be in the VIEW.
  String formatTimeRemainingAsString() {
    String _displayString;

    if (elapsed) {
      _displayString = 'Huzzah for ${milestoneName}!';
      return _displayString;
    }

    // Calculate days, hours, and minutes remaining.
    // Duration timeRemaining = milestone.timeRemaining;

    int d = timeRemaining.inDays;
    int h = timeRemaining.inHours.remainder(Duration.HOURS_PER_DAY);
    int m =
        timeRemaining.inMinutes.remainder(Duration.MINUTES_PER_HOUR);
    int s = timeRemaining.inSeconds
        .remainder(Duration.SECONDS_PER_MINUTE);

    // Format individual pieces of the display string.
    String days = (d == 0) ? '' : '$d days, ';
    String hours = (h == 0) ? '' : '$h hours, ';
    String minutes = (m == 0) ? '' : '$m minutes, ';
    String seconds = '$s seconds';

    _displayString =
        '$days $hours $minutes $seconds until $milestoneName';
    return _displayString;
  }
}

/// A class to manage a list of milestones in memory
/// and in an IndexedDB.
class MilestoneStore {
  static const String MILESTONE_STORE = 'milestoneStore';
  static const String NAME_INDEX = 'name_index';

  final List<Milestone> milestones = toObservable(new List());

  idb.Database _db;

  Future open() async {
    var db = await window.indexedDB.open('milestoneDB',
        version: 1, onUpgradeNeeded: _initializeDatabase);
    return _loadFromDB(db);
  }

  // Initializes the object store if it is brand new,
  // or upgrades it if the version is older.
  void _initializeDatabase(idb.VersionChangeEvent e) {
    idb.Database db = (e.target as idb.Request).result;

    var objectStore =
        db.createObjectStore(MILESTONE_STORE, autoIncrement: true);

    // Create an index to search by name,
    // unique is true: the index doesn't allow duplicate milestone names.
    objectStore.createIndex(NAME_INDEX, 'milestoneName',
        unique: true);
  }

  // Loads all of the existing objects from the database.
  // The future completes when loading is finished.
  Future _loadFromDB(idb.Database db) async {
    _db = db;

    var trans = db.transaction(MILESTONE_STORE, 'readonly');
    var store = trans.objectStore(MILESTONE_STORE);

    // Get everything in the store.
    var cursors =
        store.openCursor(autoAdvance: true).asBroadcastStream();
    await for (var cursor in cursors) {
      // Add milestone to the internal list.
      var milestone = new Milestone.fromRaw(cursor.key, cursor.value);
      milestones.add(milestone);
    }

    await cursors.length;
  }

  // Adds a new milestone to the milestones in the Database.
  //
  // This returns a Future with the new milestone when the milestone
  // has been added.
  Future<Milestone> add(
      String milestoneName, DateTime occursOn) async {
    var milestone = new Milestone(milestoneName, occursOn);
    var milestoneAsMap = milestone.toRaw();

    var transaction = _db.transaction(MILESTONE_STORE, 'readwrite');
    var objectStore = transaction.objectStore(MILESTONE_STORE);

    // NOTE! The key cannot be used until the transaction completes.
    milestone.dbKey = await objectStore.add(milestoneAsMap);

    // Note that the milestone cannot be queried until the transaction
    // has completed!
    await transaction.completed;
    await milestones.add(milestone);
    return milestone;
  }

  // Removes a milestone from the list of milestones.
  //
  // This returns a Future that completes when the milestone has been removed.
  Future remove(Milestone milestone) async {
    // Remove from database.
    var transaction = _db.transaction(MILESTONE_STORE, 'readwrite');
    transaction.objectStore(MILESTONE_STORE).delete(milestone.dbKey);

    await transaction.completed;
    // Null out the key to indicate that the milestone is dead.
    milestone.dbKey = null;
    // Remove from internal list.
    milestones.remove(milestone);
  }

  // Removes ALL milestones.
  Future clear() async {
    // Clear database.
    var transaction = _db.transaction(MILESTONE_STORE, 'readwrite');
    transaction.objectStore(MILESTONE_STORE).clear();

    await transaction.completed;
    // Clear internal list.
    milestones.clear();
  }
}
