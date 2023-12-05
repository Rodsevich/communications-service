/// This is the variant of the SMTP server.
enum SmptVariant {
  
  /// This is for using gmail as the SMTP server.
  gmail, 

  /// This is for using outlook as the SMTP server.
  outlook,
}

/// This is the status of the email.
enum EmailStatus {
  /// This is for an email that has been sent.
  sent,

  /// This is for an email that has not been sent.
  notSent,

  /// This is for an email that has been scheduled.
  queued,

  /// This is for an email that has not been sent successful and need to be
  /// forwarded.
  failed,
}
