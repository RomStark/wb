//
//  RegionTableModel.swift
//  WBTest
//
//  Created by Al Stark on 30.09.2023.
//

import Foundation

struct RegionsTableModel: Codable {
    let brands: [RegionTableModel]
}

struct RegionTableModel: Codable {
    let brandID, title: String
    let thumbUrls: [String]
    let tagIDS: [String]
    let slug, type: String
    let viewsCount: Int

    enum CodingKeys: String, CodingKey {
        case brandID = "brandId"
        case title, thumbUrls
        case tagIDS = "tagIds"
        case slug, type, viewsCount
    }
}

class RegionTableCellViewModel {
    var title: String
    var imageUrl: URL?
    var isLiked: Observable<Bool>
    var viewsCount: Int
    var viewsCountString: String  {
        get {
            "Количество просмотров: \(viewsCount)"
        }
    }
    var onTap: () -> ()
    
    init(model: RegionTableModel, onTap: @escaping () -> ()) {
        self.title = model.title
        self.viewsCount = model.viewsCount
        self.isLiked = Observable(false)
        self.imageUrl = URL(string: model.thumbUrls[0])
        self.onTap = onTap
    }
    
    func toggleLike() {
        isLiked.value?.toggle()
    }
}
