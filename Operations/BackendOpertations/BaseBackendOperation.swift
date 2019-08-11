import Foundation

enum Errors {
    case unreachable
    case noNotes
    case fileNotExist
}

class BaseBackendOperation: AsyncOperation {
    override init() {
        super.init()
    }
}
