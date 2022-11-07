//
//  QRCodeTool.swift
//  QRCoder
//
//  Created by link on 2022/3/29.

import AVFoundation
import UIKit

typealias ScanResult = ([String]) -> ()

class QRCodeTool: NSObject {
    static let shareInstance = QRCodeTool()
    
    fileprivate lazy var input: AVCaptureDeviceInput? = {
        let deviceSession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: .video, position: .back)
        
        let backDevice = deviceSession.devices[0]
        
        let input = try? AVCaptureDeviceInput(device: deviceSession.devices[0])
        return input
    }()
    
    fileprivate lazy var output: AVCaptureMetadataOutput = {
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        return output
    }()
    
    fileprivate lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        return session
    }()
    
    fileprivate lazy var preLayer: AVCaptureVideoPreviewLayer? = {
        let preLayer = AVCaptureVideoPreviewLayer(session: self.session)
        preLayer.videoGravity = .resizeAspectFill
        return preLayer
    }()
    
    private var isDrawFrame: Bool = false
    
    private var resultBlock: ScanResult?
}

// MARK: - Turn on the camera to scan QR codes

extension QRCodeTool {
    public func scanQRCode(inView: UIView, isDrawFrame: Bool = false, resultBlock: ScanResult?) {
        self.resultBlock = resultBlock
        
        self.isDrawFrame = isDrawFrame
        
        if let input = input {
            if session.canAddInput(input), session.canAddOutput(output) {
                session.addInput(input)
                session.addOutput(output)
            }
        }
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        preLayer!.frame = UIScreen.main.bounds
        inView.layer.insertSublayer(preLayer!, at: 0)
        
        session.startRunning()
    }
    
    public func stopScan() {
        session.stopRunning()
    }
}

// MARK: - Set the scan area

extension QRCodeTool {
    private func setScanRect(scanRect: CGRect) {
        let screenSize = UIScreen.main.bounds.size
        let xR = scanRect.origin.x / screenSize.width
        let yR = scanRect.origin.y / screenSize.height
        let wR = scanRect.size.width / screenSize.width
        let hR = scanRect.size.height / screenSize.height
        output.rectOfInterest = CGRect(x: yR, y: xR, width: hR, height: wR)
    }
}

// MARK: - Flash switch

extension QRCodeTool {
    public func setTorch(isOn: Bool) {
        let device = input?.device
        if device?.hasTorch ?? false {
            try? device?.lockForConfiguration()
            
            device?.torchMode = isOn ? .on : .off
            
            device?.unlockForConfiguration()
        }
    }
}

extension QRCodeTool {
    public func createQRCode(input: String, scale: CGPoint = CGPoint(x: 30, y: 30), middleImage: UIImage? = nil) -> UIImage {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setDefaults()
        
        let data = input.data(using: String.Encoding.utf8)
        
        filter?.setValue(data, forKeyPath: "inputMessage")
        
        filter?.setValue("H", forKeyPath: "inputCorrectionLevel")
        
        let outImage = filter?.outputImage
        
        let resImage = outImage?.transformed(by: CGAffineTransform(scaleX: scale.x, y: scale.y))
        let image = UIImage(ciImage: resImage!)
        
        guard middleImage != nil else {
            return image
        }
        return addMiddleImage(image: middleImage!, toBackImage: image)
    }
    
    public func detectorQRCode(qrImage: UIImage) -> (resultStrs: [String], resultImg: UIImage) {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        let ciImage = CIImage(image: qrImage)
        guard let features = detector?.features(in: ciImage!) else {
            return ([], qrImage)
        }
        
        var resultImg = qrImage
        var resultStrs = [String]()
        for feature in features as! [CIQRCodeFeature] {
            resultStrs.append(feature.messageString!)
            
            resultImg = drawFrame(feature: feature, image: resultImg)
        }
        return (resultStrs, resultImg)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRCodeTool: AVCaptureMetadataOutputObjectsDelegate {
    internal func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if isDrawFrame {
            removeQRCodeFrame(layer: preLayer!)
        }
        
        var resultStrs = [String]()
        
        for metadataObject in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            if isDrawFrame {
                drawQRCodeFrame(metadataObject: metadataObject, layer: preLayer!)
            }
            resultStrs.append(metadataObject.stringValue ?? "")
        }
        
        resultBlock?(resultStrs)
    }
}

private extension QRCodeTool {
    private func addMiddleImage(image: UIImage, toBackImage: UIImage) -> UIImage {
        let size: CGSize = toBackImage.size
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        
        toBackImage.draw(in: CGRect(x: 0, y: 0, width: size
                .width, height: size.height))
        let w = size.width * 0.2
        let h = size.height * 0.2
        let x = (size.width - w) * 0.5
        let y = (size.height - h) * 0.5
        
        if let whiteImage = UIImage(color: UIColor.white, size: CGSize(width: w, height: h))?.withRoundedCorners() {
            whiteImage.draw(in: CGRect(x: x, y: y, width: w, height: h))
        }
        
        let imageW = size.width * 0.18
        let imageH = size.height * 0.18
        let imageX = (size.width - imageW) * 0.5
        let imageY = (size.height - imageH) * 0.5
        
        image.draw(in: CGRect(x: imageX, y: imageY, width: imageW, height: imageH))
    
        let curImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        guard curImage != nil else {
            return toBackImage
        }
        return curImage!
    }
    
    private func drawFrame(feature: CIQRCodeFeature, image: UIImage) -> UIImage {
        let size = image.size
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -size.height)
        
        UIColor.red.setStroke()
        let bounds = feature.bounds
        let path = UIBezierPath(rect: bounds)
        path.lineWidth = 10
        path.stroke()
        
        let curImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        
        UIGraphicsEndImageContext()
        
        return curImage
    }
    
    private func removeQRCodeFrame(layer: AVCaptureVideoPreviewLayer) {
        if let layers = layer.sublayers {
            for layer in layers {
                if layer.isKind(of: CAShapeLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    private func drawQRCodeFrame(metadataObject: AVMetadataMachineReadableCodeObject, layer: AVCaptureVideoPreviewLayer) {
        guard let qrObj = layer.transformedMetadataObject(for: metadataObject) as? AVMetadataMachineReadableCodeObject else { return }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 6
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        let path = UIBezierPath()
        
        let pointArray = qrObj.corners
        for (index, point) in pointArray.enumerated() {
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        path.close()
        shapeLayer.path = path.cgPath
        
        layer.addSublayer(shapeLayer)
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    // image with rounded corners
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0, radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
