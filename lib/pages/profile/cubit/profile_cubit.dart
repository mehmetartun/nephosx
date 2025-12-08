import 'package:nephosx/repositories/database/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/address.dart';
import '../../../model/user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.uid, required this.databaseRepository})
    : super(ProfileInitial());

  final String? uid;
  final DatabaseRepository databaseRepository;

  User? user;

  void init() async {
    emit(ProfileLoading());

    if (uid != null) {
      user = await databaseRepository.getUserData(uid!);
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

  void updateUserAddress(User user, Address address) async {
    emit(ProfileLoading());

    try {
      await databaseRepository.updateDocument(
        docPath: 'users/${user.uid}',
        data: {'address': address.toJson()},
      );
      // Re-fetch user to get the updated data and refresh the UI
      init();
    } catch (e) {
      // Optionally, emit an error state to show in the UI
      emit(ProfileError(errorMessage: 'Failed to update profile: $e'));
    }
  }
}
