import 'package:cloud_functions/cloud_functions.dart';
import 'package:coach/repositories/database/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.uid, required this.databaseRepository})
    : super(ProfileInitial());

  final String? uid;
  final DatabaseRepository databaseRepository;

  User? user;

  HttpsCallable getProvidersForEmail = FirebaseFunctions.instance.httpsCallable(
    'getProvidersForEmail',
  );

  void init() async {
    emit(ProfileLoading());
    HttpsCallableResult result;
    if (uid != null) {
      user = await databaseRepository.getUserData(uid!);
      result = await getProvidersForEmail.call(<String, dynamic>{
        'email': user?.email,
      });
    } else {
      user = null;
    }

    if (user == null) {
      emit(ProfileError(errorMessage: 'User not found'));
      return;
    }

    emit(ProfileLoaded());
  }

  void editProfile() {
    if (user == null) return;
    emit(ProfileEdit(user: user!));
  }

  void cancelEditUser() {
    emit(ProfileLoaded());
  }

  void updateUser(Map<String, dynamic> data) async {
    emit(ProfileLoading());
    if (user == null) {
      emit(ProfileError(errorMessage: 'User is null'));
      return;
    }

    try {
      await databaseRepository.updateUserData(data);
      // Re-fetch user to get the updated data and refresh the UI
      init();
    } catch (e) {
      // Optionally, emit an error state to show in the UI
      emit(ProfileError(errorMessage: 'Failed to update profile: $e'));
    }
  }
}
