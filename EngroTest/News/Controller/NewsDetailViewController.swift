//
//  NewsDetailViewController.swift
//  EngroTest
//
//  Created by JaGgu Sam on 06/12/22.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    var newsUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let myURL = URL(string:newsUrl) else {return}
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
