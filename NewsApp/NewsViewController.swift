//
//  NewsViewController.swift
//  NewsApp
//
//  Created by 中村泰輔 on 2019/08/11.
//  Copyright © 2019 icannot.t.n. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class NewsViewController: UIViewController,IndicatorInfoProvider {
    //urlを受け取る
    var url : String = ""
    //itemInfoを受け取る
    var itemInfo : IndicatorInfo = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfo
        
    }


}
