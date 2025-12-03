part of 'requests_bloc.dart';

sealed class RequestsEvent {}

final class RequestsEventUserChanged extends RequestsEvent {
  final User? user;

  RequestsEventUserChanged(this.user);
}

final class RequestsEventRequestsUpdated extends RequestsEvent {
  final List<Request> requests;

  RequestsEventRequestsUpdated(this.requests);
}
