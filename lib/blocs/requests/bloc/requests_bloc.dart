import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/request.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';

part 'requests_event.dart';
part 'requests_state.dart';

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  RequestsBloc({required this.databaseRepository}) : super(RequestsInitial()) {
    on<RequestsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<RequestsEventUserChanged>((event, emit) {
      emit(RequestsLoading());
      _handleUserChanged(event, emit);
    });

    on<RequestsEventRequestsUpdated>((event, emit) {
      _handleRequestsUpdated(event, emit);
    });
  }
  final DatabaseRepository databaseRepository;

  // StreamSubscription<List<Request>>? _myRequestsSubscription;
  // StreamSubscription<List<Request>>? _companyRequestsSubscription;

  StreamSubscription<List<Request>>? _requestsSubscription;

  Stream<List<Request>>? userRequestsStream;
  Stream<List<Request>>? companyRequestsStream;

  void _handleUserChanged(RequestsEventUserChanged event, emit) async {
    _requestsSubscription?.cancel();
    if (event.user == null) {
      add(RequestsEventRequestsUpdated([]));
      return;
    }
    userRequestsStream = databaseRepository.getRequestsByRequestorIdStream(
      event.user!.uid,
    );
    if (event.user!.companyId != null) {
      companyRequestsStream = databaseRepository.getRequestsByCompanyIdStream(
        event.user!.companyId!,
      );
    } else {
      companyRequestsStream = Stream<List<Request>>.empty();
    }

    _requestsSubscription =
        Rx.combineLatest2(userRequestsStream!, companyRequestsStream!, (
          userRequests,
          companyRequests,
        ) {
          return [...userRequests, ...companyRequests];
        }).listen((requests) {
          print("Request....");
          add(RequestsEventRequestsUpdated(requests));
        });
  }

  void _handleRequestsUpdated(
    RequestsEventRequestsUpdated event,
    Emitter<RequestsState> emit,
  ) {
    emit(RequestsUpdatedState(requests: event.requests));
  }
}
