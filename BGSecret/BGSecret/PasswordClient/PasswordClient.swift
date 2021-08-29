
import RNCryptor
import SwiftKeychainWrapper

public class PasswordClient {

    // MARK: - Instance Properties
    public private(set) var passwords: [String] {
        didSet { setupDecryptionHandler() }
    }
    private let keychain = KeychainWrapper.standard
    private let passwordKey = "passwords"

    private var decryptionHandler: DecryptionHandlerProtocol?

    // MARK: - Object Lifecycle
    public init() {
        passwords = keychain.object(forKey: passwordKey) as? [String] ?? []
        setupDecryptionHandler()
    }

    private func setupDecryptionHandler() {
        guard passwords.count > 0 else {
            return
        }

        var current = DecryptionHandler(password: passwords.first!)
        decryptionHandler = current

        for i in 1..<passwords.count {
            let next  = DecryptionHandler(password: passwords[i])
            current.next = next
            current = next
        }
    }

    // MARK: - Password Management
    public func addPassword(_ password: String) {
        guard !passwords.contains(password) else { return }
        passwords.append(password)
        passwords.sort()
        savePasswordsToKeychain()
    }

    public func removePassword(at index: Int) {
        passwords.remove(at: index)
        savePasswordsToKeychain()
    }

    public func removePassword(_ password: String) {
        guard let index = passwords.firstIndex(of: password) else { return }
        passwords.remove(at: index)
        savePasswordsToKeychain()
    }

    private func savePasswordsToKeychain() {
        keychain.set(passwords as NSArray, forKey: passwordKey)
    }

    // MARK: - Encrypt
    public func encrypt(_ text: String, usingPassword password: String) -> String {
        let data = text.data(using: .utf8)!
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: password)
        return encryptedData.base64EncodedString()
    }

    // MARK: - Decrypt
    public func decrypt(_ base64EncodedString: String) -> String? {
        guard let data = Data(base64Encoded: base64EncodedString),
            let value = decryptionHandler?.decrypt(data: data) else {
                return nil
        }
        return value
    }
}
