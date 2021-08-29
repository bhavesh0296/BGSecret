
import Foundation

public class SecretMessage: Codable {
    public let encrypted: String
    public var decrypted: String?

    public init(encrypted: String) {
        self.encrypted = encrypted
    }
}
