//
//  ViewController.swift
//  Scraping
//
//  Created by 生田拓登 on 2022/05/16.
//

import UIKit
import Alamofire
import Kanna

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var newsIndex = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getNews()
    }
    
    func getNews() {
        
        AF.request("https://news.yahoo.co.jp/").responseString { response in
            if let html = response.value {
                if let doc = try? HTML(html: html, encoding: .utf8) {
                    //ニュースのタイトルを取得
                    var titles = [String]()
                    for link in doc.xpath("//a[@class='sc-jqCOkK jEGAcM']") {
                        titles.append(link.text ?? "")
                    }
                    
                    for value in titles {
                        let news = News()
                        news.title = value
                        self.newsIndex.append(news)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsIndex.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
        let news = newsIndex[indexPath.row]
        cell.textLabel?.text = news.title
        return cell
    }
    
}

