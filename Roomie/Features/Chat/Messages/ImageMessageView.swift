//
//  ImageMessageView.swift
//  Roomie
//
//  Created by Mu Yu on 2/7/21.
//

import UIKit

class ImageMessageView: UIView {
    private let imageView = UIImageView()
    
    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureViews()
        configureGestures()
        configureConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - View Config
extension ImageMessageView {
    private func configureViews() {
        addSubview(imageView)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        imageView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(Constants.imageSize.illustation)
        }
    }
}


