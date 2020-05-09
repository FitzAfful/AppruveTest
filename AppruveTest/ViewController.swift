//
//  ViewController.swift
//  AppruveTest
//
//  Created by Fitzgerald Afful on 09/05/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var chooseImageBtn: UIButton!
    let picker = UIImagePickerController()
    let manager = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }

    @IBAction func chooseImageAction(_ sender: Any) {
        self.chooseOptions()
    }

    func uploadImage(data: Data) {
        manager.uploadImage(data, userId: "2000") { (result) in
            if let response = try? result.get() {
                if response == "1" {
                    self.showAlert(withTitle: "Successful", message: "Image Upload Successful")
                }
            }else {
                self.showAlert(withTitle: "Error", message: NetworkConstants().getErrorMessage(response: result))
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.80) {
                self.uploadImage(data: imageData)
            }
        }
    }

    func imagePickerControllerDidCancel (_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func noCamera () {
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)

    }

    func photoFromLibrary () {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

    func shootPhoto () {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }

    func chooseOptions() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Take Picture", style: UIAlertAction.Style.default, handler: {  (_) in
            self.shootPhoto()
        }))
        alert.addAction(UIAlertAction(title: "Choose Existing Picture", style: UIAlertAction.Style.default, handler: {  (_) in
            self.photoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {  (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
