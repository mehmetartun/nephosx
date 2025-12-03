import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/address.dart';
import '../../../model/company.dart';
import '../../../model/enums.dart';
import '../../../model/request.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';
import '../../../services/mock.dart';

part 'companies_state.dart';

class CompaniesCubit extends Cubit<CompaniesState> {
  final DatabaseRepository databaseRepository;
  CompaniesCubit(this.databaseRepository, this.user)
    : super(CompaniesInitial());

  User? user;
  List<Company> companies = [];
  List<User> users = [];
  List<Request> requestsMade = [];
  List<Request> requestsReceived = [];

  void init() async {
    if (user == null) {
      emit(CompaniesError(message: "User is null"));
      return;
    }
    if (user!.type == UserType.admin) {
      companies = await databaseRepository.getCompanies();
      emit(CompaniesLoaded(companies: companies));
      return;
    }

    if (user!.type == UserType.public) {
      requestsMade = await databaseRepository.getRequestsByRequestorId(
        user!.uid,
      );
      companies = await databaseRepository.getCompanies();

      if (requestsMade.isEmpty) {
        emit(CompaniesAssign(companies: companies, user: user!));
        return;
      } else {
        for (var request in requestsMade) {
          if (request.status == RequestStatus.pending &&
              request.requestType == RequestType.joinCompany) {
            emit(
              CompaniesAssign(
                companies: companies,
                user: user!,
                request: request,
              ),
            );
            return;
          } else {
            emit(CompaniesError(message: "You have a pending request"));
            return;
          }
        }
      }
    }

    if (user!.type == UserType.corporate) {
      Company company = await databaseRepository.getCompany(user!.companyId!);
      users = await databaseRepository.getUsers(companyId: company.id);
      emit(CompaniesEditCompany(company: company, users: users));
      return;
    }
    emit(CompaniesError(message: "User type is not admin or public"));
  }

  void addCompany(Map<String, dynamic> data) async {
    await databaseRepository.addDocument(
      collectionPath: 'companies',
      data: data,
    );
    init();
  }

  void onRequestCompany(Company company) async {
    emit(CompaniesInitial());
    await databaseRepository.addDocument(
      collectionPath: 'companies/${company.id}/requests',
      data: Request(
        id: Mock.uid(),
        requestorId: user!.uid,
        requestDate: DateTime.now(),
        requestType: RequestType.joinCompany,
        status: RequestStatus.pending,
        summary:
            "Request to join company ${company.name}\n"
            "by ${user!.email}\n${user!.firstName} ${user!.lastName}",
      ).toJson(),
    );
    init();
  }

  void updateCompany(Company company) async {
    emit(CompaniesInitial());
    await databaseRepository.updateDocument(
      docPath: 'companies/${user!.company!.id}',
      data: company.toJson(),
    );
    // Company co = await databaseRepository.getCompany(user!.company!.id);
    user = user!.copyWith(company: company);
    init();
  }

  void addressUpdate(Company company, Address address, int index) {
    emit(CompaniesInitial());
    company.addresses[index] = address;
    updateCompany(company);
  }

  void addressAdd(Company company, Address address) {
    emit(CompaniesInitial());

    company.addresses.add(address);
    print(company.toJson());
    print(address.toJson());
    updateCompany(company);
  }

  void setPrimaryContact(User user) async {
    emit(CompaniesInitial());

    await databaseRepository.updateDocument(
      docPath: 'companies/${user.company!.id}',
      data: {'primary_contact_id': user.uid, 'primary_contact': user.toJson()},
    );
    init();
  }
}
