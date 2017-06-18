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
    
    //负责输入和输出设备之间的数据传递
    var mCaptureSession: AVCaptureSession!
    //负责从AVCaptureDevice获得输入数据
    var mCaptureDeviceInput: AVCaptureDeviceInput!
 
    var mCaptureDeviceOutput: AVCaptureVideoDataOutput!
    // OpenGL ES
    var mGLView: LYOpenGLView!
    
    var mProcessQueue: DispatchQueue!
    
    
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
    
    private var greenCropEnable: Bool = false
    private var doubleImageEnable: Bool = false
    private var griddingEnable: Bool = false
    
    
    // MARK: - Rotate
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeOrientation(to: .landscapeLeft)
    }
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: "CreateSnapShotViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureCamera()
        
        setupSubviews()

        defaultSetting()
    }
    
    func tapGesture() {
        self.navigationController?.pushViewController(UIViewController(), animated: true)
    }
    
    
    // MARK: - Event Method
    
    @IBAction func tapBarBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBarNextSetpButton(_ sender: Any) {
        // TODO
    }
    
    @IBAction func tapPhotoLibraryButton(_ sender: Any) {
        // TODO
    }
    
    @IBAction func tapSettingBoardButton(_ sender: Any) {
        showSettingBoardView(true)
    }
    
    @IBAction func tapCameraButton(_ sender: Any) {
        // TODO
    }
    
    @IBAction func touchSettingBoardBg(_ sender: Any) {
        showSettingBoardView(false)
    }
    
    @IBAction func tapChangeBgSwitch(_ sender: UISwitch) {
        // TODO
    }
    
    @IBAction func tapDoubleImageSwitch(_ sender: UISwitch) {
        doubleImageEnable = sender.isOn
        
        configureDoubleImageView()
    }
    
    @IBAction func tapGriddingSwitch(_ sender: UISwitch) {
        griddingEnable = sender.isOn
        
        congfigureGriddingView()
        
    }
    
    // MARK: - UI Config
    func setupSubviews() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(griddingView)
        view.insertSubview(griddingView, belowSubview: topBarBgView)
        griddingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func defaultSetting() {
        
        
        
        congfigureGriddingView()
    }
    
    func loadGriddingView() -> UIView {
        let griddingView = UIView()
        let count = 2
        let lineColor = UIColor.black
        
        for i in 0..<count {
            let rowLine = UIView()
            rowLine.backgroundColor = lineColor
            griddingView.addSubview(rowLine)
            rowLine.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(CGFloat(i + 1) * UIScreen.main.bounds.width/CGFloat(count + 1))
                make.height.equalTo(0.5)
            })
            
            let colLine = UIView()
            colLine.backgroundColor = lineColor
            griddingView.addSubview(colLine)
            colLine.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(CGFloat(i + 1) * UIScreen.main.bounds.height/CGFloat(count + 1))
                make.width.equalTo(0.5)
            })
        }
        
        return griddingView;
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
}
