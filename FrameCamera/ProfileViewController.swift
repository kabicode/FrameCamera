//
//  ProfileViewController.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/16.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    
    static func loadFromStoryboard() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "关于品果"
        
        tableView.contentInset.top = 14.0
        tableView.tableFooterView = UIView()
        
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        versionLabel.text = currentVersion
    }

    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            tapShareCell()
        }
    }

    
    // MARK: - Private Method
    func tapShareCell() {
        // TODO
    }
}
