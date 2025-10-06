//
//  IndicatorsView.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import SwiftUI
import Charts

struct IndicatorsView: View {
    
    @StateObject var vm: IndicatorsViewModel
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var selectedIndicator: Indicator?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    ContentIndicators()
                        .padding(.bottom)
                    DashboardView()
                }
                .padding(.top)
                .navigationTitle("Indicadores")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cerrar sesión") {
                            isLoggedIn = false
                        }
                    }
                }
            }
           

        }
        .task {
            await vm.loadIndicators()
        }

        
    }

    @ViewBuilder
    fileprivate func ContentIndicators() -> some View {
        switch vm.state {
        case .idle, .loading:
            ProgressView("Cargando indicadores...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                )
                .padding()

        case .success:
            header

            IndicatorListView(indicators: vm.indicators) { indicator in
                selectedIndicator = indicator
            }

        case .failure(let error):
            Spacer()
            errorView(error)
            Spacer()
        }
    }

    
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Date.now.formatted(.dateTime.day().month(.wide)))
                .font(.subheadline)
                .foregroundColor(.secondary)

        }
        .padding(.horizontal, 20)
    }

    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 8) {
            Text("Error al cargar los indicadores")
                .font(.headline)
                .foregroundColor(.red)

            Text(error.localizedDescription)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .bottom)
    }
}

struct IndicatorListView: View {
    let indicators: [Indicator]
    let onSelect: (Indicator) -> Void

    var body: some View {
          VStack(spacing: 0) {
              ForEach(indicators) { indicator in
                  HStack {
                      Text(indicator.formattedName)
                          .font(.headline)
                          .foregroundColor(.primary)
                      Spacer()
                      Text("CLP \(indicator.formattedValue)")
                          .font(.subheadline)
                          .foregroundColor(.secondary)
                  }
                  .padding(.vertical, 12)
                  .padding(.horizontal, 16)
                  .contentShape(Rectangle())
                  .onTapGesture {
                      onSelect(indicator)
                  }

                  // Divider between rows
                  if indicator.id != indicators.last?.id {
                      Divider()
                          .padding(.leading, 16)
                  }
              }
          }
          .background(Color.white)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
          .padding(.horizontal)
      }
}

#Preview {
    NavigationView {
        IndicatorsView(vm: .preview)
    }
}
