//
//  ViewController.swift
//  here-marker-demo
//
//  Created by Yachin Ilya on 30/05/2019.
//  Copyright © 2019 Yachin Ilya. All rights reserved.
//

import UIKit
import NMAKit

class ViewController: UIViewController {
    private let idField = UITextField()
    private let codeField = UITextField()
    private let setCredsButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        idField.placeholder = "HERE id"
        codeField.placeholder = "HERE code"
        setCredsButton.setTitle("Confirm", for: .normal)
        setCredsButton.backgroundColor = .magenta
        
        idField.textAlignment = .center
        codeField.textAlignment = .center
        
        idField.translatesAutoresizingMaskIntoConstraints = false
        codeField.translatesAutoresizingMaskIntoConstraints = false
        setCredsButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(idField)
        view.addSubview(codeField)
        view.addSubview(setCredsButton)
        
        NSLayoutConstraint(item: idField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 70).isActive = true
        NSLayoutConstraint(item: idField, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: -40).isActive = true
        NSLayoutConstraint(item: idField, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: codeField, attribute: .top, relatedBy: .equal, toItem: idField, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: codeField, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: -40).isActive = true
        NSLayoutConstraint(item: codeField, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: setCredsButton, attribute: .top, relatedBy: .equal, toItem: codeField, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: setCredsButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: -40).isActive = true
        NSLayoutConstraint(item: setCredsButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        setCredsButton.addTarget(self, action: #selector(openMapViewScreen), for: .touchUpInside)
        
    }


    private func setHereCredentials(id hereAppId: String, code hereAppCode: String) {
        NMAApplicationContext.set(appId: hereAppId, appCode: hereAppCode)
    }
    
    @objc
    func openMapViewScreen() {
        guard let id = idField.text, let code = codeField.text, !id.isEmpty, !code.isEmpty else { return }
        setHereCredentials(id: id, code: code)
        let vc = MapViewController()
        self.present(vc, animated: true, completion: nil)
    }
}

