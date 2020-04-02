//
//  ViewController1.swift
//  TestLaunch
//
//  Created by Rudolf Farkas on 31.03.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {
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
        performSegue(withIdentifier: "toVC2", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        printClassAndFunc()
        if segue.identifier == "toVC2" {
            if let destinationVC = segue.destination as? ViewController2 {
                // disables the iOS 13 presentation and sweep to dismiss
                // see https://developer.apple.com/videos/play/wwdc2019/224/ from 13:30 of 50:21
                // destinationVC.modalPresentationStyle = .fullScreen
                destinationVC.view.backgroundColor = UIColor.green.withAlphaComponent(0.7)
            }
        }
    }

    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        printClassAndFunc()
        activateNetworkStatus()
    }
}
