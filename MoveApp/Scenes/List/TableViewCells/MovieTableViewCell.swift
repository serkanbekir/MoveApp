//
//  MovieTableViewCell.swift
//  MoveApp
//
//  Created by Serkan Bekir on 7.02.2021.
//

import UIKit
import AlamofireImage

class MovieTableViewCell: UITableViewCell {

    static let cellIdentifier = "MovieTableViewCell"

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configure(with model: MovieUIModel) {
        if let url = URL(string: model.imageUrl) {
            movieImageView.af.setImage(withURL: url)
        }
        movieTitleLabel.text = model.title
        movieYearLabel.text = model.year
        typeLabel.text = model.type
    }
}
