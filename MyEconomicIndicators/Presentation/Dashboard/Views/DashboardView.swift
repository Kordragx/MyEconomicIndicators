//
//  DashboardView.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//
//

import SwiftUI
import Charts

struct DashboardView: View {
    @StateObject private var vm = DashboardViewModel()
    private let currencyOptions: [CurrencyPair] = CurrencyPair.allCases
    @State private var selectedRate: DailyRate?

    var body: some View {
        Group {
            switch vm.state {
            case .idle, .loading:
                loadingView
                
            case .success:
                contentView
                
            case .failure(let error):
                Spacer()
                errorView(error)
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        )
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView("Cargando datos...")
                .progressViewStyle(.circular)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(edges: .bottom)
        }
        
    }
    
    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 12) {
            Spacer()
            Text("Error al cargar los datos")
                .font(.headline)
                .foregroundColor(.red)
            Text(error.localizedDescription)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var contentView: some View {
        VStack(spacing: 16) {
            header
            
            datePickers
            
            currencySelector
            
            if vm.rates.isEmpty {
                Text("No hay datos disponibles.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                chartView
            }
            
            Spacer()
        }
    }
    
    private var header: some View {
        Text("Histórico de tipo de cambio")
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var datePickers: some View {
        VStack(spacing: 8) {
            DatePicker("Desde", selection: $vm.startDate, displayedComponents: [.date])
            DatePicker("Hasta", selection: $vm.endDate, displayedComponents: [.date])
        }
        .datePickerStyle(.compact)
    }
    
    private var currencySelector: some View {
        Picker("Moneda", selection: $vm.selectedCurrency) {
            ForEach(CurrencyPair.allCases) { currency in
                Text(currency.formattedName).tag(currency)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var yAxisDomain: ClosedRange<Double> {
        let values = vm.rates.map(\.value)

        // Si no hay valores, devolvemos un rango base
        guard let minValue = values.min(), let maxValue = values.max() else {
            return 0...1
        }

        // Si todos los valores son iguales
        if minValue == maxValue {
            let base = minValue
            return (base * 0.9)...(base * 1.1)
        }

        // Rango dinámico con margen del 5%
        let range = maxValue - minValue
        return (minValue - range * 0.05)...(maxValue + range * 0.05)
    }

    private var chartView: some View {
        
        Chart(vm.rates) { rate in
            LineMark(
                x: .value("Fecha", rate.date),
                y: .value("Valor", rate.value)
            )
            .foregroundStyle(.blue)
            .symbol(Circle())
            .interpolationMethod(.catmullRom)
        }
        // MARK: - Ejes
        .chartXAxis {
            AxisMarks(values: .stride(by: .month)) { value in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.month(.abbreviated))
            }
        }
        .chartYScale(domain: yAxisDomain)
        .chartYAxis {
            AxisMarks()
        }
    
        // MARK: - Interactividad
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if let date: Date = proxy.value(atX: value.location.x) {
                                    selectedRate = vm.rates.min(by: {
                                        abs($0.date.timeIntervalSince(date)) <
                                            abs($1.date.timeIntervalSince(date))
                                    })
                                }
                            }
                            .onEnded { _ in
                                selectedRate = nil
                            }
                    )
            }
        }
        // MARK: - Valor flotante
        .overlay(alignment: .topLeading) {
            if let rate = selectedRate {
                VStack(alignment: .leading, spacing: 4) {
                    Text(rate.date, format: .dateTime.day().month())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Valor: \(rate.value, specifier: "%.2f")")
                        .bold()
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .padding()
            }
        }
        .frame(height: 300)
        .padding(.top)
    }
}
