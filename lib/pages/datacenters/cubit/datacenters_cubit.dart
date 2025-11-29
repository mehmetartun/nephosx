import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/pages/companies/cubit/companies_cubit.dart';

import '../../../model/company.dart';
import '../../../model/datacenter.dart';
import '../../../model/gpu.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';

part 'datacenters_state.dart';

class DatacentersCubit extends Cubit<DatacentersState> {
  final DatabaseRepository databaseRepository;
  DatacentersCubit(this.databaseRepository) : super(DatacentersInitial());

  List<Datacenter> datacenters = [];
  User? user;
  List<Gpu> gpus = [];

  void init({User? user}) async {
    this.user = user;
    if (user == null) {
      emit(DatacentersErrorState(message: "User not found"));
    }
    if (user!.companyId == null) {
      emit(DatacentersErrorState(message: "User not assigned to a company"));
      return;
    }
    datacenters = await databaseRepository.getDatacenters(
      companyId: user.companyId!,
    );
    emit(DatacentersLoaded(datacenters: datacenters));
  }

  void updateDatacenter(Datacenter datacenter) async {
    await databaseRepository.updateDocument(
      docPath: 'datacenters/${datacenter.id}',
      data: datacenter.toJson(),
    );
    init(user: user);
  }

  void backToDatacenters() {
    emit(DatacentersLoaded(datacenters: datacenters));
  }

  void getGpus(Datacenter datacenter) async {
    emit(DatacentersInitial());
    if (user == null) {
      return;
    }
    gpus = await databaseRepository.getGpus(datacenterId: datacenter.id);
    emit(DatacentersGpus(gpus: gpus, datacenter: datacenter));
  }

  void addDatacenter(Map<String, dynamic> data) async {
    if (user == null) {
      return;
    }
    await databaseRepository.addDocument(
      collectionPath: 'datacenters',
      data: {...data, 'company_id': user!.companyId!},
    );
    init(user: user);
  }

  void addGpu(Map<String, dynamic> data, Datacenter datacenter) async {
    if (user == null) {
      return;
    }
    await databaseRepository.addDocument(
      collectionPath: 'datacenters/${datacenter.id}/gpus',
      data: {
        ...data,
        'datacenter_id': datacenter.id,
        'company_id': datacenter.companyId,
      },
    );
    getGpus(datacenter);
  }

  void updateGpu(Gpu gpu, Datacenter datacenter) async {
    await databaseRepository.updateDocument(
      docPath: 'datacenters/${datacenter.id}/gpus/${gpu.id}',
      data: gpu.toJson(),
    );
    getGpus(datacenter);
  }
}
