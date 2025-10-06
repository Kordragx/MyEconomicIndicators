//
//  IndicatorsViewModel.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//


import Foundation

@MainActor
final class IndicatorsViewModel: ObservableObject {
    
    @Published var state: APIState<[Indicator]> = .idle
    @Published var indicators: [Indicator] = []
    
    let useCase = FetchIndicatorsUseCase()

    func loadIndicators() async {
        state = .loading
        do {
            indicators = try await useCase.fetchDailyIndicators()
            state = .success(indicators)
        } catch {
            state = .failure(error)
        }
    }
    
    func loadState()  {
        state = .loading
    }

}

extension IndicatorsViewModel {
    static let preview: IndicatorsViewModel = {
        let vm = IndicatorsViewModel()
        vm.indicators = Indicator.dummyData
        return vm
    }()
}
