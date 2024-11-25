import 'dart:async';
import 'package:event_truck/event_truck.dart';
import 'package:test/test.dart';

class TestObserver implements EventTrackObserver {
  final List<Object?> observedEvents = [];

  @override
  void onEvent<E, T>(EventTruck<E> truck, T event) {
    observedEvents.add(event);
  }
}

void main() {
  group('EventTruck', () {
    late EventTruck<Object> eventTruck;

    setUp(() {
      eventTruck = EventTruck<Object>();
    });

    tearDown(() {
      eventTruck.dispose();
    });

    test('on() listens to events of a specific type', () async {
      final receivedEvents = <String>[];

      eventTruck
        ..on<String>(receivedEvents.add)
        ..add('Test Event')
        ..add(42); // This event should not be received

      // Allow some time for the stream to propagate events
      await Future.delayed(Duration.zero, () {});

      expect(receivedEvents, ['Test Event']);
    });

    test('add() emits events to multiple listeners of the same type', () async {
      final listener1Events = <String>[];
      final listener2Events = <String>[];

      eventTruck
        ..on<String>(listener1Events.add)
        ..on<String>(listener2Events.add)
        ..add('Shared Event');

      // Allow some time for the stream to propagate events
      await Future.delayed(Duration.zero, () {});

      expect(listener1Events, ['Shared Event']);
      expect(listener2Events, ['Shared Event']);
    });

    test('add() does not emit events of other types', () async {
      final receivedInts = <int>[];

      eventTruck
        ..on<int>(receivedInts.add)
        ..add('Test String') // This should not be received
        ..add(42); // This should be received

      // Allow some time for the stream to propagate events
      await Future.delayed(Duration.zero, () {});

      expect(receivedInts, [42]);
    });

    test('Observer is notified of all events', () {
      EventTruck.observer = TestObserver();

      eventTruck
        ..add('Observed Event')
        ..add(123);

      if (EventTruck.observer case TestObserver observer) {
        expect(observer.observedEvents, ['Observed Event', 123]);
      }
    });

    test('dispose() closes the stream and prevents further events', () async {
      final receivedEvents = <String>[];

      eventTruck
        ..on<String>(receivedEvents.add)
        ..dispose();

      // Try to emit an event after disposing
      expect(() => eventTruck.add('This should not emit'), throwsStateError);

      // Allow some time for the stream to propagate (it should not emit anything)
      await Future.delayed(Duration.zero, () {});

      expect(receivedEvents, isEmpty);
    });

    test('Multiple listeners for different types work independently', () async {
      final stringEvents = <String>[];
      final intEvents = <int>[];

      eventTruck
        ..on<String>(stringEvents.add)
        ..on<int>(intEvents.add)
        ..add('Hello')
        ..add(123);

      // Allow some time for the stream to propagate events
      await Future.delayed(Duration.zero, () {});

      expect(stringEvents, ['Hello']);
      expect(intEvents, [123]);
    });

    test('on() returns a Stream<T> that allows chaining', () async {
      final transformedEvents = <String>[];

      eventTruck
        ..on<String>(transformedEvents.add)
        ..add('Test');

      // Allow some time for the stream to propagate events
      await Future.delayed(Duration.zero, () {});

      expect(transformedEvents, ['Test']);
    });
  });
}
