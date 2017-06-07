//
//  ArticleDetailViewController.swift
//  MyNewsDemo
//
//  Created by Denny Tsai on 2017/03/26.
//  Copyright © 2017 Denny Tsai. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftDate

class ArticleDetailViewController: UIViewController {
    
    var article: Article!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = article.heading
        showArticleDetail()
    }
    
    func showArticleDetail() {
        headingLabel.text = article.heading
        publishedDateLabel.text = article.publishedDate.string(custom: "yyyy/MM/dd HH:mm")
        
        photoImageView.sd_setImage(with: article.imageURL, placeholderImage: nil, options: SDWebImageOptions()) { image, error, _, _ in
            guard let image = image else {
                return
            }
            
            let scaleFactor = self.view.bounds.width / image.size.width
            let height = image.size.height * scaleFactor
            self.imageHeightConstraint.constant = height
        }
        
        let attributes = contentLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
        
        if let content = article.content {
            contentLabel.attributedText = NSAttributedString(string: content, attributes: attributes)
        } else {
            contentLabel.attributedText = nil
        }
    }

    @IBAction func actionTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let copyAction = UIAlertAction(title: "複製網址", style: .default) { _ in
            UIPasteboard.general.string = self.article.articleURL.absoluteString
            
            let alert = UIAlertController(title: nil, message: "網址已複製到剪貼簿！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        actionSheet.addAction(copyAction)
        
        let openAction = UIAlertAction(title: "使用Safari開啟", style: .default) { _ in
            UIApplication.shared.openURL(self.article.articleURL)
        }
        actionSheet.addAction(openAction)
        
        if UIApplication.shared.canOpenURL(URL(string: "line://")!) {
            let shareToLineAction = UIAlertAction(title: "使用LINE分享", style: .default) { _ in
                let encodedURL = self.article.articleURL.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
                let shareURL = URL(string: "line://msg/text/\(encodedURL)")!
                
                UIApplication.shared.openURL(shareURL)
            }
            actionSheet.addAction(shareToLineAction)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}
