//
//  DashboardViewPreviewWrapper.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//


import SwiftUI

struct DashboardViewPreviewWrapper: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var response: ExchangeRateResponse?

    var body: some View {
        DashboardView()
            .onAppear {
                if let data = loadMockExchangeData() {
                    response = try? JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                    viewModel.loadData(from: data)
                }
            }
    }

    private func loadMockExchangeData() -> Data? {
        let json = """
        {
            "success": true,
            "source": "CLP",
            "start_date": "2025-01-01",
            "end_date": "2025-01-05",
            "quotes": {
                "2025-01-01": {
                    "CLPUSD": 0.001006,
                    "CLPEUR": 0.000971
                },
                "2025-01-02": {
                    "CLPUSD": 0.000996,
                    "CLPEUR": 0.00097
                },
                "2025-01-03": {
                    "CLPUSD": 0.000985,
                    "CLPEUR": 0.000955
                },
                "2025-01-04": {
                    "CLPUSD": 0.000983,
                    "CLPEUR": 0.000953
                },
                "2025-01-05": {
                    "CLPUSD": 0.000983,
                    "CLPEUR": 0.000954
                }
            }
        }
        """
        return json.data(using: .utf8)
    }
}
