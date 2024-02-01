import UIKit
import Moya
import SnapKit
import KeychainSwift

class LoginViewController: UIViewController {

    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(logoutButton)
        view.addSubview(registerButton)
        
        usernameTextField.backgroundColor = .systemGray2
        usernameTextField.autocapitalizationType = .none
        
        passwordTextField.backgroundColor = .systemGray2
        passwordTextField.autocapitalizationType = .none
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        
        loginButton.setTitle("Войти в приложение", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        logoutButton.setTitle("Выйти из приложения", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        view.addSubview(logoutButton)
        
        registerButton.setTitle("Зарегистрироваться", for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        view.addSubview(registerButton)
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func loginButtonTapped() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            showErrorMessage("Please enter both username and password.")
            return
        }
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()

        NetworkService.shared.login(username: username, password: password) { result in
            switch result {
            case .success(let model):
                let keychain = KeychainSwift()
                keychain.set(model.accessToken, forKey: "authToken")
                self.showAlert(title: "Успех", message: "Вы успешно вошли!")
            case .failure(_):
                self.showAlert(title: "Ошибка", message: "Произошла ошибка входа!")
            }
        }
    }

    @objc private func logoutButtonTapped() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        NetworkService.shared.logout { result in
            switch result {
            case .success(let model):
                KeychainSwift().clear()
                self.showAlert(title: "Успех", message: "Вы успешно вышли!")
            case .failure(_):
                self.showAlert(title: "Ошибка", message: "Произошла ошибка выхода!")
            }
        }
    }

    @objc private func registerButtonTapped() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            showErrorMessage("Please enter both username and password.")
            return
        }
        
        NetworkService.shared.signUp(username: username, password: password) { result in
            
            
            DispatchQueue.main.async { // Убедитесь, что обновление UI происходит в главном потоке
                switch result {
                case .success(_):
                    self.showAlert(title: "Успех", message: "Вы успешно зарегистрированы!")
                    
                case .failure(_):
                    self.showAlert(title: "Ошибка", message: "Произошла ошибка регистрации")
                }
            }
        }
    }
    
    private func showErrorMessage(_ message: String) {
        // Отображение ошибки на экране
        print("Error: \(message)")
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
