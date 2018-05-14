//
//  TodayViewController.swift
//  MyBitCheckerExtension
//
//  Created by 齋藤　航平 on 2018/04/26.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import NotificationCenter
import Moya
import RxSwift
import PromiseKit

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var totalAssetLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var coinPriceLabel: UILabel!
    
    private let publicProvider = MoyaProvider<PublicApi>()
    private let disposebag = DisposeBag()
    private var ticker : Ticker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        let promises: [Promise<Bool>] = [self.getTicker(pair: "btc_jpy")]
        when(resolved: promises).done { result in
            self.coinPriceLabel.text = self.ticker?.data.last
        }
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize){
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize;
        }
        else {
            self.preferredContentSize = CGSize(width: 0, height: 100);
        }
    }
    
    func getTicker(pair: String) -> Promise<Bool> {
        return Promise(resolver: { seal in
            self.publicProvider.rx.request(.getTicker(pair: pair)).subscribe { event in
                switch event {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        self.ticker = try decoder.decode(Ticker.self, from: response.data)
                        
                        print("ticker:", self.ticker as Any)
                    } catch(let error) {
                        print("json convert failed in JSONDecoder", error.localizedDescription)
                    }
                case .error(let error):
                    print("error:", error)
                }
                seal.fulfill(true)
            }.disposed(by: self.disposebag)
        })
    }
    
}
