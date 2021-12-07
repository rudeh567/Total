  //
//  DateView.swift
//  Profile
//
//  Created by yeoboya on 2021/11/05.
//

import Foundation
import UIKit

class DateView: UIView {

    @IBOutlet weak var checkButton: UIButton!
    
    var pickDate: (() -> ())?
    
    var year: String!
    var month: String!
    var day: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        backSetting()
        btnSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        backSetting()
        btnSetting()
    }
    
    private func loadView() {
        let nibs = Bundle.main.loadNibNamed("DateView", owner: self, options: nil)
        
        guard let view = nibs?.first as? UIView else {
            print("error")
            return
        }
        
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func backSetting() {
        self.backgroundColor = .clear
    }
    
    func btnSetting() {
        checkButton.layer.cornerRadius = 15
    }
    
    @IBAction func updateTime(_ sender: UIDatePicker) {
        let swiftDatePickerView = sender
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy"
        year = dateFormat.string(from: swiftDatePickerView.date)
    }
    
    @IBAction func updateMonth(_ sender: UIDatePicker) {
        let swiftDatePickerView = sender
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM"
        month = dateFormat.string(from: swiftDatePickerView.date)
    }
    
    @IBAction func updateDay(_ sender: UIDatePicker) {
        let swiftDatePickerView = sender
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd"
        day = dateFormat.string(from: swiftDatePickerView.date)
    }
    
    @IBAction func pickDate(_ sender: Any) {
        pickDate!()
    }
}

extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year!}
}
