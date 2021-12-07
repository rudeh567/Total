//
//  ScrollViewController.swift
//  Total
//
//  Created by yeoboya on 2021/11/29.
//

import UIKit

class ScrollViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollLabel: UILabel!
    
    var viewModel = ProfileViewModel() //뷰모델 선언
    var currentPage: Int = 0 // 현재 페이지를 알 수 있게 하는 변수입니다. 나중에 사용합니다.
       
    override func viewDidLoad() {
        super.viewDidLoad()
        addContentScrollView()
        setPageControl()
    }

    
    // 스크롤뷰에 나타나는 이미지의 크기, 스크롤 했을때의 width의 크기, height의 크기를 지정해준다.
    private func addContentScrollView() {
        let photo = viewModel.photo?.photoList?.count
        
        scrollView.delegate = self
        scrollView.frame.size.width = view.frame.width
        scrollView.frame.size.height = view.frame.height-350
        scrollView.center.y = view.center.y
        
        for i in 0..<photo! {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            let xPos = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: view.frame.width, height: scrollView.bounds.height)
            imageView.kf.setImage(with: URL(string:viewModel.photo?.photoList?[i].url ?? viewModel.defaultImage))
            scrollView.addSubview(imageView)
            scrollView.contentSize.width = imageView.frame.width * CGFloat(i+1)
        }
    }
    
    // 내가 몇번째 페이지를 처음에 눌렀는지 확인하고 그 페이지부터 스크롤할 수 있게 하고 스크롤뷰 상단에 내가 몇번째 페이지를 보고 있는지 레이블로 출력해준다.
    private func setPageControl() {
        scrollView.setContentOffset(CGPoint(x: CGFloat(currentPage) * view.frame.width, y: 0), animated: true)
        scrollLabel.text = "\(currentPage + 1) / \(viewModel.photo?.photoList?.count ?? 1)"
    }
    
    @IBAction func dissmissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
