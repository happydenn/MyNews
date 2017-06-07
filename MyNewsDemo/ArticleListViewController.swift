//
//  ArticleListViewController.swift
//  MyNewsDemo
//
//  Created by Denny Tsai on 2017/03/26.
//  Copyright © 2017 Denny Tsai. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftDate

class ArticleListViewController: UITableViewController {
    
    var articles = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        downloadArticles()
    }
    
    func downloadArticles() {
        if let refreshControl = refreshControl, !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
        
        Article.getLatestArticles { articles, error in
            guard let articles = articles else {
                print("下載新聞失敗！\(error)")
                return
            }
            
            self.articles = articles
        }
    }
    
    @IBAction func refreshPulled(_ sender: Any) {
        downloadArticles()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        let article = articles[indexPath.row]
        
        cell.article = article
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showArticleDetail" {
            let selectedCell = sender as! ArticleCell
            let detailVC = segue.destination as! ArticleDetailViewController
            
            detailVC.article = selectedCell.article
        }
    }

}
