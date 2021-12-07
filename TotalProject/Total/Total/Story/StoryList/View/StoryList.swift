//
//  StoryList.swift
//  Total
//
//  Created by yeoboya on 2021/11/29.
//

import Foundation
import UIKit
import Alamofire

class StoryList: UIView {
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ListViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        shadowSetting()
        tableViewSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        shadowSetting()
        tableViewSetting()
    }
    
    private func loadView() {
        let nibs = Bundle.main.loadNibNamed("StoryList", owner: self, options: nil)
        
        guard let view = nibs?.first as? UIView else {
            print("nib error *********")
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    //MARK: 사연 리스트
    // 사연리스트를 볼때 페이지 정보를 가져와서 우리가 스크롤 할 수 있도록 합니다.
    func dataReceive(page: Int) {
        viewModel.isPaging = true
        AF.request(URL(string: "\(Host.host)/page/\(page)")!, method: .get, parameters: viewModel.stroyContent, encoding: URLEncoding.default).responseJSON { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case.success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let result = try JSONDecoder().decode(Page.self, from: data)
                    
                    self.viewModel.detailInfo.append(contentsOf: result.list)
                    self.viewModel.total = result
                    self.viewModel.hasNextPage = self.viewModel.detailInfo.count < self.viewModel.total.total_page
                    
                    self.tableView.reloadData()
                    self.viewModel.isPaging = false
                    
                } catch DecodingError.keyNotFound(let key, let context) {
                    print(key,context)
                }
                catch {
                    print(error.localizedDescription)
                }
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    // 페이징이 되고 있을 시 푸터뷰를 출력하고 페이지 변수를 늘리며, 다음 페이지가 없을시 푸터뷰를 비활성화하고 페이지를 늘리지 않습니다.
    func paging() {
        settingFooterView()
        // 페이징이 되고있지 않고 다음 페이지가 있을때 실행됩니다.
        if viewModel.isPaging == false && viewModel.hasNextPage {
            viewModel.page += 1
            dataReceive(page: viewModel.page)
        } else {
            tableView.tableFooterView = nil
        }
    }
    
    @IBAction func dimissView(_ sender: Any) {
        self.dimissAni(y: 0)
    }
}
