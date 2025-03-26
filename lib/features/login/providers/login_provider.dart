import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/login/response_models/assembly_response_model.dart';
import 'package:ysr_project/features/login/response_models/parliament_response_model.dart';

class SignupModel {
  String fullName;
  String mobileNumber;
  String? email;
  String password;
  bool isMale;
  Parliament? parliament;
  Assembly? assembly;
  String? country;
  String? state;
  String? referralCode;

  SignupModel({
    required this.fullName,
    required this.mobileNumber,
    this.email,
    required this.password,
    required this.isMale,
    this.parliament,
    this.assembly,
    this.country,
    this.state,
    this.referralCode,
  });

  SignupModel copyWith({
    String? fullName,
    String? mobileNumber,
    String? email,
    String? password,
    bool? isMale,
    Parliament? parliament,
    Assembly? assembly,
    String? country,
    String? state,
    String? referralCode,
  }) =>
      SignupModel(
        fullName: fullName ?? this.fullName,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        email: email ?? this.email,
        password: password ?? this.password,
        isMale: isMale ?? this.isMale,
        parliament: parliament ?? this.parliament,
        assembly: assembly ?? this.assembly,
        country: country ?? this.country,
        state: state ?? this.state,
        referralCode: referralCode ?? this.referralCode,
      );
}

final signupProvider = StateNotifierProvider<SignupNotifier, SignupModel>(
  (ref) => SignupNotifier(),
);

class SignupNotifier extends StateNotifier<SignupModel> {
  SignupNotifier()
      : super(SignupModel(
          fullName: '',
          mobileNumber: '',
          password: '',
          isMale: true,
        ));

  void updateFullName(String fullName) {
    state = state.copyWith(fullName: fullName);
  }

  void updateMobileNumber(String mobileNumber) {
    state = state.copyWith(mobileNumber: mobileNumber);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateIsMale(bool isMale) {
    state = state.copyWith(isMale: isMale);
  }

  void updateParliament(Parliament? parliament) {
    state = state.copyWith(parliament: parliament);
  }

  void updateAssembly(Assembly? assembly) {
    state = state.copyWith(assembly: assembly);
  }

  void updateCountry(String? country) {
    state = state.copyWith(country: country);
  }

  void updateState(String? states) {
    state = state.copyWith(state: states);
  }

  void updateEmail(String? email) {
    state = state.copyWith(email: email);
  }

  void updateReferralCode(String referralCode) {
    state = state.copyWith(referralCode: referralCode);
  }
}
