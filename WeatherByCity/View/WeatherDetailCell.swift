//
//  WeatherDetailCell.swift
//  WeatherByCity
//
//  Created by richard oh on 2019/08/03.
//  Copyright © 2019 richard oh. All rights reserved.
//

import UIKit

class WeatherDetailCell: UITableViewCell {
    
    static let cellId = "WeatherDetailCell"
    
    // 왼쪽 카테고리 레이블
    let leftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    // 왼쪽 데이터 텍스트 레이블
    let leftTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "-"
        label.textColor = .black
        return label
    }()
    
    // 오른쪽 카테고리 레이블
    let rightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    // 오른쪽 데이터 텍스트 레이블
    let rightTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "-"
        label.textColor = .black
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackViewForLabels = UIStackView(arrangedSubviews: [
            leftLabel,
            rightLabel,
            ])
        
        stackViewForLabels.alignment = .leading
        stackViewForLabels.distribution = .fillEqually
        
        let stackViewForTextLabels = UIStackView(arrangedSubviews: [
            leftTextLabel,
            rightTextLabel,
            ])
        
        stackViewForTextLabels.alignment = .leading
        stackViewForTextLabels.distribution = .fillEqually
        
        let stackViewForAll = UIStackView(arrangedSubviews: [
            stackViewForLabels,
            stackViewForTextLabels
            ])
        
        stackViewForAll.axis = .vertical
        stackViewForAll.distribution = .fillProportionally
        
        addSubview(stackViewForAll)
        stackViewForAll.translatesAutoresizingMaskIntoConstraints = false
        stackViewForAll.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        stackViewForAll.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        stackViewForAll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 12).isActive = true
        stackViewForAll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
