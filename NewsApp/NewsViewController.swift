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
    
    // var articles = NSMutableArray()  →   変更
    var articles : [Any] = []
    // XMLファイルに解析をかけた情報で(object-c型)
    var elements = NSMutableDictionary()
    // XMLファイルのタグ情報
    var element : String = ""
    // XMLファイルのタイトル情報
    var titleString : String = ""
    // XMLファイルのリンク情報
    var linkString : String = ""
    // webView
    @IBOutlet weak var webView: WKWebView!
    // toolBar(4つのボタンが入っている)
    @IBOutlet weak var toolBar: UIToolbar!
    
    // urlを受け取る
    var url : String = ""
    // itemInfoを受け取る
    var itemInfo : IndicatorInfo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setTableView()
      
        // tableViewが表示されるのを邪魔しないように、最初は隠す
        webView.isHidden = true
        toolBar.isHidden = true
        
        parseUrl()
    }
    // urlを解析する
    func parseUrl() {
        // String型で作成したURLをurl型に変更する
        let urlToSend: URL = URL(string: url)!
        // パースの対象となるurlToSendを入れます
        parser = XMLParser(contentsOf: urlToSend)!
        //urlをparseする度に初期化する必要がある
        articles = []
        // デリゲートの接続
        parser.delegate = self
        // RSS解析の実行
        parser.parse()
        // TableViewのリロード
        tableView.reloadData()
    }
    // 解析中に要素の開始タグがあったときに実行されるメソッド。何度もデータを呼ぶので入ってくる度に元あるデータを初期化する必要がある
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // elementNameにタグの名前が入ってくるのでelementに代入
        element = elementName
        
        //エレメントにタイトルにタイトルが入ってきたら
        if element == "item" {
            // 初期化
            elements = [:]
            titleString = ""
            linkString = ""
        }
    }
    // 開始タグと終了タグでくくられたデータがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element == "title" {
            
            titleString.append(string)
            
        } else if element == "link" {
            
            linkString.append(string)
            
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // アイテムという要素の中にあるなら
        if elementName == "item" {
            //titleString,linkStringの中身が空でないなら
            if titleString != "" {
                // elementsに"title","link"というキー値を付与しながらtitleString,linkStringをセット
                elements.setObject(titleString, forKey: "title" as NSCopying)
                
            }
            
            if linkString != "" {
                
                elements.setObject(linkString, forKey: "link" as NSCopying)
                
            }
            // articlesの中にelementsを入れる
            articles.append(elements)
            
        }
        
        
    }
    
    func setTableView() {
        // デリゲートとの接続
        tableView.delegate = self
        tableView.dataSource = self
        // navigationDelegateとの接続
        webView.navigationDelegate = self
        //tableViewサイズの確定
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
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
        cell.textLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "title") as? String
        cell.textLabel?.textColor = UIColor.black
        // 記事urlのサイズとフォント
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cell.detailTextLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "link") as? String
        cell.detailTextLabel?.textColor = UIColor.gray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let linkURL = ((articles[indexPath.row] as AnyObject).value(forKey: "link") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
         let urlStr = (linkURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
        guard let url = URL(string: urlStr) else {
            return
        }
        let urlRequest = NSURLRequest(url: url)
        webView.load(urlRequest as URLRequest)
        
        
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
