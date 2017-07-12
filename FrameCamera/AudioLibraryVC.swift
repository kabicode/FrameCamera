//
//  AudioLibraryVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/13.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
import MJRefresh

class AudioLibraryVC: BaseViewController {

    enum AudioLibrarySelectType {
        case localAudio
        case onlineAudio
    }
    
    @IBOutlet weak var myMusicBtn: UIButton!
    @IBOutlet weak var onlineMusicBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

    
    var asset: PGAsset!
    var audioLibraryType: AudioLibrarySelectType = .localAudio
    
    var localAudioList: [String] = []
    var recordAudioList: [String] = []
    var onlineAudioList: [String] = []
    
    var selectedAudioPath: String?
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: "AudioLibraryVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedAudioPath = asset.audioPath
        
        registerCells()
        
        setupSubviews()
        
        configureSubviews()
        
        tableView.tableFooterView = UIView()
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "AudioFileCell", bundle: nil), forCellReuseIdentifier: "AudioFileCell")
        tableView.register(AudioLibrarySectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "AudioLibrarySectionHeaderView")
    }
    
    func setupSubviews() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.reloadData()
        })
    }

    func configureSubviews() {
        if audioLibraryType == .localAudio {
            myMusicBtn.isSelected = true
            onlineMusicBtn.isSelected = false
            myMusicBtn.backgroundColor = UIColor(hex: 0x1A212B)
            onlineMusicBtn.backgroundColor = UIColor(hex: 0x1E2733)
        } else {
            myMusicBtn.isSelected = false
            onlineMusicBtn.isSelected = true
            myMusicBtn.backgroundColor = UIColor(hex: 0x1E2733)
            onlineMusicBtn.backgroundColor = UIColor(hex: 0x1A212B)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func tapMyMusicBtn(_ sender: Any) {
        audioLibraryType = .localAudio
        
        configureSubviews()
    }
    
    @IBAction func tapOnlineMusicBtn(_ sender: Any) {
        audioLibraryType = .onlineAudio
        
        configureSubviews()
    }
    
    // MARK: - Private Method
    func reloadData() {
        getOnlineAudioList()
        getLocalAudioList()
        getRecordAudioList()
        
        tableView.reloadData()
        tableView.mj_header.endRefreshing()
    }
    
    func getLocalAudioList() {
        let list = PGAudioFileHelper.getLocalAudioFolderContentFiles()
        localAudioList.removeAll()
        
        for (_, name) in list.enumerated() {
            let filePath = PGAudioFileHelper.getLocalAudiosFolderPath() + "/" + name
            recordAudioList.append(filePath)
        }
        print("localList -- \(localAudioList)")
    }
    
    func getRecordAudioList() {
        let list = PGAudioFileHelper.getRecordAudioFolderContentFiles()
        recordAudioList.removeAll()
        
        for (_, name) in list.enumerated() {
            let filePath = PGAudioFileHelper.getRecordAudiosFolderPath() + "/" + name
            recordAudioList.append(filePath)
        }
        print("recordList -- \(recordAudioList)")
    }
    
    func getOnlineAudioList() {
        
    }
    
    func downLoadAudio(with urlString:String) {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "下载中..."
        
        let filePath = PGAudioFileHelper.getFileNameFromURL(urlString)
        MBProgressHUD.showAdded(to: view, animated: true)
        if !PGAudioFileHelper.audioFileExists(filePath) {
            PGAudioFileHelper.downloadAudio(urlString, compelete: { [weak self, weak hud] success in
                hud?.hide(animated: true)
                // TODO
                if success {
                    showMessageNotifiaction("下载音频成功", type: .success, on: self)
                } else {
                    showMessageNotifiaction("下载音频失败", on: self)
                }
            })
        }
    }
    
    // MARK: - Getter
    var sectionTitles: [String] {
        return ["录音", "已下载"]
    }
}

extension AudioLibraryVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if audioLibraryType == .localAudio {
            return 2;
        } else if audioLibraryType == .onlineAudio {
            return 1;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AudioLibrarySectionHeaderView") as! AudioLibrarySectionHeaderView
        view.textLabel?.text = sectionTitles[section]
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if audioLibraryType == .localAudio {
            return 21.0;
        } else if audioLibraryType == .onlineAudio {
            return 0.00001;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if audioLibraryType == .localAudio {
            if section == 0 {
                return recordAudioList.count
            } else {
                return localAudioList.count
            }
        } else if audioLibraryType == .onlineAudio {
            return onlineAudioList.count;
        }
        
        return 0;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioFileCell") as! AudioFileCell
        if audioLibraryType == .localAudio {
            if indexPath.section == 0 {
                cell.audioNameLabel.text = PGAudioFileHelper.getFileNameFromURL(recordAudioList[indexPath.row])
                cell.selectedAudio(selectedAudioPath == recordAudioList[indexPath.row])
            } else {
                cell.audioNameLabel.text = PGAudioFileHelper.getFileNameFromURL(localAudioList[indexPath.row])
                cell.selectedAudio(selectedAudioPath == localAudioList[indexPath.row])
            }
        } else if audioLibraryType == .onlineAudio {
            cell.audioNameLabel.text = PGAudioFileHelper.getFileNameFromURL(onlineAudioList[indexPath.row])
            cell.selectedAudio(false)
        }
        return cell
    }
}

extension AudioLibraryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if audioLibraryType == .localAudio {
            if indexPath.section == 0 {
                selectedAudioPath = recordAudioList[indexPath.row]
            } else {
                selectedAudioPath = localAudioList[indexPath.row]
            }
        } else if audioLibraryType == .onlineAudio {
            downLoadAudio(with: onlineAudioList[indexPath.row])
        }
        
        tableView.reloadData()
    }
}


