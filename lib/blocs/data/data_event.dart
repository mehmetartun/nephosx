part of 'data_bloc.dart';

sealed class DataEvent {}

final class DataStartEvent extends DataEvent {
  final User user;

  DataStartEvent({required this.user});
}

final class DataStopEvent extends DataEvent {}

final class DataRefreshEvent extends DataEvent {}
