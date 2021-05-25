//
//  APODViewController.swift
//  NASA-Apod
//
//  Created by Saurav Kedia on 26/05/21.
//

import UIKit
import WebKit

class APODViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    private var viewModel: APODViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //fetchAPODInfo()
        initViewModel()
    }
    
    func initViewModel() {
        self.viewModel = APODViewModel()
        self.viewModel.bindApodModelToView = {
            self.updateAPODInfoOnView()
        }
        self.viewModel.bindErrorToView = {
            DispatchQueue.main.async {
                self.alert(title: "", message: "We are not connected to the internet")
            }
        }
        self.viewModel.getAPODInfo()
    }
    
    func updateAPODInfoOnView() {
        DispatchQueue.main.async {
            if self.viewModel.isDisplayingOldInfo {
                self.alert(title: "", message: "We are not connected to the internet, showing you the last image we have")
            }
            if self.viewModel.apodInfo.media_type == .Image {
                self.webview.isHidden = true
                self.imageView.isHidden = false
                if let mediaContent = self.viewModel.apodInfo.mediaContent, let img = UIImage(data: mediaContent) {
                    self.imageView.image = img
                }else if let mediaPath = self.viewModel.apodInfo.url, let url = URL(string: mediaPath) {
                    DispatchQueue.global(qos: .default).async {
                        if let imageData = try? Data(contentsOf: url){
                            let image = UIImage(data: imageData, scale: 1)
                            DispatchQueue.main.async {
                                self.imageView.image = image
                            }
                        }
                    }
                }
            }else{
                self.webview.isHidden = false
                self.imageView.isHidden = true
                if let mediaPath = self.viewModel.apodInfo.url, let url = URL(string: mediaPath) {
                    self.webview.load(URLRequest(url: url))
                }
            }
            self.titleLabel.text = self.viewModel.apodInfo.title
            self.descriptionTextView.text = self.viewModel.apodInfo.explanation
        }
    }
    
    func alert(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
