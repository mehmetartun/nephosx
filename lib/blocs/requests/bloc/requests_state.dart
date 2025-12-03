part of 'requests_bloc.dart';

sealed class RequestsState {}

final class RequestsInitial extends RequestsState {}

final class RequestsLoading extends RequestsState {}

final class RequestsUpdatedState extends RequestsState {
  final List<Request> requests;

  RequestsUpdatedState({required this.requests});
}

final class RequestsErrorState extends RequestsState {
  final String message;

  RequestsErrorState({required this.message});
}
