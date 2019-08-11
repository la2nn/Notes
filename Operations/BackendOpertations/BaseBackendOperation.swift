import Foundation

enum Errors {
    case unreachable
    case noNotes
}

class BaseBackendOperation: AsyncOperation {
    override init() {
        super.init()
    }
}
