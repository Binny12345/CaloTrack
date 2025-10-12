//
//  BarcodeViewController.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 20/9/2025.
//

import AVFoundation
import UIKit
import SwiftUI

/// Required to manage the scanned barcodes and fetch food item accordingly
final class BarcodeViewModel: UIViewController {
    
    // Captures the barcode
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: BarcodeViewModelDelegate?
    
    // initialises the delegate, so as to not need to forcefully unwrap
    init(scannerDelegate: BarcodeViewModelDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    /// Redid the viewDidLoad( ) func to add setupCaptureSession( )
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    /// Redid the viewDidLayoutSubviews( ) func to set previewLayer to my frame set in my BarcodeView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    /// Sets up the camera session for the user to start scanning
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        // Sets video input to capture video input
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        // Sets what is actually getting scanned
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.global())
            
            // Sets what barcodes can be scanned and accepted
            metaDataOutput.metadataObjectTypes = [.ean13, .ean8, .upce]
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        // Preview Layer for testing
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        // Starts running the capture session
        captureSession.startRunning()
    }
}

/// Extend upon the BarcodeVC to manage the scanned value
extension BarcodeViewModel: AVCaptureMetadataOutputObjectsDelegate {
    
    /// Captures the scanned Value
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Checks if meta object is in the array
        guard let object = metadataObjects.first else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        // Sets machine readable as a string
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        // grabs the barcode from the string value
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        scannerDelegate?.didFind(barcode: barcode)  // Sends it back to the Delegate
    }
}

/// A SwiftUI wrapper for a UIKit barcode scanner.
/// Conforms to `UIViewControllerRepresentable` so to integrate UIKit in SwiftUI.
struct ScannerView: UIViewControllerRepresentable {
    
    // Bindings let this view communicate back to the parent SwiftUI view (BarcodeView).
    @Binding var scannedBarcode: String
    @Binding var alertItem: AlertItem?
    
    
    /// Creates the UIKit view controller (in`BarcodeViewModel`) that does the scanning.
    /// - Parameter context: gives us access to the Coordinator (delegate handler).
    /// - Returns: Instance of BarcodeViewModel which includes the context
    func makeUIViewController(context: Context) -> BarcodeViewModel {
        BarcodeViewModel(scannerDelegate: context.coordinator)
    }
    
    /// Called whenever SwiftUI updates the view (e.g., when bindings change).
    /// - In this case, no need to do anything since the scanner runs independently.
    func updateUIViewController(_ uiViewController: BarcodeViewModel, context: Context) {}
    
    
    /// Creates a Coordinator, which acts as the middleman between
    /// the UIKit `BarcodeViewModel` delegate and SwiftUI bindings.
    /// - Returns: The coordinator and scannerView
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
    
    /// Coordinator class that conforms to `BarcodeViewModelDelegate`, Handles scanned results and errors.
    final class Coordinator: NSObject, BarcodeViewModelDelegate {
        
        private let scannerView: ScannerView  // Reference to parent SwiftUI view
        
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        /// Called by BarcodeViewModel when a barcode is successfully detected.
        /// - Parameter barcode: String that was grabbed from AVCapture
        func didFind(barcode: String) {
            // Update the SwiftUI binding, so parent view (BarcodeView) reacts to change.
            scannerView.scannedBarcode = barcode
        }
        
        /// Called by BarcodeViewModel when an error occurs.
        /// - Parameter error: Specific error relating to what occured
        func didSurface(error: CameraError) {
            // sets the low-level CameraError into high-level user-facing alerts.
            switch error {
            case .invalidDeviceInput:
                scannerView.alertItem = AlertContext.invalidDeviceInput
            case .invalidScannedValue:
                scannerView.alertItem = AlertContext.invalidScannedValue
            }
        }
    }
}

/// Error enum for organising the different error states
enum CameraError: String {
    /// When there is an issue with the Device
    case invalidDeviceInput
    
    /// When the value that was scanned doesn't match the accepted formats
    case invalidScannedValue
}

/// Protocol for setting quick functions for if a barcode/error is found
protocol BarcodeViewModelDelegate: AnyObject {
    func didFind(barcode: String)
    func didSurface(error: CameraError)
}

/// Helper struct which organises the alert
struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}

/// Helper struct which sets each error Alert
struct AlertContext {
    static let invalidDeviceInput = AlertItem(
        title: "Invalid Device Input",
        message: "Issue with camera: We are unable to capture the input.",
        dismissButton: .default(Text("Ok"))
    )
    
    static let invalidScannedValue = AlertItem(
        title: "Invalid Scanned Value",
        message: "The value scanned is not valid. This app scans EAN-13, EAN-8 and UPC-E.",
        dismissButton: .default(Text("Ok"))
    )
}

