//
//  NewsViewController.swift
//  NewsApp
//
//  Created by 中村泰輔 on 2019/08/11.
//  Copyright © 2019 icannot.t.n. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit

class NewsViewController: UIViewController, IndicatorInfoProvider, UITableViewDataSource, UITableViewDelegate, WKNavigationDelegate, XMLParserDelegate {
    // テーブルビューをコードで実装していく
    // テーブルビューのインスタンスを取得
    var tableView: UITableView = UITableView()
    
    var parser: XMLParser = XMLParser()
    
    //var articles = NSMutableArray()  →   変更
    var articles : [Any] = []
    // webView
    @IBOutlet weak var webView: WKWebView!
    // toolBar(4つのボタンが入っている)
    @IBOutlet weak var toolBar: UIToolbar!
    
    //urlを受け取る
    var url : String = ""
    //itemInfoを受け取る
    var itemInfo : IndicatorInfo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setTableView()
        // デリゲートの接続
        parser.delegate = self
        // tableViewが表示されるのを邪魔しないように、最初は隠す
        webView.isHidden = true
        toolBar.isHidden = true
        
        
    }
    
    func parseUrl() {
        //String型で作成したURLをurl型に変更する
        let urlToSend: URL = URL(string: url)!
        parser = XMLParser(contentsOf: urlToSend)!
        //urlをparseする度に初期化する必要がある
        articles = []
        // 解析の実行
        parser.parse()
        // TableViewのリロード
        tableView.reloadData()
        
    }
    
    func setTableView() {
        // デリゲートとの接続
        tableView.delegate = self
        tableView.dataSource = self
        // navigationDelegateとの接続
        webView.navigationDelegate = self
        //tableViewサイズの確定
        tableView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 50)
        // ViewにtableViewを追加する
        self.view.addSubview(tableView)
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 記事の数だけセルを返す
        return articles.count
        
    }
        // セルのカスタマイズ
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得して、セルのスタイルを決める。記事以外にurlも入れたいためスタイルはsubtitleとする
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        // セルの色
        cell.backgroundColor = #colorLiteral(red: 0.9678321481, green: 0.999337256, blue: 0.7441290617, alpha: 1)
        // 記事テキストサイズとフォント
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor.black
        // 記事urlのサイズとフォント
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cell.detailTextLabel?.textColor = UIColor.gray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //tableViewを隠す
        tableView.isHidden = true
        //toolBarを表示する
        toolBar.isHidden = false
        //webViewを表示する
        webView.isHidden = false
        
    }
    
    // キャンセル
    @IBAction func cancel(_ sender: Any) {
        
        //tableViewを表示する
        tableView.isHidden = false
        //toolBarを隠す
        toolBar.isHidden = true
        //webViewを隠す
        webView.isHidden = true
        
    }
    // 戻る
    @IBAction func backPage(_ sender: Any) {
        
        webView.goBack()
        
    }
    // 次へ
    @IBAction func nextPage(_ sender: Any) {
        
        webView.goForward()
        
    }
    // リロード
    @IBAction func refreshPage(_ sender: Any) {
        
        webView.reload()
    }

    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfo
        
    }
}
