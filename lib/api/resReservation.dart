class ResLogin {
  final String stat;
  final String mess;
  final OutData data;
  ResLogin({required this.stat, required this.mess, required this.data});
}

class OutData {
  final String id;
  final String invoice_number;
  final String id_booking;
  final String start_date;
  final String end_date;
  final int adult;
  final int child;
  final int status;
  OutData(
      {required this.id,
      required this.invoice_number,
      required this.id_booking,
      required this.start_date,
      required this.end_date,
      required this.adult,
      required this.child,
      required this.status});
}
