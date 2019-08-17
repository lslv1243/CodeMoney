//
//  PlacesSearchBar.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 16/08/19.
//  Copyright © 2019 Leonardo da Silva. All rights reserved.
//

import UIKit

protocol PlacesSearchBarDelegate: class {
  func placesSearchBar(_ searchBar: PlacesSearchBar, didUpdateDisplayingMode toMode: PlacesSearchBar.DisplayingMode)
  func placesSearchBar(_ searchBar: PlacesSearchBar, didChangeText newText: String)
}

class PlacesSearchBar: UIView, UITextFieldDelegate {
  enum DisplayingMode {
    case map, list
  }
  
  private let toggleModeButton = UIButton()
  private let textField = PlacesSearchBarTextField()
  
  weak var delegate: PlacesSearchBarDelegate?
  var displayingMode: DisplayingMode = .list {
    didSet {
      updateToggleModeButtonTitle()
      delegate?.placesSearchBar(self, didUpdateDisplayingMode: displayingMode)
    }
  }
  
  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 55))
  
    toggleModeButton.addTarget(self, action: #selector(toggleDisplayingMode), for: .touchUpInside)
    textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    textField.delegate = self
    
    addSubview(toggleModeButton)
    addSubview(textField)
    
    backgroundColor = .white
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 2.5
    layer.shadowOffset = CGSize(width: 0, height: 5)
    
    updateToggleModeButtonTitle()
    toggleModeButton.setTitleColor(.orange, for: .normal)
    toggleModeButton.titleLabel!.font = toggleModeButton.titleLabel!.font.withSize(12)
    toggleModeButton.contentHorizontalAlignment = .left
    
    
    toggleModeButton.translatesAutoresizingMaskIntoConstraints = false
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    // TODO: handle status bar height change
    // https://stackoverflow.com/questions/2944411/how-to-get-notified-when-the-status-bar-height-changes
    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
    NSLayoutConstraint.activate([
      toggleModeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18),
      toggleModeButton.heightAnchor.constraint(equalTo: textField.heightAnchor),
      toggleModeButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
      toggleModeButton.widthAnchor.constraint(equalToConstant: 40),
      
      textField.topAnchor.constraint(equalTo: self.topAnchor, constant: statusBarHeight),
      textField.leftAnchor.constraint(equalTo: toggleModeButton.rightAnchor, constant: 5),
      textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18),
      textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
    ])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func updateToggleModeButtonTitle() {
    let title: String
    switch displayingMode {
    case .map:
      title = "LISTA"
    case .list:
      title = "MAPA"
    }
    toggleModeButton.setTitle(title, for: .normal)
  }
  
  @objc private func toggleDisplayingMode() {
    switch displayingMode {
    case .map:
      displayingMode = .list
    case .list:
      displayingMode = .map
    }
  }
  
  @objc private func textFieldDidChange() {
    delegate?.placesSearchBar(self, didChangeText: textField.text!)
  }
  
  @discardableResult
  override func resignFirstResponder() -> Bool {
    return textField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    resignFirstResponder()
    return false
  }
}

fileprivate class PlacesSearchBarTextField: UITextField {
  private let searchIconImage = UIImage(named: "PlacesSearchBar.SearchIcon")!.withRenderingMode(.alwaysTemplate)
  private let clearIconImage = UIImage(named: "PlacesSearchBar.ClearIcon")!.withRenderingMode(.alwaysTemplate)
  private let rightViewButton: UIButton
  
  init() {
    rightViewButton = UIButton(frame: CGRect(origin: .zero, size: searchIconImage.size))
    
    super.init(frame: .zero)
    
    addTarget(self, action: #selector(updateRightViewButtonIcon), for: .editingChanged)
    rightViewButton.addTarget(self, action: #selector(clearField), for: .touchUpInside)
    
    returnKeyType = .search
    attributedPlaceholder = NSAttributedString(
      string: "Nome do local, cidade ou rua",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
    )
    backgroundColor = UIColor(displayP3Red: 0.85, green: 0.85, blue: 0.9, alpha: 1.0)
    layer.cornerRadius = 3
    layer.masksToBounds = true
    tintColor = .darkGray
    textColor = .darkGray
    font = font!.withSize(15)
    
    leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
    leftViewMode = .always
    updateRightViewButtonIcon()
    rightViewButton.imageView!.tintColor = .darkGray
    let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10 + rightViewButton.frame.width, height: rightViewButton.frame.height))
    rightView.addSubview(rightViewButton)
    self.rightView = rightView
    rightViewMode = .always
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func clearField() {
    guard !text!.isEmpty else { return }
    text = ""
    sendActions(for: .editingChanged)
  }
  
  @objc private func updateRightViewButtonIcon() {
    let newImage: UIImage
    if text!.isEmpty {
      newImage = searchIconImage
    } else {
      newImage = clearIconImage
    }
    if newImage !== rightViewButton.imageView!.image {
      UIView.transition(with: rightViewButton, duration: 0.2, options: .transitionFlipFromTop, animations: {
        self.rightViewButton.setImage(newImage, for: .normal)
      })
    }
  }
}
