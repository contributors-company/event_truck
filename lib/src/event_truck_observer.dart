import 'package:event_truck/event_truck.dart';

/// Interface class for observing events emitted by the `EventTruck`.
///
/// Implement this class if you want to monitor all events added to the bus.
/// Useful for debugging, logging, or analytics purposes.
interface class EventTrackObserver {
  /// Called whenever an event is added to the `EventTruck`.
  ///
  /// - [T] is the type of the event being emitted.
  ///
  /// Example:
  /// ```dart
  /// class MyObserver implements EventTrackObserver {
  ///   @override
  ///   void onEvent<T>(T event) {
  ///     print('Observed event: $event');
  ///   }
  /// }
  /// ```
  void onEvent<E, T>(EventTruck<E> trick, T event) {}
}
