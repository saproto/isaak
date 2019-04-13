//
//  OmnomcomQRViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 09/04/2019.
//  Copyright © 2019 S.A. Proto. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class OmnomcomQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var previewView: UIView!
    
    var captureSession: AVCaptureSession?   //initialize a capturesession
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? //initialize the previewlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        let videoCaptureDevice = AVCaptureDevice.default(for: .video) //define which device is to be used for the videocapture
        let videoInput: AVCaptureDeviceInput //initialize videoInput as a capturedevice
        do{videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice!)} //put the output from the capturedevice into the videoinput
        catch{return}
        captureSession?.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(metadataOutput)//add an output for the metadata triggering
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr] //trigger on QR codes in Metadata
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!) //put the videocapture in the previewlayer
        videoPreviewLayer?.frame = view.layer.bounds
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill //define the way the previewlayer resizes
        previewView.layer.addSublayer(videoPreviewLayer!) //put the previewlayer into the view
        
        captureSession?.startRunning() //start capturing
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            DispatchQueue.main.async {
                self.found(code: stringValue)
            }
        }
        return
    }
    
    func found(code: String){
        let l = OAuth.baseURL.count + 3
        
        if code.prefix(l) == (OAuth.baseURL + "/qr") {
            print(code.suffix(8))
            let omnomCode = code.suffix(8)
            
            let infoReq = Alamofire.request(OAuth.omnomQRInfo + omnomCode,
                                            method: .get,
                                            parameters: [:],
                                            encoding: URLEncoding.methodDependent,
                                            headers: OAuth.headers)
            
            infoReq.responseQrInfo{ response in
                
                print(response)
                let resp = response.result.value!
                let message = resp.description!.replacingOccurrences(of: "&euro; ", with: "€")
                
                let controller = UIAlertController(title: "Do you want to confirm?", message: message, preferredStyle: .alert)
                let Yes = UIAlertAction(title: "Confirm", style: .default, handler: {(alert: UIAlertAction!) in self.performPayment(code: String(omnomCode))})
                let No = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)})
                
                controller.addAction(No)
                controller.addAction(Yes)
                
                self.present(controller, animated: true, completion: nil)
            }
            
            
        }else{
            let controller = UIAlertController(title: "Failed!", message: "The code you scanned is not an OmNomCom purchase QR code.", preferredStyle: .alert)
            let Ok = UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in
                if (self.captureSession?.isRunning == false) {
                    self.captureSession?.startRunning()
                }
            })
            
            controller.addAction(Ok)
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession?.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession?.stopRunning()
        }
    }
    
    func performPayment(code: String){
        let payRequest = Alamofire.request(OAuth.omnomQR + code,
                                           method: .get,
                                           parameters: [:],
                                           encoding: URLEncoding.methodDependent,
                                           headers: OAuth.headers)
        payRequest.validate(statusCode: 200..<300).responseData{ response in
            switch response.result{
            case .success:
                self.dismiss(animated: true, completion: nil)
            case .failure:
                let controller = UIAlertController(title: "Failed!", message: "The payment failed, please try again.", preferredStyle: .alert)
                let Yes = UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)})
                
                controller.addAction(Yes)
                
                self.present(controller, animated: true, completion: nil)
            }
            
        }
        
    }
    
    @IBAction func BackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
