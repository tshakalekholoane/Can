import Foundation

@main
public enum Can {
  private static func trash(_ files: [String]) {
    files.forEach { file in
      guard let url = URL(string: file) else {
        eprint("Invalid file path: \(file).")
        exit(1)
      }

      switch Trash.file(at: url) {
      case .success:
        print("Moved \(url.lastPathComponent) to Trash.")
      case .failure(TrashError.fileNotFound):
        eprint("File not found: \(url.lastPathComponent).")
        exit(1)
      case let .failure(error):
        eprint("Failed to move \(url.lastPathComponent) to Trash: \(error.localizedDescription).")
        exit(1)
      }
    }
  }

  public static func main() {
    switch Options.parseArguments() {
    case let .success(files):
      trash(files)
    case let .failure(error):
      switch error {
      case .missingArguments:
        eprint("Usage:\tcan file ...")
        exit(1)
      case let .invalidFilename(invalidFilename):
        eprint("Invalid filename encountered: \(invalidFilename). \"/\", \".\", and \"..\" may not be removed.")
        exit(1)
      }
    }
  }
}
