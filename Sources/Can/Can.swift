import Foundation

@main
public enum Can {
  /// Represents a system error encountered during an operation and
  /// provides a Swift representation of a C error.
  struct SystemError: Error {
    let errno: Int32
    var localizedDescription: String {
      String(cString: strerror(errno))
    }
  }

  /// Reverts the effective user ID (UID) of the process to the original
  /// value after running with elevated privileges. This is to avoid
  /// using the root user's Trash.
  ///
  /// - Returns: A `Result` object representing the success or failure
  ///   of the operation.
  ///   - On success, it returns `Void`.
  ///   - On failure, it returns a `SystemError` indicating the
  ///     encountered error.
  private static func revertToOriginalUserID() -> Result<Void, SystemError> {
    let processInfo = ProcessInfo()
    guard let sudoUser = processInfo.environment["SUDO_USER"] else {
      // Not running with elevated privileges.
      return .success(())
    }

    guard let uid = getpwnam(sudoUser)?.pointee.pw_uid else {
      // Failed to retrieve the user ID associated with the SUDO_USER.
      return .failure(SystemError(errno: errno))
    }

    return seteuid(uid) != 0 ? .failure(SystemError(errno: errno)) : .success(())
  }

  private static func trash(_ filenames: [String]) {
    filenames.forEach { filename in
      let fileManager = FileManager.default
      let url = URL(fileURLWithPath: filename)
      switch Result(catching: { try fileManager.trashItem(at: url, resultingItemURL: nil) }) {
      case .success: break
      case let .failure(error):
        eprint(error.localizedDescription)
      }
    }
  }

  public static func main() {
    switch revertToOriginalUserID() {
    case .success: break
    case let .failure(error):
      eprint(error.localizedDescription)
      exit(1)
    }

    switch Options.parseArguments() {
    case let .success(files):
      trash(files)
    case let .failure(error):
      switch error {
      case .missingArguments:
        print("Usage:\tcan file ...")
      case .invalidFilename:
        eprint("\(error.localizedDescription). \"/\", \".\", and \"..\" may not be removed.")
        exit(1)
      }
    }
  }
}
