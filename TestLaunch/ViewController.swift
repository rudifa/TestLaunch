//
//  ViewController.swift
//  TestLaunch
//
//  Created by Rudolf Farkas on 31.03.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var connectedLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        // backgroundColor = .systemBlue // uncomment for visual debugging
        label.font = .preferredFont(forTextStyle: UIFont.TextStyle.title3)
        label.text = "unknown"
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()

    lazy var testConnectionButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        // backgroundColor = .gray // uncomment for visual debugging
        button.titleLabel?.font = .preferredFont(forTextStyle: UIFont.TextStyle.title3)
        button.setTitle("test connection", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(testConnectionButtonTap), for: .touchUpInside)
        return button
    }()

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

        NetworkMonitor.shared.callback = { isConnected in
            DispatchQueue.main.async {
                self.connectedLabel.text = isConnected ? "connected" : "disconnected"
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printClassAndFunc()
    }
}
