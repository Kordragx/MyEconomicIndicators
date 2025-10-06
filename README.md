# 💹 MyEconomicIndicators

Aplicación iOS desarrollada en **SwiftUI** bajo arquitectura **MVVM**, que permite visualizar los indicadores económicos (USD, EUR, CLP, etc.) consumiendo la API pública de [ExchangeRate.host](https://exchangerate.host/documentation).  
Incluye flujos de **login y registro**, persistencia local mediante **capa de caché**, y consumo de datos **REST/JSON** con `URLSession`.

---

## 📁 Estructura del Proyecto
  ```

  MyEconomicIndicators/
├── App/
│   ├── MyEconomicIndicatorsApp.swift       # Punto de entrada principal (@main)
│   └── Config/
│       └── Debug/                          # Environment - ApiKey
│
├── Core/
│   ├── Network/                            # Implementación de llamadas HTTP y endpoints
│   ├── Security/                           # Manejo de autenticación y llaves
│   ├── Utils/                              # Extensiones, constantes y helpers globales
│
├── Data/
│   ├── Models/                             # Entidades de datos (Auth, Indicators)
│   │   ├── Auth/
│   │   └── Indicators/
│   └── Persistence/                        # Almacenamiento local y cache
│       ├── Cache/
│       └── Persistence/
│
├── Domain/
│   ├── Auth/                               # Casos de uso de autenticación
│   │   ├── Error/
│   │   ├── Repositories/
│   │   ├── States/
│   │   └── UseCase/
│   │       ├── Login/
│   │       └── Register/
│   ├── Indicators/                         # Casos de Indicadores diario e historial
│   │   └── UseCases/
│
├── Presentation/                           # Separados por Features
│   ├── Auth/
│   │   ├── Login/
│   │   │   ├── View/
│   │   │   └── ViewModel/
│   │   └── Register/
│   │       ├── View/
│   │       └── ViewModel/
│   ├── Dashboard/
│   │   ├── View/
│   │   └── ViewModel/
│   └── Indicators/
│       ├── View/
│       └── ViewModel/
│
├── Resources/
│   ├── Preview Content/
│   ├── Assets/
│   ├── Samples/                            # Mock data (ExchangeRates)
│   └── Localizable.strings
│
└── Shared/
    └── UI/                                 # Componentes reutilizables de interfaz


  ```
---

## 🧱 Arquitectura

El proyecto sigue el patrón **Model-View-ViewModel (MVVM)**:

- **Model:** define las entidades del dominio (`DailyRate`, `User`, etc.)
- **ViewModel:** contiene la lógica de negocio y estado (ej. `DashboardViewModel`)
- **View:** representa la interfaz en **SwiftUI**, observando el estado del ViewModel con `@StateObject` o `@ObservedObject`

Cada **feature** se encuentra modularizada en su propio directorio dentro de `Features/`, lo que permite escalar fácilmente el proyecto agregando nuevas pantallas.

---

## 🌐 API REST

Se utiliza la API gratuita [ExchangeRate.host](https://exchangerate.host/documentation)

- **Base URL:** `https://api.exchangerate.host/`
- **Formato de respuesta:** `application/json`
- Ejemplo de endpoint utilizado:
  ```
  https://api.exchangerate.host/live?source=CLP&currencies=USD,EUR
  ```

La capa de red está implementada con **URLSession** y tipos `Codable`

---

## 💾 Capa de Caché

La capa de caché permite almacenar temporalmente las respuestas de la API para mejorar rendimiento y reducir peticiones innecesarias.

**Flujo de funcionamiento:**
1. Al iniciar el `DashboardViewModel`, se consulta el `CacheManager`.
2. Si existe una respuesta válida en caché, se utiliza.
3. Si no, se hace la solicitud HTTP y se guarda el resultado en caché.

Ejemplo:

```swift
    let cacheKey = "daily"

    if let cached = cacheIndicators.get(cacheKey) {
        return cached
    }
    if let diskCached = diskCacheIndicators.load(for: cacheKey) {
        cacheIndicators.set(cacheKey, value: diskCached)
        return diskCached
    }

    let raw: ExchangeResponse = try await api.request(IndicatorEndpoint.daily)

    let indicators: [Indicator] = CurrencyPair.allCases.compactMap { pair in
        guard let value = raw.quotes[pair.rawValue] else { return nil }
        return Indicator(pair: pair, rawValue: value)
    }

    cacheIndicators.set(cacheKey, value: indicators)
    diskCacheIndicators.save(indicators, for: cacheKey)
```

---

## 🔐 Autenticación

El proyecto incluye flujos de **Login** y **Registro**:
- Validación de email y contraseña.
- Persistencia de sesión local.
- Manejo básico de errores (credenciales inválidas, usuario no registrado, etc.)
- Al autenticarse, se guarda el usuario en `Keychain`.

---

## 🚀 Ejecución del Proyecto

1. Clonar el repositorio  
   ```bash
   git clone https://github.com/Kordragx/MyEconomicIndicators.git
   cd MyEconomicIndicators
   ```

2. Abrir el proyecto en **Xcode 15+**  
   ```bash
   open MyEconomicIndicators.xcodeproj
   ```

3. Compilar y ejecutar en el simulador o dispositivo iOS.

> 💡 No requiere **CocoaPods** ni **Swift Package Manager**.  
> Todas las dependencias son nativas del SDK de Apple.

---

## 🧪 Tests

- Se incluyen pruebas unitarias para ViewModels, servicios y capa de caché.  
- Framework: **XCTest**

---

## 🧭 Principales Características

✅ Arquitectura **MVVM**  
✅ Interfaz con **SwiftUI** (sin UIKit, sin AppDelegate/SceneDelegate)  
✅ Llamadas **API REST** con `URLSession`  
✅ **Login** y **Registro** de usuario  
✅ **Caché local** para indicadores  
✅ Manejo de errores y estados (`idle`, `loading`, `success`, `failure`)  
✅ 100% nativo — sin CocoaPods ni SPM  

---

## 📄 Licencia

```
MIT License © 2025 Daniel Nuñez
```
