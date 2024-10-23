//
//  ConsentViewController.swift
//  CMPSDKv2DemoApp
//
//  Created by Fabio Torre on 23/10/24.
//

import Foundation
import UIKit
import CmpSdk

class ConsentViewController: UIViewController {
    private var toastView: UIView?
    private let stackView = UIScrollView()
    private let contentStackView = UIStackView()
    private var onConsentInitialized: (() -> Void)?

    private lazy var cmpManager: CMPConsentTool = {
        let cmpConfig: CmpConfig = CmpConfig.shared.setup(
            withId: "Your ID here",  // TO-DO: replace this with the Code-ID from your CMP
            domain: "delivery.consentmanager.net",
            appName: "CMPSDKv2DemoApp",
            language: "IT")
        
        cmpConfig.logLevel = CmpLogLevel.verbose
        cmpConfig.isAutomaticATTRequest = true
        
        return CMPConsentTool(cmpConfig: cmpConfig)
            .withErrorListener(onCMPError)
            .withCloseListener(onClose)
            .withOpenListener(onOpen)
            .withOnCMPNotOpenedListener(onCMPNotOpened)
            .withOnCmpButtonClickedCallback(onButtonClickedEvent)
    }()

    init(onConsentInitialized: (() -> Void)? = nil) {
        self.onConsentInitialized = onConsentInitialized
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        if onConsentInitialized != nil {
            initializeConsent()
        }
    }
    
    private func initializeConsent() {
        // Now we just need to call initialize() since configuration is done in the lazy property
        cmpManager.initialize()
        
        DispatchQueue.main.async {
            self.onConsentInitialized?()
        }
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.alignment = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: stackView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -40)
        ])
        
        setupButtons()
    }
    
    private func setupButtons() {
        let titleLabel = UILabel()
        titleLabel.text = "CM Swift DemoApp"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textAlignment = .center
        contentStackView.addArrangedSubview(titleLabel)
        
        addButton("Has User Choice?", color: .systemBlue) { [weak self] in
            let hasConsent = self?.cmpManager.hasConsent()
            self?.showToast(message: "Has User Choice: \(String(describing: hasConsent))")
        }
        
        addButton("Get CMP String", color: .systemTeal) { [weak self] in
            let cmpString = self?.cmpManager.getConsentString()
            self?.showToast(message: "CMP String: \(String(describing: cmpString))")
        }
        
        addButton("Get All Purposes", color: .systemMint) { [weak self] in
            let cmpString = self?.cmpManager.getAllPurposes()
            self?.showToast(message: "CMP String: \(String(describing: cmpString))")
        }
        
        addButton("Has Purpose ID c53?", color: .systemMint) { [weak self] in
            let cmpString = self?.cmpManager.hasPurposeConsent("c53")
            self?.showToast(message: "CMP String: \(String(describing: cmpString))")
        }
        
        addButton("Get Enabled Purposes", color: .systemMint) { [weak self] in
            let cmpString = self?.cmpManager.getEnabledPurposes()
            self?.showToast(message: "CMP String: \(String(describing: cmpString))")
        }

        addButton("Get Disabled Purposes", color: .systemGray) { [weak self] in
            let cmpString = self?.cmpManager.getDisabledPurposes()
            self?.showToast(message: "CMP String: \(String(describing: cmpString))")
        }

        addButton("Enable Purposes c52 and c53", color: .systemMint) { [weak self] in
            self?.cmpManager.enablePurposeList(["c52", "c53"])
            self?.showToast(message: "Purposes c52 and c53 enabled.")
        }

        addButton("Disable Purposes c52 and c53", color: .systemRed) { [weak self] in
            self?.cmpManager.disablePurposeList(["c52", "c53"])
            self?.showToast(message: "Purposes c52 and c53 disabled")
        }

        addButton("Get All Vendors", color: .systemCyan) { [weak self] in
            let cmpString = self?.cmpManager.getAllVendors()
            self?.showToast(message: "CMP String: \(String(describing: cmpString))")
        }

        addButton("Has Vendor ID s2789?", color: .systemCyan) { [weak self] in
            let cmpString = self?.cmpManager.hasVendorConsent("s2789")
            self?.showToast(message: "CMP String: \(String(describing: cmpString))")
        }

        addButton("Get Enabled Vendors", color: .systemCyan) { [weak self] in
            let cmpString = self?.cmpManager.getEnabledVendors()
            self?.showToast(message: "CMP String: \(String(describing: cmpString))")
        }

        addButton("Get Disabled Vendors", color: .systemGray) { [weak self] in
            let cmpString = self?.cmpManager.getDisabledVendors()
            self?.showToast(message: "CMP String: \(String(describing: cmpString))")
        }

        addButton("Enable Vendors s2790 and s2791", color: .systemCyan) { [weak self] in
            self?.cmpManager.enableVendorList(["s2790", "s2791"])
            self?.showToast(message: "Vendors s2790 and s279 enabled")
        }

        addButton("Disable Vendors s2790 and s2791", color: .systemRed) { [weak self] in
            self?.cmpManager.disableVendorList(["s2790", "s2791"])
            self?.showToast(message: "Vendors s2790 and s279 disabled")
        }

        addButton("Reject All", color: .systemRed) { [weak self] in
            self?.cmpManager.rejectAll({ self?.showToast(message: "All consents rejected") })
        }

        addButton("Accept All", color: .systemGreen) { [weak self] in
            self?.cmpManager.acceptAll({ self?.showToast(message: "All consents accepted") })
        }

        addButton("Check and Open Consent Layer", color: .systemIndigo) { [weak self] in
            self?.cmpManager.checkAndOpenConsentLayer()
        }

        addButton("Open Consent Layer", color: .systemIndigo) { [weak self] in
            self?.cmpManager.openView()
        }

        addButton("Import CMP String", color: .systemMint) { [weak self] in
            let cmpString = "Q1FERkg3QVFERkg3QUFmR01CSVRCQkVnQUFBQUFBQUFBQWlnQUFBQUFBQUEjXzUxXzUyXzUzXzU0XzU1XzU2XyNfczI3ODlfczI3OTBfczI3OTFfczI2OTdfczk3MV9VXyMxLS0tIw"
            self?.importConsentString(cmpString)
        }
    }
    
    private func importConsentString(_ cmpString: String) {
        Task {
            let (success, error) = await self.cmpManager.importCmpString(cmpString)
            
            await MainActor.run {
                if success {
                    self.showToast(message: "New consent string imported successfully")
                } else {
                    self.showToast(message: "Error: \(error ?? "Unknown error")")
                }
            }
        }
    }

    private func addButton(_ title: String, color: UIColor, action: @escaping () -> Void) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        contentStackView.addArrangedSubview(button)
        
        // Set button height constraint
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
    }
    
    private func showToast(message: String) {
        toastView?.removeFromSuperview()
        
        let toast = UILabel()
        toast.text = message
        toast.textColor = .white
        toast.backgroundColor = .black
        toast.numberOfLines = 0
        toast.textAlignment = .center
        toast.layer.cornerRadius = 10
        toast.clipsToBounds = true
        toast.padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        view.addSubview(toast)
        toast.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toast.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            toast.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
        
        toastView = toast
        
        UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseOut) {
            toast.alpha = 0
        } completion: { _ in
            toast.removeFromSuperview()
            self.toastView = nil
        }
    }
        
    func onClose() -> Void {
        updateStatus("APP Callback - Closed: User closed the CMP")
    }

    func onFinish() -> Void {
        updateStatus("APP Callback - Finish: CMP process completed")
    }

    func onOpen() -> Void {
        updateStatus("APP Callback - Open: CMP opened")
    }

    func onCMPNotOpened() -> Void {
        updateStatus("APP Callback - Not Opened: CMP did not open")
    }

    func onCMPError(type: CmpErrorType, message: String?) -> Void {
        let errorMessage = message ?? "No error message provided"
        let errorTypeDescription: String
        switch type {
        case .networkError:
            errorTypeDescription = "Network Error"
        case .timeoutError:
            errorTypeDescription = "Timeout Error"
        case .consentDataReadWriteError:
            errorTypeDescription = "Consent Data Read/Write Error"
        case .unknownError:
            errorTypeDescription = "Unknown Error"
        @unknown default:
            errorTypeDescription = "Unexpected Error"
        }
        updateStatus("APP Callback - CMP Error: \(errorTypeDescription) - \(errorMessage)")
    }

    func onButtonClickedEvent(event: CmpButtonEvent) -> Void {
        let eventDescription: String
        switch event {
        case .acceptAll:
            eventDescription = "User accepted all options"
        case .rejectAll:
            eventDescription = "User rejected all options"
        case .save:
            eventDescription = "User saved custom settings"
        case .close:
            eventDescription = "User closed consent layer without giving consent"
        case .unknown:
            eventDescription = "Unknown button event encountered"
        @unknown default:
            eventDescription = "An unexpected button event occurred"
        }
        updateStatus("APP Callback - Button Clicked: \(eventDescription)")
    }

    func onClosed() -> Void {
        updateStatus("APP Callback - Closed: CMP closed")
        // add custom business logic here
    }

    func onImport(success: Bool?, message: String?) -> Void {
        let successStatus = success.map(String.init(describing:)) ?? "nil"
        let messageText = message ?? "nil"
        updateStatus("APP Callback - Import: Success: \(successStatus), Message: \(messageText)")
        // add custom business logic here
    }

    // Helper Methods
    private func updateStatus(_ message: String) {
        DispatchQueue.main.async {
            print("\n\(message)")
        }
    }
}

// Extension to add padding to UILabel
extension UILabel {
    var padding: UIEdgeInsets {
        get {
            return UIEdgeInsets.zero
        }
        set {
            let paddingView = UIView()
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(paddingView)
            NSLayoutConstraint.activate([
                paddingView.topAnchor.constraint(equalTo: self.topAnchor, constant: -newValue.top),
                paddingView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: newValue.bottom),
                paddingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -newValue.left),
                paddingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: newValue.right)
            ])
        }
    }
}
