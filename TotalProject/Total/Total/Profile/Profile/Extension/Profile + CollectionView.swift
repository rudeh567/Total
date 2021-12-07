//
//  ProfileCell.swift
//  Total
//
//  Created by yeoboya on 2021/11/29.
//

import Foundation
import UIKit

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: 미니 프로필 컬렉션 뷰
    // 미니프로필뷰 하단에 있는 컬렉션 뷰입니다.
    // 클릭시 스크롤뷰를 띄우는 코드도 포함되어 있습니다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photo?.photoList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? ProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
     
        guard let urlString = viewModel.photo?.photoList?[indexPath.item].url,
            let url = URL(string: urlString) else {
            return UICollectionViewCell()
        }

        cell.imageView.kf.setImage(with: url)
        cell.imageView.layer.cornerRadius = 20
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 100
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    // 클릭시 그림을 하나하나 스크롤하여 볼 수 있도록 스크롤 뷰 컨트롤러를 프레젠트합니다.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let scrollVc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "Scroll") as? ScrollViewController else { return }
        
        scrollVc.viewModel = self.viewModel
        scrollVc.currentPage = indexPath.item
        
        scrollVc.modalPresentationStyle = .overFullScreen
        self.present(scrollVc, animated: true, completion: nil)
    }
    
}

//MARK: 전체보기
// 플로우 레이아웃으로 간격과 크기를 설정해 주었습니다. 미니프로필뷰 하단에 있는 컬렉션뷰를 큰 화면으로 볼 수 있습니다.
extension TotalViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photo?.photoList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? ProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let urlString = viewModel.photo?.photoList?[indexPath.item].url,
            let url = URL(string: urlString) else {
            return UICollectionViewCell()
        }
        
        cell.imageView.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 4) / 3
        let height = width
        cellSize = width
        
        return CGSize(width: width, height: height)
    }
    
    // 셀 끼리의 간격을 설정해주었습니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let photo = viewModel.photo?.photoList {
            let inset = (collectionView.frame.height - cellSize * CGFloat((photo.count/3))) / 2
            return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        }
        else {
            return UIEdgeInsets()
        }
       
    }
}
