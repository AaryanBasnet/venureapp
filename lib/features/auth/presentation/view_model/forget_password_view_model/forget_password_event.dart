



abstract class ForgotPasswordEvent {}

class SendResetCodeEvent extends ForgotPasswordEvent {
  final String email;
  SendResetCodeEvent(this.email);
}

class VerifyResetCodeEvent extends ForgotPasswordEvent {
  final String email;
  final String code;
  VerifyResetCodeEvent(this.email, this.code);
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  final String email;
  final String code;
  final String newPassword;
  ResetPasswordEvent(this.email, this.code, this.newPassword);
}