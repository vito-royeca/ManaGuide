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
    func showRightMenu() {
        if let navigationVC = mm_drawerController.rightDrawerViewController as? UINavigationController {
            var menuView:MenuViewController?
            
            for drawer in navigationVC.viewControllers {
                if drawer is MenuViewController {
                    menuView = drawer as? MenuViewController
                }
            }
            if menuView == nil {
                menuView = MenuViewController()
                navigationVC.addChildViewController(menuView!)
            }
            
            navigationVC.popToViewController(menuView!, animated: true)
        }
        mm_drawerController.toggle(.right, animated:true, completion:nil)
    }

}
