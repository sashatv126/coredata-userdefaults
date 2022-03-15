//
//  AddViewController.swift
//  M20
//
//  Created by Владимир on 14.03.2022.
//

import UIKit
import SnapKit
class AddViewController : UIViewController {
//MARK: -Views
    var data : Entity?
    private lazy var scrollView : UIScrollView = {
       let scroll = UIScrollView()
        return scroll
    }()
    private lazy var stackViewText : UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    private lazy var stackViewTButton : UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    private lazy var textFieldBirth : UITextField = {
        let text = UITextField()
        text.keyboardType = .numberPad
        text.borderStyle = .roundedRect
        text.placeholder = "Enter birth"
        text.textContentType = .telephoneNumber
        return text
    }()
    private lazy var textFieldName : UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = "Enter name"
        return text
    }()
    private lazy var textFieldLastname : UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = "Enter lastname"
        return text
    }()
    private lazy var textFieldcountry : UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = "Enter country"
        return text
    }()
    private lazy var button : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE", for: .normal)
        button.addTarget(.none, action: #selector(buttonAFTapped), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        text()
        textDelegate()
        setupVIews()
        setupConstraints()
    }
//MARK: -Private func
    private func setupVIews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackViewText)
        scrollView.addSubview(stackViewTButton)
        stackViewText.addArrangedSubview(textFieldBirth)
        stackViewText.addArrangedSubview(textFieldName)
        stackViewText.addArrangedSubview(textFieldLastname)
        stackViewText.addArrangedSubview(textFieldcountry)
        stackViewTButton.addArrangedSubview(button)
        view.backgroundColor = .white
    }
    private func setupConstraints() {
        scrollView.snp.makeConstraints{maker in
            maker.left.right.equalTo(view.safeAreaLayoutGuide).inset(0)
            maker.bottom.top.equalTo(view.safeAreaLayoutGuide)
        }
        stackViewText.snp.makeConstraints{maker in
            maker.top.equalTo(scrollView).inset(70)
            maker.centerX.equalTo(scrollView)
            maker.left.right.equalTo(scrollView).inset(20)
        }
        button.snp.makeConstraints{maker in
            maker.width.equalTo(120)
            maker.height.equalTo(50)
        }
        
        stackViewTButton.snp.makeConstraints{maker in
            maker.bottom.equalTo(stackViewText).offset(200)
            maker.centerX.equalTo(scrollView)
        }
        textFieldBirth.snp.makeConstraints{maker in maker.width.equalTo(400)}
        textFieldName.snp.makeConstraints{maker in maker.width.equalTo(400)}
        textFieldLastname.snp.makeConstraints{maker in maker.width.equalTo(400)}
        textFieldcountry.snp.makeConstraints{maker in maker.width.equalTo(400)}
    }
    private func textDelegate() {
        textFieldBirth.delegate = self
        textFieldName.delegate = self
        textFieldLastname.delegate = self
        textFieldcountry.delegate = self
    }
    private func text(){
        if let data = data {
            textFieldBirth.text = String(data.birth)
            textFieldName.text = data.name
            textFieldLastname.text = data.lastName
            textFieldcountry.text = data.country
            
            
        }
    }
    @objc private func buttonAFTapped() {
        data?.name = textFieldName.text
        data?.lastName = textFieldLastname.text
        data?.country = textFieldcountry.text
        data?.birth = Int64(textFieldBirth.text!)!
        try? data?.managedObjectContext?.save()
        navigationController?.popViewController(animated: true)
}
}
//MARK: -Extesion
extension AddViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldBirth.resignFirstResponder()
        textFieldName.resignFirstResponder()
        textFieldLastname.resignFirstResponder()
        textFieldcountry.resignFirstResponder()
        return true
    }
}
