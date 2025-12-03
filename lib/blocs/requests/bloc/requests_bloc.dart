import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/request.dart';
import '../../../model/user.dart';

part 'requests_event.dart';
part 'requests_state.dart';

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  RequestsBloc() : super(RequestsInitial()) {
    on<RequestsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<RequestsEventUserChanged>((event, emit) {
      // TODO: implement event handler
      emit(RequestsLoading());
    });
    on<RequestsEventRequestsUpdated>((event, emit) {
      // TODO: implement event handler
      emit(RequestsUpdatedState(requests: event.requests));
    });
  }

  StreamSubscription<List<Request>>? _streamSubscription;
}
