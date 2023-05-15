import Foundation

/// Error cases representing failures in moving files to the Trash.
enum TrashError: Error {
  case moveFailed(String)
  case fileNotFound(String)

  var localizedDescription: String {
    switch self {
    case let .moveFailed(filename):
      return "Failed to move the file '\(filename)' to Trash."
    case let .fileNotFound(filename):
      return "File '\(filename)' not found."
    }
  }
}

/// A utility for moving files to the Trash.
enum Trash {
  /// Moves the file at the specified URL to the Trash.
  ///
  /// - Parameters:
  ///   - url: The URL of the file to move to the Trash.
  ///   - fileManager: The file manager to use for the file moving
  ///     operation. Default is `FileManager.default`.
  /// - Returns: A result indicating success or failure, with a
  ///   `TrashError` in case of failure.
  static func file(at url: URL, using fileManager: FileManager = .default) -> Result<Void, TrashError> {
    var resultingURL: NSURL?
    do {
      try fileManager.trashItem(at: url, resultingItemURL: &resultingURL)
      if resultingURL == nil {
        return .failure(.moveFailed(url.lastPathComponent))
      }
      return .success(())
    } catch {
      return .failure(.moveFailed(url.lastPathComponent))
    }
  }
}
