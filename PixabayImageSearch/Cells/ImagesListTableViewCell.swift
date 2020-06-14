//
//  ImagesListTableViewCell.swift
//  PixabayImageSearch
//
//  Created by Himanshu Sonker on 13/06/20.
//  Copyright © 2020 Pixabay Wynk. All rights reserved.
//

import UIKit

class ImagesListTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var labelImageTags: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
