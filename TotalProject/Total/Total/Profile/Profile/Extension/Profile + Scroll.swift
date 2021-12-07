//
//  Profile + Scroll.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import Foundation
import UIKit

extension ScrollViewController: UIScrollViewDelegate {
    // 몇번째 사진을 보고 있는지 알려줍니다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        scrollLabel.text = "\(Int(round(value)) + 1) / \(viewModel.photo?.photoList?.count ?? 1)"
    }
}
