//
//  ArticleCell.swift
//  MyNewsDemo
//
//  Created by Denny Tsai on 2017/03/26.
//  Copyright © 2017 Denny Tsai. All rights reserved.
//

import UIKit
import SwiftDate
import SDWebImage

class ArticleCell: UITableViewCell {
    
    var article: Article! {
        didSet {
            if let article = article {
                headingLabel.text = article.heading
                publishedDateLabel.text = article.publishedDate.string(custom: "yyyy/MM/dd HH:mm")
                coverImageView.sd_setImage(with: article.imageURL, placeholderImage: nil)
            }
        }
    }

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
}
