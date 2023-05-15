enum ParsingError: Error {
  case invalidFilename(String)
  case missingArguments
}

/// A utility for parsing command-line options.
enum Options {
  /// The filenames that are considered exceptions and should not be
  /// removed.
  static let ignoredFilenames: Set<String> = ["/", ".", ".."]

  /// Parses the command-line arguments and returns the result.
  ///
  /// - Returns: A `Result` with either the array of filenames to
  ///   process on success, or an `OptionsParsingError` on failure.
  ///
  /// - Note: Use this method to parse command-line arguments. It
  ///   returns an array of filenames on success or an
  ///   `OptionsParsingError` indicating the specific error encountered
  ///   during parsing.
  public static func parseArguments() -> Result<[String], ParsingError> {
    let filenames = Array(CommandLine.arguments.dropFirst(1))
    guard !filenames.isEmpty else {
      return .failure(.missingArguments)
    }

    if let invalidFilename = filenames.first(where: { ignoredFilenames.contains($0) }) {
      return .failure(.invalidFilename(invalidFilename))
    }

    return .success(filenames)
  }
}
