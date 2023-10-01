//
//  RegionTableViewModel.swift
//  WBTest
//
//  Created by Al Stark on 30.09.2023.
//

import Foundation

final class RegionTableViewModel {
    
    var isLoading: Observable<Bool> = Observable(false)
    var dataSource: Observable<[RegionTableCellViewModel]> = Observable(nil)
    
    func numberOfSection() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        dataSource.value?.count ?? 0
    }
    
    func getData() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        RegionService.getRegions { [weak self] result in
            self?.isLoading.value = false
            switch result {
            case .success(let data):
                self?.dataSource.value = data.map({ model in
                    let cellViewModel = RegionTableCellViewModel(model: model, onTap: { })
                    cellViewModel.onTap = {
                        cellViewModel.toggleLike()
                    }
                    return cellViewModel
                })
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
