//
//  ViewController.swift
//  InsulatorClassifier_v1
//
//  Created by Yehia Fahmy on 2021-03-22.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    // create the object
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Insulator Classifier"
        // image picker initialization
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
    }
    // when the camera button is tapped
    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        // change the image source first
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    // when the photo button is tapped
    @IBAction func photoButtonTapped(_ sender: UIBarButtonItem) {
        // change the image source first
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // function to be called every time the image picker is used
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // if an image was picked
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = userPickedImage
            // convert the image to CIImage
            guard let ciimage = CIImage(image: userPickedImage) else {fatalError("could not conver the image to ciimage")}
            // make the inference
            let inference = makeInference(image: ciimage)
            classificationLabel.text = inference
        }
        
        // we are done
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func makeInference(image: CIImage) -> String {
        var resultString = "unknown"
        // load the model
        guard let model = try? VNCoreMLModel(for: InsulatorClassifier3().model) else {fatalError("model could not be loaded")}
        
        // define our request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results?.first as? VNClassificationObservation else {fatalError("could not process requests")}
            // setting the result
            resultString = result.identifier
        }
        
        // define the handler
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try! handler.perform([request])
        } catch  {
            print("an error with the handler")
        }
        
        return resultString
    }
    
}

