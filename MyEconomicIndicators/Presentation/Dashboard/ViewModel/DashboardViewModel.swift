//
//  DashboardViewModel.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var state: APIState<[DailyRate]> = .idle
    @Published private(set) var rates: [DailyRate] = []
    @Published var selectedCurrency: CurrencyPair = .clpToUsd
    @Published var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @Published var endDate: Date = Date()
    
    // MARK: - Private Properties
    private var quotes: [String: [String: Double]] = [:]
    private var cancellables = Set<AnyCancellable>()
    private var task: Task<Void, Never>?
    private let useCase: FetchIndicatorsUseCase

    deinit {
           task?.cancel()
       }
    
    // MARK: - Init
    init(useCase: FetchIndicatorsUseCase = FetchIndicatorsUseCase()) {
        state = .loading

        self.useCase = useCase
        setupDateBinding()
        setupCurrencyBinding()
    }

    // MARK: - Combine Bindings
    private func setupDateBinding() {
        task?.cancel()
        Publishers.CombineLatest($startDate, $endDate)
            .removeDuplicates { lhs, rhs in
                lhs.0 == rhs.0 && lhs.1 == rhs.1
            }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] start, end in
                guard let self else { return }
                task = Task { [weak self] in
                    guard let self else { return }
                    await self.fetchQuotes(from: start, to: end)
                }
            }
            .store(in: &cancellables)
    }

    private func setupCurrencyBinding() {
        Publishers.CombineLatest($selectedCurrency.removeDuplicates(), $rates)
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { [weak self] _, _ in
                self?.filterRates()
            }
            .store(in: &cancellables)
    }

    // MARK: - Async FetchÏ
    func fetchQuotes(from startDate: Date, to endDate: Date) async {
        state = .loading
        do {
            let response = try await useCase.fetchHistory(from: startDate, to: endDate)
            quotes = response.quotes
            filterRates()
        } catch {
            state = .failure(error)
            print("❌ Error fetching history: \(error.localizedDescription)")
        }
    }

    // MARK: - Data Transformation
    private func filterRates() {

        let mappedData: [(Date, Double)] = quotes.compactMap { (dateString, currencies) in
            guard
                let date = DateUtils.dateFormatter.date(from: dateString),
                let value = currencies[selectedCurrency.rawValue]
            else {
                return nil
            }
            return (date, value)
        }

        let sortedData = mappedData.sorted { $0.0 < $1.0 }

        self.rates = sortedData.map { (date, value) in
            DailyRate(date: date, rawValue: value)
        }

        state = .success(self.rates)
    }

    // MARK: - Local JSON Loader (Preview / Offline)
    func loadData(from data: Data) {
        do {
            let response = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
            quotes = response.quotes
            filterRates()
        } catch {
            print("❌ Decoding error:", error)
        }
    }

}
