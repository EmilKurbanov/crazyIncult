//
//  IncultVC.swift
//  Incult
//
//  Created by emil kurbanov on 04.04.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class IncultVC: UIViewController {
    let incultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Пример"
        return label
    }()
    
    let incultButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нажать", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(loadIncludeAPI), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(incultLabel)
        view.addSubview(incultButton)
        loadConsrtaints()
    }
    
    @objc func loadIncludeAPI() {
        //https://evilinsult.com/generate_insult.php?lang=en&type=json
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "evilinsult.com"
        urlComponents.path = "/generate_insult.php"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "lang", value: "ru"),
            URLQueryItem(name: "type", value: "json"),
            URLQueryItem(name: "ex", value: "\(Int.random(in: 0...100000))")
        ]
        guard let url = urlComponents.url else { return }
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let incultText = json["insult"].string {
                    DispatchQueue.main.async {
                        self.incultLabel.text = "\(incultText)"
                    }
                } else {
                    print("Произошла ошибка в парсе")
                }
                
            case .failure(let fail):
                print(fail)
            }
        }
        
        
    }
    
    private func loadConsrtaints() {
        incultLabel.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(200)
            make.left.equalTo(view.snp.left).offset(30)
            make.right.equalTo(view.snp.right).offset(-30)
            make.height.equalTo(100)
        }
        incultButton.snp.remakeConstraints { make in
            make.top.equalTo(incultLabel.snp.bottom).offset(100)
            make.left.equalTo(view.snp.left).offset(30)
            make.right.equalTo(view.snp.right).offset(-30)
            make.height.equalTo(100)
        }
        
    }
    
    


}

