import Foundation

/// Prints error messages to the standard error stream.
///
/// This function allows you to easily print one or more error messages
/// to the standard error stream. It converts the provided items to
/// strings, concatenates them with the specified separator, and appends
/// the terminator at the end. The resulting message is then written to
/// the standard error stream.
///
/// - Parameters:
///    - items: One or more error message items to be printed. Each item
///      will be converted to a string before concatenation.
///    - separator: The string to be used as a separator between the
///      error message items. The default value is a single space.
///    - terminator: The string to be appended at the end of the error
///      message. The default value is a new line character.
func eprint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
  let standardError = FileHandle.standardError
  let message = items.map { "\($0)" }.joined(separator: separator) + terminator
  if let data = message.data(using: .utf8) {
    standardError.write(data)
  }
}
