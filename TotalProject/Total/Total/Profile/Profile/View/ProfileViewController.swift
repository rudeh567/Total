//
//  ProfileViewController.swift
//  Total
//
//  Created by yeoboya on 2021/11/27.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var circleProfile: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var costsView: UIView!
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var totalPhotoButton: UIButton!
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var costsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let viewModel = ProfileViewModel() // ViewModel을 선언
    var isMemberList = false // 멤버리스트로 띄웠을 시와 기본 프로필을 띄울 시를 구분하기 위해 만든 Bool 변수입니다.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetting()
        dimissSetting()
        whichProfile()
    }
    
    //MARK: 컬렉션 뷰 세팅
    //직접 만든 커스텀 셀을 register 해줍니다.
    func collectionViewSetting() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        self.collectionView.backgroundColor = UIColor.white
    }
    
    //프로필 뒤에 있는 투명한 뷰에 텝 제스처를 설정하여 클릭이벤트를 받을 수 있게 합니다.
    func dimissSetting() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dismissProfile(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
    }
    
    // 디미드 뷰를 누르면 프로필이 사라지게 합니다.
    @objc func dismissProfile(_ tapRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: LayOut
    // 여러가지 레이아웃에 관련된 코드들이 적혀있습니다.
    func viewSetting() {
        contentViewSetting()
        profileImageSetting()
        totalPhotoButtonSetting()
        genderViewSetting()
        likeViewSetting()
        costsViewSetting()
        locationViewSetting()
    }
    
    //MARK: 무슨 프로필
    // 기본 프로필을 띄울때는 기본 프로필 함수를 실행하고 멤버리스트에서 띄웠을 때에는 특정 프로필 함수를 실행합니다.
    func whichProfile() {
        if isMemberList == false {
            viewModel.getProfileInfo(completion: defaultDataReceive)
        } else {
            viewModel.getProfileByMember(completion: dataReceive)
        }
    }
    
    //MARK: 데이터 받기
    // 데이터를 받아 프로필뷰의 데이터들을 가공하는 함수입니다.
    func dataReceive(check: Bool) {
        if check {
            if viewModel.userInfo.gender == "M" {
                circleProfile.image = UIImage(named: "img_profile_line_m")
                genderLabel.textColor = Color.softBlue
                genderImage.image = UIImage(named: "ico_sex_m")
                genderView.layer.borderColor = Color.lightPeriwinkle.cgColor
            }
            
            photoCountLabel.text = " \(viewModel.photo?.photoList?.count ?? 0)"
            likeLabel.text = viewModel.member?.totLikeCnt
            genderLabel.text = viewModel.member?.age
            nameLabel.text = viewModel.member?.name
            locationLabel.text = "|  \(viewModel.member?.loc ?? "광주")"
            costsLabel.text = viewModel.member?.conts ?? "소개가 없습니다."
            profileImage.kf.setImage(with: URL(string: viewModel.photo?.profile ?? viewModel.defaultImage))

            collectionViewSetting()
            collectionView.reloadData()
        } else {
            print("불러오지못했습니다.")
        }
    }
    
    //MARK: 기본 프로필
    // 기본 프로필을 띄우는 함수입니다. 어떤 데이터의 영향도 받지않습니다.
    func defaultDataReceive(check: Bool) {
        if check {
            photoCountLabel.text = " \(viewModel.photo?.photoList?.count ?? 0)"
            likeLabel.text = viewModel.member?.totLikeCnt
            genderLabel.text = viewModel.member?.age
            nameLabel.text = viewModel.member?.name
            locationLabel.text = "|  \(viewModel.member?.loc ?? "광주")"
            costsLabel.text = viewModel.member?.conts ?? "소개가 없습니다."
            profileImage.kf.setImage(with: URL(string: viewModel.photo?.profile ?? viewModel.defaultImage))

            collectionViewSetting()
            collectionView.reloadData()
        } else {
            print("불러오지못했습니다.")
        }
    }
    
    //MARK: 전체 보기
    //전체보기 버튼을 누를 시 사진을 한꺼번에 볼 수 있는 컬렉션 뷰로 이동합니다.
    @IBAction func showTotal(_ sender: Any) {
        guard let totalVc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "Total") as? TotalViewController else { return }
        
        totalVc.viewModel.photo = self.viewModel.photo
        
        totalVc.modalPresentationStyle = .fullScreen
        self.present(totalVc, animated: true, completion: nil)
    }
    
    //MARK: 사연보내기
    @IBAction func sendStory(_ sender: Any) {
        let view = SendStory()
        view.frame = UIScreen.main.bounds
        view.showAni(y: 0)
        self.view.addSubview(view)
    }
}
