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
import CryptoSwift

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var totalAssetLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var coinPriceLabel: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    
    private let publicProvider = MoyaProvider<PublicApi>()
    private let privateProvider = MoyaProvider<PrivateApi>()
    private let disposebag = DisposeBag()
    private var ticker : Ticker?
    private var assets : [AssetElement]?
    private var selectCoinName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        let defaults = UserDefaults(suiteName: "group.jp.co.myBitChecker")
        selectCoinName = defaults?.string(forKey: "select_coin")
        if let selectCoinName = selectCoinName {
            coinImageView.image = UIImage(named: selectCoinName)
            let promises: [Promise<Bool>] = [self.getTicker(pair: selectCoinName + "_jpy"), self.getAssets()]
            when(resolved: promises).done { result in
                self.coinLabel.text = selectCoinName.uppercased()
                self.coinPriceLabel.text = self.ticker?.data.last
                if let assets = self.assets, let ticker = self.ticker {
                    print("assets:", assets)
                    for asset in assets {
                        if asset.asset == selectCoinName {
                            let totalAsset = Double(asset.onhandAmount)! * Double(ticker.data.last)!
                            self.totalAssetLabel.text = String(floor(totalAsset)).replacingOccurrences(of: ".0", with: "") + "円"
                        }
                    }
                }
            }
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
    
    //ticker情報取得
    func getTicker(pair: String) -> Promise<Bool> {
        return Promise(resolver: { seal in
            self.publicProvider.rx.request(.getTicker(pair: pair)).subscribe { event in
                switch event {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        self.ticker = try decoder.decode(Ticker.self, from: response.data)
                        print("ticker:", self.ticker!)
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
    
    //assets取得
    func getAssets() -> Promise<Bool> {
        return Promise(resolver: { seal in
            self.privateProvider.rx.request(.getAssets()).subscribe { event in
                switch event {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        self.assets = try decoder.decode(Asset.self, from: response.data).data.assets
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
