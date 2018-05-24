//
//  ViewController.swift
//  MyBitChecker
//
//  Created by 齋藤　航平 on 2018/04/26.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var coinPickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    private let titleList = ["BTC", "XRP", "MONA" ,"BCC"]
    private let contentList = ["btc", "xrp", "mona", "bcc"]
    private var selectStr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
        selectStr = "btc"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func actionSaveUserDefaults(_ sender: Any) {
        if selectStr != nil {
            let defaults = UserDefaults(suiteName: "group.jp.co.myBitChecker")
            defaults?.set(selectStr, forKey: "select_coin")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return titleList.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return titleList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        selectStr = contentList[row]
    }
    
}

