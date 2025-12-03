import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/pages/companies/cubit/companies_cubit.dart';

import '../../../model/company.dart';
import '../../../model/consideration.dart';
import '../../../model/datacenter.dart';
import '../../../model/gpu_cluster.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';

part 'datacenters_state.dart';

class DatacentersCubit extends Cubit<DatacentersState> {
  final DatabaseRepository databaseRepository;
  DatacentersCubit(this.databaseRepository) : super(DatacentersInitial());

  List<Datacenter> datacenters = [];
  User? user;
  List<GpuCluster> gpuClusters = [];
  List<Company> companies = [];
  String? companyId;

  void init({User? user}) async {
    this.user = user;
    if (user == null) {
      emit(DatacentersErrorState(message: "User not found"));
    }
    if (user!.companyId == null) {
      emit(DatacentersErrorState(message: "User not assigned to a company"));
      return;
    } else {
      companyId = user.companyId!;
    }

    companies = await databaseRepository.getCompanies();
    datacenters = await databaseRepository.getDatacenters(
      companyId: companyId!,
    );
    emit(
      DatacentersLoaded(
        datacenters: datacenters,
        companies: companies,
        companyId: companyId!,
      ),
    );
  }

  void updateDatacenter(Datacenter datacenter) async {
    await databaseRepository.updateDocument(
      docPath: 'datacenters/${datacenter.id}',
      data: datacenter.toJson(),
    );
    init(user: user);
  }

  void backToDatacenters() {
    emit(
      DatacentersLoaded(
        datacenters: datacenters,
        companies: companies,
        companyId: companyId!,
      ),
    );
  }

  void addDatacenterRequest() {
    emit(DatacenterAddEdit(companyId: companyId!));
  }

  void editDatacenterRequest(Datacenter datacenter) {
    emit(DatacenterAddEdit(datacenter: datacenter, companyId: companyId!));
  }

  void getGpuClusters(Datacenter datacenter) async {
    emit(DatacentersInitial());
    if (user == null) {
      return;
    }
    gpuClusters = await databaseRepository.getGpuClusters(
      datacenterId: datacenter.id,
    );
    emit(
      DatacentersGpuClusters(
        gpuClusters: gpuClusters,
        datacenter: datacenter,
        companies: companies,
      ),
    );
  }

  void addDatacenter(Datacenter datacenter) async {
    if (user == null) {
      return;
    }
    await databaseRepository.addDocument(
      collectionPath: 'datacenters',
      data: {...datacenter.toJson(), 'company_id': user!.companyId!},
    );
    init(user: user);
  }

  void addTransaction(GpuTransaction data) async {
    if (user == null) {
      return;
    }
    await databaseRepository.addDocument(
      collectionPath: 'transactions',
      data: data.toJson(),
    );
    init(user: user);
  }

  String? transactionValidator(
    GpuCluster gpuCluster,
    DateTime fromDate,
    DateTime toDate,
  ) {
    if (gpuCluster.transactions == null) {
      return null;
    }
    String? errorText = null;
    for (var transaction in gpuCluster.transactions!) {
      if (fromDate.isAfter(transaction.endDate) ||
          toDate.isBefore(transaction.startDate)) {
      } else {
        errorText = "Transaction date range overlaps with another transaction";
        return errorText;
      }
    }
    return errorText;
  }

  void addGpuCluster(Map<String, dynamic> data, Datacenter datacenter) async {
    if (user == null) {
      return;
    }
    await databaseRepository.addDocument(
      collectionPath: 'datacenters/${datacenter.id}/gpu_clusters',
      data: {
        ...data,
        'datacenter_id': datacenter.id,
        'company_id': user!.companyId,
      },
    );
    getGpuClusters(datacenter);
  }

  void updateGpuCluster(GpuCluster gpuCluster, Datacenter datacenter) async {
    await databaseRepository.updateDocument(
      docPath: 'datacenters/${datacenter.id}/gpu_clusters/${gpuCluster.id}',
      data: gpuCluster.toJson(),
    );
    getGpuClusters(datacenter);
  }
}
