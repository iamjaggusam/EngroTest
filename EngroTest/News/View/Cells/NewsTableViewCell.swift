//
//  NewsTableViewCell.swift
//  EngroTest
//
//  Created by JaGgu Sam on 06/12/22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadData(feed: Article) {
        self.titleLabel.text = feed.title ?? ""
        self.descriptionLabel.text = feed.articleDescription ?? ""
        self.newsImage.load(urlString: feed.urlToImage, size: CGSize(width: 120, height: 120), downloader: ImageDownloader.shared) {
        }
    }
}
