//
//  ViewController.swift
//  EngroTest
//
//  Created by JaGgu Sam on 06/12/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onClickNews(_ sender: Any) {
        let newsList = UIStoryboard.init(name: NEWS.STORYBOARD_CONSTANTS.NEWS_STORYBOARD, bundle: Bundle.main).instantiateViewController(withIdentifier: NEWS.VIEW_CONTROLLER_IDENTIFIER.NEWSLIST_VIEW_CONTOLLER) as! NewsListViewController
        self.navigationController?.pushViewController(newsList, animated: true)
    }
    
    @IBAction func onClickFiles(_ sender: Any) {
        let files = UIStoryboard.init(name: FILES.STORYBOARD_CONSTANTS.FILES_STORYBOARD, bundle: Bundle.main).instantiateViewController(withIdentifier: FILES.VIEW_CONTROLLER_IDENTIFIER.FILES_VIEW_CONTOLLER) as! FilesViewController
        self.navigationController?.pushViewController(files, animated: true)
    }
}

