# Capítulo IV: Product Architecture Design
## 4.1 Desing Concepts, ViewPoints & ER Diagrams
### 4.1.1 Principles Statements
### 4.1.2 Approaches Statements Architectural Styles & Patterns
### 4.1.3 Context Diagram
### 4.1.4 Approach driven ViewPoints Diagrams
### 4.1.5 Relational/Non Relational Database Diagram
### 4.1.6 Design Patterns
### 4.1.7 Tactics

## 4.2 Architectural Drivers
### 4.1.8 Design Purpose
### 4.1.9 Primary Functionality (Primary User Stories)
### 4.1.10 Quality Attribute Scenarios
### 4.1.11 Constraints
### 4.1.12 Architectural Concerns

## 4.3 ADD Iterations
### 4.3.1 Iteration 1: Establishing Overall Architectural Structure and Container Decomposition  
#### 4.3.2.2 Architectural Design Backlog 1

El backlog inicial de diseño arquitectónico reúne las historias de usuario primarias, restricciones de proyecto y preocupaciones clave que condicionan la estructura global de ICHU:
•	Historias de Usuario Primarias (Primary User Stories): 
•	US-01: Registrar cuenta de unidad productiva ganadera.
•	US-06: Registrar un animal dentro del hato ganadero.
•	US-13: Consultar telemetría biométrica y de ubicación reciente de un animal.
•	US-16: Recibir alerta automática por anomalía de salud (temperatura/actividad).
•	TS-01: Capturar biometría y ubicación GPS en la banda/collar inteligente.
•	TS-04: Recibir telemetría en la pasarela de borde (Portable Edge Gateway).
•	TS-07: Validar y persistir telemetría en la API RESTful central de la nube.
•	Restricciones de Arquitectura (Constraints): 
•	CON-01: Operación en zonas ganaderas rurales con conectividad celular intermitente o nula (Sierras de Apurímac, Cusco y Puno).
•	CON-02: Despliegue distribuido físicamente entre dispositivos en predio (Borde) y servicios centralizados (Nube).
•	CON-03: Equipo de desarrollo reducido (6 integrantes) con un ciclo de entrega acotado.
•	Preocupaciones Arquitectónicas (Architectural Concerns): 
•	CRN-01: Aplicar el enfoque Domain-Driven Design (DDD) para delimitar las fronteras de dominio mediante Contextos Acotados (Bounded Contexts).

#### 4.3.3.3 Establish Iteration Goal by Selecting Drivers
El objetivo de la Iteración 1 es establecer la estructura arquitectónica de alto nivel y la descomposición en contenedores del sistema ICHU para garantizar la comunicación fluida entre clientes móviles/web, 
dispositivos IoT de campo y el backend central.
Drivers seleccionados: US-01, US-06, US-16, TS-01, TS-04, CON-01, CON-02, CON-03.
 C4 falta
#### 4.3.4.3 Choose One or More Elements of the System to Refine
Se selecciona el sistema completo ICHU Software System como elemento global a descomponer en contenedores y subsistemas.

#### 4.3.5.5 Choose One or More Design Concepts That Satisfy the Selected Drivers
• Estilo Arquitectónico General: Arquitectura distribuida basada en Edge Computing + Cloud Computing, organizada en capas para separar la adquisición y procesamiento local de telemetría de los servicios centralizados en la nube.

• Patrón de Backend Central: Arquitectura de Microservicios. El backend estará compuesto por servicios independientes organizados de acuerdo con las principales capacidades del dominio de ICHU. Cada microservicio tendrá una responsabilidad específica y podrá evolucionar, desplegarse y escalarse de manera independiente. La comunicación entre los servicios se realizará mediante APIs REST sobre HTTPS y mecanismos de mensajería cuando sea necesario.

• Patrón de Clientes: Aplicación móvil multiplataforma con enfoque Offline-First y Aplicación Web Administrativa. La aplicación móvil permitirá a los operarios y veterinarios consultar y registrar información incluso ante una conectividad limitada, sincronizando posteriormente los datos con los servicios de la nube.

• Patrón de comunicación Edge–Cloud: Sincronización asíncrona de datos entre el Portable Edge Gateway y los servicios de la nube. El Edge Gateway almacenará temporalmente la telemetría cuando no exista conectividad y realizará la sincronización cuando se restablezca la comunicación.

• Persistencia: Cada microservicio será responsable de la persistencia de los datos correspondientes a su contexto de dominio, siguiendo el principio de Database per Service para reducir el acoplamiento entre servicios.

#### 4.3.6.6 Instantiate Architectural Elements, Allocate Responsibilities, and Define Interfaces

Se instancian los siguientes contenedores principales dentro de la arquitectura de ICHU:
•	1. Cattle Band Embedded Application (ESP32 / C++): Captura continua de temperatura corporal, acelerometría de actividad y posición GPS. Transmite datos localmente mediante Bluetooth Low Energy (BLE) o Wi-Fi local.
•	2. Portable Edge Gateway (Python / Flask / SQLite): Servicio desplegado en la pasarela portátil del predio; almacena lecturas locales, evalúa reglas críticas sin conexión y sincroniza lotes hacia la nube cuando detecta conectividad.
•	3. ICHU Modular Monolith (ASP.NET Core / .NET 8): Backend central en la nube que alberga los servicios de negocio agrupados en módulos independientes expuestos mediante RESTful API sobre HTTPS/JSON.
•	4. Mobile Application (Flutter / Dart): Aplicación móvil para operarios y veterinarios que permite visualización de mapas, registro de ganado y gestión de alertas locales/remotas.
•	5. Web Application (Angular / TypeScript): Panel web administrativo para la gestión integral de hatos, configuración de geocercas, analítica avanzada y reportes ejecutivos.
•	6. ICHU Cloud Database (PostgreSQL 16): Base de datos relacional central con esquemas aislados por cada contexto acotado.

| Driver                            | Decisión arquitectónica                         | Justificación                                                                                         |
| --------------------------------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| CON-01: Conectividad intermitente | Edge Computing + almacenamiento local           | Permite continuar capturando y procesando datos sin conexión                                          |
| CON-02: Distribución física       | Edge + Cloud                                    | Separa procesamiento local de servicios centralizados                                                 |
| CON-03: Equipo de desarrollo      | Microservicios con límites de dominio definidos | Permite distribuir responsabilidades entre los integrantes y evolucionar servicios independientemente |
| TS-01: Captura de telemetría      | Cattle Band + Edge Gateway                      | Permite capturar y recibir datos localmente                                                           |
| TS-04: Recepción de telemetría    | Edge Gateway                                    | Centraliza la recepción de datos de los dispositivos                                                  |
| TS-07: Persistencia en Cloud      | Microservicio de Telemetría                     | Valida y persiste los datos recibidos desde Edge                                                      |
| US-16: Alertas                    | Health/Alert Microservices                      | Permite procesar anomalías y generar alertas                                                          |


#### 4.3.7.7 Sketch Views (C4 & UML) and Record Design Decisions
• C4 System Context Diagram: Define las fronteras entre los actores (Administrador, Operario, Veterinario), el sistema ICHU y los servicios externos (Firebase, Pasarela de Pagos, Google Maps).
• C4 Container Diagram: Detalla los 9 contenedores del sistema y sus protocolos de comunicación (REST/HTTPS, BLE, Wi-Fi local, TCP/IP).

![Diagrama C4 de ICHU](./images/diagrams/c4/c4-container.png)
![Diagrama C4 de ICHU](./images/diagrams/c4/c4-container-key.png)


#### 4.3.8.8 Analysis of Current Design and Review Iteration Goal (Kanban Board)
Análisis de Cobertura: La descomposición en contenedores satisface las restricciones de conectividad rural (CON-01) y la capacidad operativa del equipo (CON-03) mediante el uso de la pasarela de borde y el backend modular.

Estado en Tablero Kanban:

•	[DONE]: Definición de Contenedores C4, Selección de Stack (.NET 8, Flutter, Angular, Python, PostgreSQL).  
•	[IN PROGRESS]: Diseño de canales de sincronización asíncrona entre el Borde y la Nube.  
•	[TO DO]: Refinamiento de atributos de calidad de latencia y disponibilidad en el Borde.
