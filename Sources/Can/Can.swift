import Foundation

@main
public enum Can {
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
