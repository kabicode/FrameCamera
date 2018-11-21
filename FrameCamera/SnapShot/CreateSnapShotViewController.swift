//
//  CreateSnapshotViewContorller.swift
//  PingGuo
//
//  Created by ShenMu on 2017/5/22.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation
import OpenGLES

class CreateSnapShotViewController: BaseViewController {
    
    enum SnapshotMode {
        case createAssetMode
        case singleSnapshotMode
        case guideMode
    }
    
    var asset: PGAsset!
    
    // single shot Mode
    var snapshotMode: SnapshotMode = .createAssetMode
//    var isSingleShotMode: Bool = false
    var singleShotBlock: ((UIImage) -> ())? = nil
    
    //负责输入和输出设备之间的数据传递
    var mCaptureSession: AVCaptureSession?
    //负责从AVCaptureDevice获得输入数据
    var mCaptureDeviceInput: AVCaptureDeviceInput?
 
    var mCaptureDeviceOutput: AVCaptureVideoDataOutput?
    var stillImageOutput: AVCaptureStillImageOutput?
    // OpenGL ES
    var mGLView: LYOpenGLView!
    
    var mProcessQueue: DispatchQueue!
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    lazy var griddingView: UIView = self.loadGriddingView();
    
    @IBOutlet var doublePhotoImageView: UIImageView!
    
    @IBOutlet var topBarBgView: UIView!
    @IBOutlet var nextStepButton: UIButton!
    @IBOutlet var barBackButton: UIButton!
    
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var settingButton: UIButton!
    @IBOutlet var photoLibraryButton: UIButton!
    
    @IBOutlet var settingBoardView: UIView!
    @IBOutlet weak var greenCropSwith: UISwitch!
    @IBOutlet weak var doubleImageSwitch: UISwitch!
    @IBOutlet weak var gridSwitch: UISwitch!
    
    var greenCropEnable: Bool = false
    var doubleImageEnable: Bool = false
    var griddingEnable: Bool = false
    
    var bgImage: CropBgImage?
    
    var dismissBlock: (()->())?
    
    // MARK: - Rotate
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeOrientation(to: .landscapeRight)
        
        if let mCaptureSession = self.mCaptureSession {
            mCaptureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let mCaptureSession = self.mCaptureSession {
            mCaptureSession.stopRunning()
        }
    }
    
    // MARK: - Life Cycle
    static func presentFrom(_ viewController: UIViewController, with asset: PGAsset) -> CreateSnapShotViewController {
        let vc = CreateSnapShotViewController()
        vc.asset = asset
        
        let nav = BaseNavigationController.init(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        viewController.present(nav, animated: true, completion: nil)
        
        return vc
    }
    
    init() {
        super.init(nibName: "CreateSnapShotViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    override func viewDidLoad() {
        
        configureCamera()
        
        defaultSetting()
        
        setupSubviews()
    }
    
    // MARK: - UI Config
    func setupSubviews() {
        nextStepButton.isHidden = true
        view.backgroundColor = UIColor.white
        
        view.addSubview(griddingView)
        view.insertSubview(griddingView, belowSubview: topBarBgView)
        griddingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        configurePreviewLayer()
        configureDoubleImageView()
        congfigureGriddingView()
    }
    
    func defaultSetting() {
        greenCropEnable = PGUserDefault.greenCropEnable
        doubleImageEnable = PGUserDefault.doubleImageEnable
        griddingEnable = PGUserDefault.griddingEnable
        
        greenCropSwith.isOn = greenCropEnable
        doubleImageSwitch.isOn = doubleImageEnable
        gridSwitch.isOn = griddingEnable
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(focesCamera))
        view.addGestureRecognizer(tap)
    }
    
    func loadGriddingView() -> UIView {
        let griddingView = UIView()
        let count = 2
        let lineColor = UIColor(hex: 0xC5C5C7)
        
        for i in 0..<count {
            let rowLine = UIView()
            rowLine.backgroundColor = lineColor
            griddingView.addSubview(rowLine)
            rowLine.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(CGFloat(i + 1) * UIScreen.main.bounds.height/CGFloat(count + 1))
                make.height.equalTo(0.5)
            })
            
            let colLine = UIView()
            colLine.backgroundColor = lineColor
            griddingView.addSubview(colLine)
            colLine.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(CGFloat(i + 1) * UIScreen.main.bounds.width/CGFloat(count + 1))
                make.width.equalTo(0.5)
            })
        }
        
        return griddingView;
    }

    
    
    // MARK: - Event Method
    
    @IBAction func tapBarBackButton(_ sender: Any) {
        if let nav = navigationController {
            nav.dismiss(animated: true, completion: nil)
            return
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBarNextSetpButton(_ sender: Any) {
        guard self.snapshotMode != .singleSnapshotMode, asset.imageList.count > 0 else {
            showMessageNotifiaction("暂无照片，请拍摄后再点击下一步继续操作。", on: self)
            return
        }
        
        if let nav = navigationController {
            nav.dismiss(animated: true, completion: dismissBlock)
            return
        }
        
        dismiss(animated: true, completion: dismissBlock)
    }
    
    @IBAction func tapPhotoLibraryButton(_ sender: Any) {
        let vc = CropImagePickViewController()
        vc.selectedImage = bgImage
        vc.selectedImageBlock = { [weak self] (selectedImage) in
            self?.bgImage = selectedImage
            if let view = self?.view as? LYOpenGLView, let image = selectedImage?.image {
                view.setBgCropImage(image)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapSettingBoardButton(_ sender: Any) {
        showSettingBoardView(true)
    }
    
    @IBAction func tapCameraButton(_ sender: Any) {
        cameraButton.isEnabled = false;
        captureImage {[weak self] (image, error) in
            guard let strongSelf = self,
                  let image = image else {
                    self?.cameraButton.isEnabled = true
                    return
            }
            
            switch strongSelf.snapshotMode {
            case .createAssetMode:
                strongSelf.nextStepButton.isHidden = false
                let _ = strongSelf.asset.add(image)
                strongSelf.doublePhotoImageView.image = image
                break;
                
            case .singleSnapshotMode:
                strongSelf.tapBarBackButton(strongSelf.barBackButton)
                strongSelf.singleShotBlock?(image)
                break;
                
            case .guideMode:
                // TODO
                break;
            }
            
            
            strongSelf.cameraButton.isEnabled = true;
        }
    }
    
    @IBAction func touchSettingBoardBg(_ sender: Any) {
        showSettingBoardView(false)
    }
    
    @IBAction func tapChangeBgSwitch(_ sender: UISwitch) {
        greenCropEnable = sender.isOn
        PGUserDefault.greenCropEnable = greenCropEnable
        
        configurePreviewLayer()
    }
    
    @IBAction func tapDoubleImageSwitch(_ sender: UISwitch) {
        doubleImageEnable = sender.isOn
        PGUserDefault.doubleImageEnable = doubleImageEnable
        
        configureDoubleImageView()
    }
    
    @IBAction func tapGriddingSwitch(_ sender: UISwitch) {
        griddingEnable = sender.isOn
        PGUserDefault.griddingEnable = griddingEnable
        
        congfigureGriddingView()
    }
    
    
    // MARK: - Private Method
    func showSettingBoardView(_ show: Bool) {
        if settingBoardView.superview == nil {
            view.addSubview(settingBoardView)
            settingBoardView.alpha = 0.0;
            settingBoardView.frame = view.bounds;
        }
        
        let toAlpha: CGFloat = show ? 1.0: 0.0
        UIView.animate(withDuration: 0.35) {
            self.settingBoardView.alpha = toAlpha
        }
    }
    
    func congfigureGriddingView() {
        griddingView.isHidden = !griddingEnable
    }
    
    func configureDoubleImageView() {
        doublePhotoImageView.image = nil
        doublePhotoImageView.isHidden = !doubleImageEnable
        if doubleImageEnable {
            doublePhotoImageView.alpha = 0.2
        }
    }
    
    func configurePreviewLayer() {
        if greenCropEnable {
            if let previewLayer = self.previewLayer {
                previewLayer.removeFromSuperlayer()
                self.previewLayer = nil
            }
        } else {
            if previewLayer == nil {
                if let previewLayer = AVCaptureVideoPreviewLayer(session: mCaptureSession) {
                    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    previewLayer.frame = self.view.bounds
                    previewLayer.connection.videoOrientation = .landscapeRight
                    self.view.layer.insertSublayer(previewLayer, at: 0)
                    self.previewLayer = previewLayer
                }
            }
        }
    }
}
