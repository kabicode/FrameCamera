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
    
    var localAudioList: [AudioModel] = []
    var recordAudioList: [AudioModel] = []
    var onlineAudioList: [AudioModel] = []
    
    var selectedAudio: AudioModel?
    var shouldReloadList: Bool = false
    
    deinit {
        print("")
    }
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: "AudioLibraryVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldReloadList {
            shouldReloadList = false
            reloadLocalList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
        setupSubviews()
        
        configureSubviews()
        
        tableView.tableFooterView = UIView()
        
        reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupReloadFlag), name: NSNotification.Name("ShouldRefreshLocalMusicList"), object: nil)
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "AudioFileCell", bundle: nil), forCellReuseIdentifier: "AudioFileCell")
        tableView.register(AudioLibrarySectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "AudioLibrarySectionHeaderView")
    }
    
    func setupSubviews() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.pullToHeaderView()
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
    
    // MARK: - Notification
    func setupReloadFlag() {
        shouldReloadList = true
        
        reloadLocalList()
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
    func pullToHeaderView() {
        if audioLibraryType == .localAudio {
            reloadLocalList()
        } else if audioLibraryType == .onlineAudio {
            reloadData()
        }
    }
    
    func reloadData() {
        selectedAudio = asset.audio
        getOnlineAudioList()
        getLocalAudioList()
        getRecordAudioList()
        
        tableView.reloadData()
        tableView.mj_header.endRefreshing()
    }
    
    func reloadLocalList() {
        selectedAudio = asset.audio
        getLocalAudioList()
        getRecordAudioList()
        
        tableView.reloadData()
        tableView.mj_header.endRefreshing()
    }
    
    func getLocalAudioList() {
        
        localAudioList = PGUserDefault.localAudios
        
        print("localList -- \(localAudioList)")
    }
    
    func getRecordAudioList() {
//        let list = PGAudioFileHelper.getRecordAudioFolderContentFiles()
//        recordAudioList.removeAll()
//        
//        for (_, name) in list.enumerated() {
//            let filePath = PGAudioFileHelper.getRecordAudiosFolderPath() + "/" + name
//            recordAudioList.append(filePath)
//        }
//        print("recordList -- \(recordAudioList)")
        recordAudioList = PGUserDefault.recordAudios
    }
    
    func getOnlineAudioList() {
        let request = Router.Audio.getOnlineAudios
        NetworkHelper.sendNetworkRequest(request: request,
                                         showHUD: true,
                                         on: self,
                                         successHandler:
            { (json) in
                let jsons = json["Data"].arrayValue
                
                self.onlineAudioList.removeAll()
                jsons.forEach({ (json) in
                    self.onlineAudioList.append(AudioModel.init(from: json))
                })
                self.tableView.reloadData()
            
        }, failureHandler: {
        })
    }
    
    func downLoadAudio(_ audio: AudioModel) {
        
        if localAudioList.contains(audio) {
            selectedAudio = audio
            tapMyMusicBtn(myMusicBtn)
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "下载中..."
        
        PGAudioFileHelper.downloadAudio(audio.url, compelete: { [weak self, weak hud] (audioPath, success) in
            hud?.hide(animated: true)

            if success {
                let path = PGAudioFileHelper.getAuidoFilePathFromSandBoxPath(audioPath!)
                self?.asset.audio = audio
                audio.filePath = path
                self?.localAudioList.append(audio)
                PGUserDefault.addLocalAudio(audio)
                
                if self != nil {
                    showMessageNotifiaction("下载音频成功", type: .success, on: self)
                    NotificationCenter.default.post(name: NSNotification.Name("ShouldRefreshLocalMusicList"), object: nil)
                    self?.selectedAudio? = audio
                    self?.tapMyMusicBtn((self?.myMusicBtn)!)
                }
                
            } else {
                if self != nil {
                    showMessageNotifiaction("下载音频失败", on: self)
                }
            }
        })
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
                let audio = recordAudioList[indexPath.row]
                cell.audioNameLabel.text = audio.title
                cell.selectedAudio(selectedAudio == audio)
                
            } else {
                let audio = localAudioList[indexPath.row]
                cell.audioNameLabel.text = audio.title
                cell.selectedAudio(selectedAudio == audio)
            }
            
        } else if audioLibraryType == .onlineAudio {
            let audio = onlineAudioList[indexPath.row]
            cell.audioNameLabel.text = audio.title
            cell.selectedAudio(false)
        }
        return cell
    }
}

extension AudioLibraryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if audioLibraryType == .localAudio {
            if indexPath.section == 0 {
                selectedAudio = recordAudioList[indexPath.row]
            } else {
                let audio = localAudioList[indexPath.row]
                selectedAudio = audio
            }
            
        } else if audioLibraryType == .onlineAudio {
            let audio = onlineAudioList[indexPath.row]
            downLoadAudio(audio)
        }
        
        tableView.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        if audioLibraryType == .localAudio {
//            return .delete
//        }
//        return .none
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if audioLibraryType == .localAudio {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if audioLibraryType == .localAudio {
            return "删除"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if audioLibraryType == .localAudio {
            var audio: AudioModel
            if indexPath.section == 0 {
                audio = recordAudioList.remove(at: indexPath.row)
                PGUserDefault.recordAudios = recordAudioList
            } else {
                audio = localAudioList.remove(at: indexPath.row)
                PGUserDefault.localAudios = localAudioList
            }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            if selectedAudio == audio {
                selectedAudio = nil
            }
            
            guard let filePath = audio.filePath else { return }
            try? FileManager.default.removeItem(atPath: PGFileHelper.getSandBoxPath(with: filePath))
        }
    }
}


