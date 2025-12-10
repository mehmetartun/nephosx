import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import 'package:nephosx/repositories/database/database.dart';

import '../../../model/enums.dart';
import '../../../model/request.dart';

part 'admin_onboarding_state.dart';

class AdminOnboardingCubit extends Cubit<AdminOnboardingState> {
  AdminOnboardingCubit(this.databaseRepository)
    : super(AdminOnboardingInitial());
  final DatabaseRepository databaseRepository;

  HttpsCallable addCompany = FirebaseFunctions.instance.httpsCallable(
    'adminAddCompany',
  );

  List<Request> requests = [];
  Request? selectedRequest;

  init() async {
    // var qs = await FirebaseFirestore.instance.collectionGroup('requests').get();
    // print(qs.docs.length);
    // for (var doc in qs.docs) {
    //   await doc.reference.delete();
    // }

    // var res = await databaseRepository.addDocument(
    //   collectionPath: 'requests',
    //   data: Request(
    //     id: '',
    //     type: RequestType.createCompany,
    //     status: RequestStatus.pending,
    //     data: {
    //       'company_name': 'Test Company',
    //       'company_domain': 'test.com',
    //       'company_phone': '+123123123123',
    //       'requesting_user_id': '8ep7faM20xUE3J8TVq16KL6Y2jl1',
    //     },
    //     requestDate: DateTime.now(),
    //   ).toJson(),
    // );
    // print(res);
    requests = await databaseRepository.getRequests();
    emit(AdminOnboardingLoaded(requests: requests));
  }

  void onCancel() async {
    emit(AdminOnboardingInitial());
    selectedRequest = null;
    requests = await databaseRepository.getRequests();
    emit(AdminOnboardingLoaded(requests: requests));
  }

  void onRejectRequest() async {
    emit(AdminOnboardingInitial());
    await databaseRepository.updateDocument(
      docPath: "requests/${selectedRequest!.id}",
      data: selectedRequest!.copyWith(status: RequestStatus.rejected).toJson(),
    );
    requests = await databaseRepository.getRequests();
    emit(AdminOnboardingLoaded(requests: requests));
  }

  void onAddCompany({
    required String companyName,
    required String companyDomain,
    required String confirmationEmail,
    required String userId,
  }) async {
    emit(AdminOnboardingInitial());
    HttpsCallableResult? res;
    try {
      res = await addCompany.call({
        'companyName': companyName,
        'companyDomain': companyDomain,
        'confirmationEmail': confirmationEmail,
        'userId': userId,
        'userType': 'corporate_admin',
        'requestId': selectedRequest!.id,
      });
    } catch (e) {
      print(e);
      emit(AdminOnboardingError(error: e.toString()));
    }
    print(res?.data);

    requests = await databaseRepository.getRequests();
    emit(AdminOnboardingLoaded(requests: requests));
  }

  void viewRequest(Request request) async {
    selectedRequest = request;
    emit(AdminOnboardingInitial());
    Map<String, dynamic> extraData = await getRequestData(request);
    selectedRequest = selectedRequest!.copyWith(
      data: {...selectedRequest!.data, ...extraData},
    );
    emit(AdminOnboardingRequestLoaded(request: selectedRequest!));
  }

  Future<Map<String, dynamic>> getRequestData(Request request) async {
    if (request.type == RequestType.createCompany) {
      if (request.data['requesting_user_id'] != null) {
        var user = await databaseRepository.getUserData(
          request.data['requesting_user_id'],
        );
        return {'user': user.toJson()};
      }
    }
    return {};
  }
}
