//
//  BaseViewController.swift
//  ManaGuide
//
//  Created by Jovito Royeca on 21/07/2017.
//  Copyright © 2017 Jovito Royeca. All rights reserved.
//

import UIKit
import MMDrawerController

class BaseViewController: UIViewController {

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: Custom methods
    func showSettingsMenu(file: String) {
        if let navigationVC = mm_drawerController.rightDrawerViewController as? UINavigationController {
            var settingsView:SettingsViewController?
            
            for drawer in navigationVC.viewControllers {
                if drawer is SettingsViewController {
                    settingsView = drawer as? SettingsViewController
                }
            }
            if settingsView == nil {
                settingsView = SettingsViewController()
                navigationVC.addChildViewController(settingsView!)
            }
            
            settingsView!.showCreditsFooter = false
            settingsView!.file = file
            navigationVC.popToViewController(settingsView!, animated: true)
        }
        mm_drawerController.toggle(.right, animated:true, completion:nil)
    }

}
