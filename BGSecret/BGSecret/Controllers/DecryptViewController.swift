

import UIKit

public class DecryptViewController: UIViewController {
    
    // MARK: - Instance Properties
    public let passwordClient = PasswordClient()
    public let secretMessageCaretaker = SecretMessageCareTaker()
    
    // MARK: - Outlets
    @IBOutlet public var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 67
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
}

// MARK: - Segue Management
extension DecryptViewController {
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? PasswordViewController else { return }
        viewController.passwordClient = passwordClient
    }
}

// MARK: - UITableViewDataSource
extension DecryptViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secretMessageCaretaker.messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let secretMessage = secretMessageCaretaker.messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecretMessageCell") as! SecretMessageCell
        cell.configure(with: secretMessage)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DecryptViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let secretMessage = secretMessageCaretaker.messages[indexPath.row]
        guard secretMessage.decrypted == nil else { return }
        
        secretMessage.decrypted = passwordClient.decrypt(secretMessage.encrypted)
        guard secretMessage.decrypted != nil else {
            print("Decryption failed!")
            return
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
