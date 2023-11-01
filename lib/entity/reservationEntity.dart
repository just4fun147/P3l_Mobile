class Reservation {
  final String? id;

  String? invoice_number, id_booking, start_date, end_date;
  int? adult, child, status;

  Reservation(
      {this.id,
      this.invoice_number,
      this.id_booking,
      this.start_date,
      this.end_date,
      this.adult,
      this.child,
      this.status});
}
