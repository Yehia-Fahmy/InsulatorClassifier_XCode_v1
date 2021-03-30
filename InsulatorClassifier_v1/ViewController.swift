//
//  ViewController.swift
//  InsulatorClassifier_v1
//
//  Created by Yehia Fahmy on 2021-03-22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var centerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Insulator Classifier"
    }

    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        print("camera button tapped")
    }
    
}

