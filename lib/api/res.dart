class ResLogin {
  final String stat;
  final String mess;
  final OutData data;
  ResLogin({required this.stat, required this.mess, required this.data});
}

class OutData {
  final String token;
  final String name;
  OutData({required this.token, required this.name});
}
