//
//  SignViewController.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import UIKit
import Alamofire

class SignViewController: UIViewController {
    @IBOutlet weak var photoLine: UIView!
    @IBOutlet weak var textFieldBack: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var manBtn: UIButton!
    @IBOutlet weak var womanBtn: UIButton!
    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var monthBtn: UIButton!
    @IBOutlet weak var dayBtn: UIButton!
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var textViewBack: UIView!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var finishBtn: UIButton!
    
    var isManClick: Bool = false // 남자 버튼이 클릭 되었는지 알수 있는 변수
    var isLadyClick: Bool = false // 여자 버튼이 클릭 되었는지 알 수 있는 변수
    var hasContents: Bool = false // 내용이 있는지 알 수 있는 변수
    var gender: String!
    var age: String!
    var email: String = ""
    
    var info: Email!
    var userInfo = UserInfo.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            photoSetting()
            textFieldBackSetting()
            manBtnSetting()
            womanBtnSetting()
            birthdayBtnSetting()
            textViewBackSetting()
            finishBtnSetting()
        } else {
            // Fallback on earlier versions
        }
        keyboardSetting()
        textViewSetting()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        textViewContent.resignFirstResponder()
        textField.resignFirstResponder()
    }
    
    //MARK: 남자가 클릭되었을 경우, 여자가 클릭 되었을 경우 서로 동시에 클릭이 될 수 없도록 합니다.
    @available(iOS 13.0, *)
    @IBAction func clickMan(_ sender: Any) {
        isManClick = true
        isLadyClick = false
        manBtnisClick()
        womanBtnSetting()
        
        gender = "M"
        self.btnCase()
    }
    
    @available(iOS 13.0, *)
    @IBAction func clickLady(_ sender: Any) {
        isLadyClick = true
        isManClick = false
        womanBtnisClick()
        manBtnSetting()
        
        gender = "F"
        self.btnCase()
    }
    
    // image를 누를시 앨범에서 이미지를 고를 수 있게 합니다.
    @IBAction func signPhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        self.present(imagePicker,animated: true)
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    //MARK: 생일 선택
    // 생일을 고를 때 제가 만든 커스텀 뷰를 불러와서 데이트 피커뷰로 날짜를 고르면 회원가입 생일 뷰에 데이트 피커뷰에서 입력받은 날짜를 그대로 넣어줍니다.
    @IBAction func datePick(_ sender: Any) {
        let view = DateView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height))
        
        view.pickDate = {
            if view.year == nil, view.month == nil, view.day == nil {
                view.year = "년"
                view.month = "월"
                view.day = "일"
            } else {
                let year = view.year
                let month = view.month
                let day = view.day
                
                self.yearBtn.setTitle(year, for: .normal)
                self.monthBtn.setTitle(month, for: .normal)
                self.dayBtn.setTitle(day, for: .normal)
                self.yearBtn.titleLabel?.textColor = .black

                self.monthBtn.titleLabel?.textColor = .black
                self.dayBtn.titleLabel?.textColor = .black
                self.btnCase()
                
                let dob = DateComponents(calendar: .current, year: Int(view.year), month: Int(view.month), day: Int(view.day)).date!
                
                let age = dob.age
                self.age = String(age)
            }
            view.dimissAni(y: 0)
            
        }
        self.view.addSubview(view)
        view.showAni(y: 0)
    }
    
    func btnOn() {
        self.finishBtn.isEnabled = true
        self.finishBtn.applyGradient(colours: [Color.periwinkle,Color.periwinkleTwo])
    }
    
    func btnOff() {
        self.finishBtn.isEnabled = false
        if let sublayer = self.finishBtn.layer.sublayers {
            for layer in sublayer {
                if layer.name == "grad" {
                    layer.removeFromSuperlayer()
                    self.finishBtn.backgroundColor = .lightGray
                }
            }
        }
    }
    
    // 회원가입 완료 시 데이터 저장
    @IBAction func finishSignUp(_ sender: Any) {
        self.info = Email(email: email, name: textField.text!, porfile_image: profileImageView.image!, age: self.age ?? "1", costs: textViewContent.text!, gender: gender)

        self.register(info)
        userInfo.isSignUp = true
        self.dismiss(animated: true, completion: nil)
    }
    
    // 뷰 내려감
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: 회원가입
    // 회원가입 완료 버튼을 눌렀을 시 멀티파트로 서버에 데이터를 전달해서 가입이 될 수 있게 합니다.
    func register(_ info: Email) {
        let url = URL(string: "http://babyhoney.kr/api/member")!
        AF.upload(multipartFormData: { MultipartFormData in
            MultipartFormData.append(Data(info.email.utf8), withName: "email")
            MultipartFormData.append(Data(info.name.utf8), withName: "name")
            MultipartFormData.append(Data(info.age.utf8), withName: "age")
            MultipartFormData.append(Data(info.costs.utf8), withName: "costs")
            MultipartFormData.append(Data(info.gender.utf8), withName: "gender")
            MultipartFormData.append(info.porfile_image.pngData()!, withName: "profile_img", fileName: "profile_url", mimeType: "image/jpeg")
        }, to: url, headers: ["Content-Type":"multipart/form-data"])
            .responseJSON { response in
                switch response.result {
                case .success(let res) :
                    print(res)
                case .failure(let err):
                    print("error: \(err)")
                }
            }
    }
}


