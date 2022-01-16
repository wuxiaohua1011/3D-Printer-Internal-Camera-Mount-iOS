//
//  ViewController.swift
//  HomeMonitor
//
//  Created by Michael Wu on 1/15/22.
//

import UIKit
import MJPEGStreamLib

class ViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var toggleFlashlightBtn: UIButton!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var stream: MJPEGStreamLib!
    
    let defaults = UserDefaults.standard;

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI();
        
    }
    private func setupUI() {
        toggleFlashlightBtn.isHidden = true
        loadingIndicator.isHidden = true
    }
    
    private func setupStream() {
        // Do any additional setup after loading the view.
        stream = MJPEGStreamLib(imageView: imageView)
        
        stream.didStartLoading = { [unowned self] in
            loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
            self.toggleFlashlightBtn.isHidden = true;
            
        }
        
        // Stop Loading Indicator
        stream.didFinishLoading = { [unowned self] in
            self.loadingIndicator.stopAnimating()
            self.toggleFlashlightBtn.isHidden = false;
            self.loadingIndicator.isHidden = true;
        }
    }
    
    @IBAction func onConnectBtnTapped(_ sender: UIButton) {
        if stream != nil {
            stream.stop()
        }
        
        setupStream()
        let url = URL(string:urlTextField.text! + "/cam.mjpeg")
        stream.contentURL = url
        stream.play() // Play the stream
        
    }
    @IBAction func onFlashlightBtnTapped(_ sender: UIButton) {
        let url = URL(string: urlTextField.text! + "/flash")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
        }
        
        if stream != nil {
            stream.stop()
        }

        task.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.stream != nil {
                self.stream.play()
            }
        }

    }
    // Make the Status Bar Light/Dark Content for this View
        override var preferredStatusBarStyle : UIStatusBarStyle {
            return UIStatusBarStyle.lightContent
            //return UIStatusBarStyle.default   // Make dark again
        }

}

