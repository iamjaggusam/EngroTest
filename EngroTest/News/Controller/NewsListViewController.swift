//
//  NewsListViewController.swift
//  EngroTest
//
//  Created by JaGgu Sam on 06/12/22.
//

import UIKit

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    var newsList : [[Article]] = []
    let refreshControl = UIRefreshControl()
    var days = ["Today"]
    var getDate = Date()
    var requestNewFeed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNews(date: dateToString(date: getDate, outputFormat: "yyyy-MM-dd"))
        setupView()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Setup Views
    func setupView() {
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        self.newsTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        self.newsTableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTableViewCell")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
        self.newsTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.newsTableView.separatorColor = self.newsTableView.backgroundColor
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getNews(date: dateToString(date: getDate, outputFormat: "yyyy-MM-dd"))
    }
    
    // To get previous date news
    func getPreviousDateNews() {
        let date = getPreviousDate(date: getDate)
        getDate = date
        let prevDate = dateToString(date: date, outputFormat: "yyyy-MM-dd")
        days.append(prevDate)
        getNews(date: prevDate)
    }
}

// MARK: - TableView Delegate and DataSource
extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
        headerCell.dateLabel.text = days[section]
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsList.isEmpty {
            self.newsTableView.setEmptyView(title: "No news available", message: "")
        } else {
            self.newsTableView.restore()
        }
        return newsList.isEmpty ? 0 : newsList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        let articles = newsList[indexPath.section]
        cell.loadData(feed: articles[indexPath.row])
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let newsDetail = UIStoryboard.init(name: NEWS.STORYBOARD_CONSTANTS.NEWS_STORYBOARD, bundle: Bundle.main).instantiateViewController(withIdentifier: NEWS.VIEW_CONTROLLER_IDENTIFIER.NEWSDETAIL_VIEW_CONTOLLER) as! NewsDetailViewController
    //        newsDetail.newsUrl = newsList[indexPath.row].url ?? ""
    //        self.navigationController?.pushViewController(newsDetail, animated: true)
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1) == newsList[indexPath.section].count && (indexPath.section + 1) == newsList.count {
            tableView.addLoading(indexPath) {
                self.getPreviousDateNews()
            }
        }
    }
}

// MARK: - API Call
extension NewsListViewController {
    func getNews(date: String) {
        Spinner.start()
        NewsRespository.shared.getNews(date: date) { [weak self] (result) in
            DispatchQueue.main.async {
                Spinner.stop()
                switch result {
                    case .success(let response, let statusCode):
                        if  statusCode == 200 {
                            self?.newsList.append(response.articles ?? [])
                            self?.newsTableView.reloadData()
                            self?.refreshControl.endRefreshing()
                            self?.newsTableView.stopLoading()
                        }
                    case .failure(let error, _):
                        print(error)
                        break
                }
            }
        }
    }
}
