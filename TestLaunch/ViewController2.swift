//
//  ViewController2.swift
//  TestLaunch
//
//  Created by Rudolf Farkas on 31.03.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    private lazy var connectedLabel = UILabel.configuredLabel(text: "unknown")

    private lazy var testConnectionButton = UIButton.actionButton(title: "test connection", action: testConnectionButtonTap)

    @objc func testConnectionButtonTap(sender: Any) {
        let title = "Network is"
        let message = NetworkMonitor.shared.connected ? "connected" : "disconnected"
        presentAlert(title: title, message: message)
    }

    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in print("OK") }))
        present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        printClassAndFunc()
        view.backgroundColor = UIColor.red.withAlphaComponent(0.7)

        view.addSubview(connectedLabel)
        view.addSubview(testConnectionButton)

        NSLayoutConstraint.activate([
            connectedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            connectedLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            testConnectionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            testConnectionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
        ])

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        activateNetworkStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printClassAndFunc()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printClassAndFunc()
    }

    deinit {
        printClassAndFunc()
    }

    private func activateNetworkStatus() {
        NetworkMonitor.shared.handler = { [weak self] isConnected in
            DispatchQueue.main.async {
                self?.connectedLabel.text = isConnected ? "connected" : "disconnected"
            }
        }
    }

    @objc func handleTap() {
        printClassAndFunc()
        performSegue(withIdentifier: "unwindToVC", sender: self)
    }
}
