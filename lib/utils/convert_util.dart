/// Converts [msisdn] to a ThreeUK compatible customerId.
String msisdnToCustomerId(String msisdn) {
  if (msisdn.toLowerCase().startsWith('msisdn/')) return msisdn;
  return 'msisdn/$msisdn';
}

/// Converts [email] to a ThreeUK compatible customerId.
String emailToCustomerId(String email) {
  if (email.toLowerCase().startsWith('email/')) return email;
  return 'email/$email';
}
