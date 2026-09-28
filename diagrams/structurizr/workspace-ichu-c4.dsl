workspace "ICHU" "Modelo C4 de ICHU, la plataforma IoT de gestión ganadera de la startup SmartFarm" {

    !impliedRelationships false

    model {

        // ============================================================
        // PEOPLE
        // ============================================================

        ranchManager = person "Ranch Manager" {
            description "Propietario o administrador de la unidad productiva"
            tags "Person"
        }

        fieldOperator = person "Field Operator" {
            description "Personal que ejecuta las faenas en el potrero"
            tags "Person"
        }

        veterinarian = person "Veterinarian / Zootechnist" {
            description "Profesional que asesora hatos que no administra"
            tags "Person"
        }

        visitor = person "Prospective Customer" {
            description "Visitante del sitio público que evalúa la plataforma"
            tags "Visitor"
        }


        // ============================================================
        // EXTERNAL HARDWARE
        // ============================================================

        cattleBandHardware = softwareSystem "Cattle Band Hardware" {
            description "Collar ESP32 con temperatura, acelerómetro, GPS, Wi-Fi y BLE"
            tags "External,Hardware"
        }

        waterControllerHardware = softwareSystem "Water Temperature Controller Hardware" {
            description "Controlador ESP32 con sensor de agua y actuador de calentamiento"
            tags "External,Hardware"
        }


        // ============================================================
        // EXTERNAL CLOUD SERVICES
        // ============================================================

        firebaseAuth = softwareSystem "Firebase Authentication" {
            description "Servicio externo de autenticación de usuarios"
            tags "External"
        }

        firebaseMessaging = softwareSystem "Firebase Cloud Messaging" {
            description "Servicio externo de notificaciones push"
            tags "External"
        }

        mapProvider = softwareSystem "Map Provider" {
            description "Servicio externo de mapas y geocercas"
            tags "External"
        }

        paymentProvider = softwareSystem "Payment Provider" {
            description "Pasarela externa de pagos de suscripción"
            tags "External"
        }


        // ============================================================
        // SMARTFARM SOFTWARE SYSTEM
        // ============================================================

        ichu = softwareSystem "ICHU" {
            description "Plataforma IoT de gestión ganadera"


            // ========================================================
            // LANDING PAGE
            // ========================================================

            landingPage = container "Landing Page" {
                technology "HTML5 + CSS3 + JavaScript"
                description "Sitio público con la propuesta de valor y los planes"
                tags "Web"
            }


            // ========================================================
            // WEB APPLICATION
            // ========================================================

            webApplication = container "Web Application" {
                technology "Angular + TypeScript"
                description "Gestión del hato, dispositivos, planificación y analítica"
                tags "Web"
            }


            // ========================================================
            // MOBILE APPLICATION
            // ========================================================

            mobileApplication = container "Mobile Application" {
                technology "Flutter + Dart"
                description "Monitoreo, alertas y operación de campo sin cobertura"
                tags "Mobile"
            }


            // ========================================================
            // CATTLE BAND EMBEDDED APPLICATION
            // ========================================================

            cattleBandEmbeddedApp = container "Cattle Band Embedded Application" {
                technology "C++ on ESP32"
                description "Firmware del collar: captura y transmisión de telemetría"
                tags "IoT"


                bandTelemetryInterface = component "Band Telemetry Interface" {
                    technology "C++"
                    description "Interfaz de arranque del ciclo de captura"
                    tags "Interface"
                }

                bandTelemetryService = component "Band Telemetry Service" {
                    technology "C++"
                    description "Servicio de aplicación que coordina la captura"
                    tags "Application"
                }

                bandConnectivityService = component "Band Connectivity Service" {
                    technology "C++"
                    description "Servicio de aplicación que elige Wi-Fi o BLE"
                    tags "Application"
                }

                cattleBandDevice = component "Cattle Band Aggregate" {
                    technology "C++"
                    description "Agregado del estado del collar"
                    tags "DomainAggregate"
                }

                cattleTelemetryProcessor = component "Cattle Telemetry Processor" {
                    technology "C++"
                    description "Servicio de dominio que normaliza las lecturas"
                    tags "DomainService"
                }

                cattleBandHAL = component "Cattle Band HAL" {
                    technology "C++"
                    description "Capa de abstracción del hardware del collar"
                    tags "Infrastructure"
                }

                cattleBandHardwareACL = component "Cattle Band Hardware ACL" {
                    technology "C++"
                    description "ACL hacia los controladores del fabricante"
                    tags "Infrastructure,ACL"
                }

                cattleBandLocalBuffer = component "Cattle Band Local Buffer" {
                    technology "ESP32 Flash / NVS"
                    description "Memoria local para lecturas no transmitidas"
                    tags "Infrastructure"
                }

                bandCloudAdapter = component "Band Cloud Adapter" {
                    technology "C++ / HTTPS"
                    description "Adaptador de envío directo al backend"
                    tags "Infrastructure"
                }

                bandBleAdapter = component "Band BLE Adapter" {
                    technology "C++ / Bluetooth Low Energy"
                    description "Adaptador de envío por Bluetooth Low Energy"
                    tags "Infrastructure"
                }
            }


            // ========================================================
            // WATER TEMPERATURE CONTROLLER
            // ========================================================

            waterControllerEmbeddedApp = container "Water Controller Embedded Application" {
                technology "C++ on ESP32"
                description "Firmware del abrevadero: medición y calentamiento del agua"
                tags "IoT"


                waterControlInterface = component "Water Control Interface" {
                    technology "C++"
                    description "Interfaz de arranque del ciclo de medición"
                    tags "Interface"
                }

                waterControlService = component "Water Control Application Service" {
                    technology "C++"
                    description "Servicio de aplicación que coordina la medición"
                    tags "Application"
                }

                waterControllerDevice = component "Water Controller Aggregate" {
                    technology "C++"
                    description "Agregado del estado del controlador"
                    tags "DomainAggregate"
                }

                temperatureRegulationService = component "Temperature Regulation Service" {
                    technology "C++"
                    description "Servicio de dominio que decide el accionamiento"
                    tags "DomainService"
                }

                waterControllerHAL = component "Water Controller HAL" {
                    technology "C++"
                    description "Capa de abstracción del hardware del controlador"
                    tags "Infrastructure"
                }

                waterHardwareACL = component "Water Controller Hardware ACL" {
                    technology "C++"
                    description "ACL hacia los controladores del fabricante"
                    tags "Infrastructure,ACL"
                }

                waterLocalBuffer = component "Water Controller Local Buffer" {
                    technology "ESP32 Flash / NVS"
                    description "Memoria local para lecturas no transmitidas"
                    tags "Infrastructure"
                }

                waterCloudAdapter = component "Water Cloud Adapter" {
                    technology "C++ / HTTPS"
                    description "Adaptador de envío al backend"
                    tags "Infrastructure"
                }
            }


            // ========================================================
            // PORTABLE EDGE GATEWAY
            // ========================================================

            edgeGateway = container "Portable Edge Gateway" {
                technology "Flask + Peewee ORM on Python, running on Raspberry Pi or similar Edge Device"
                description "Pasarela portátil que opera sin Internet y sincroniza después"
                tags "Edge"


                bleDeviceInterface = component "BLE Device Interface" {
                    technology "Python + Bluetooth Low Energy"
                    description "Interfaz de descubrimiento y recepción por BLE"
                    tags "Interface"
                }

                edgeTelemetryService = component "Edge Telemetry Collection Service" {
                    technology "Python"
                    description "Servicio de aplicación que recibe de varios collares"
                    tags "Application"
                }

                edgeSyncOrchestrator = component "Edge Sync Orchestrator" {
                    technology "Python"
                    description "Servicio de aplicación que sincroniza con la nube"
                    tags "Application"
                }

                edgeTelemetry = component "Edge Telemetry Aggregate" {
                    technology "Python"
                    description "Agregado de la telemetría local y su estado de sincronización"
                    tags "DomainAggregate"
                }

                edgeMonitoringService = component "Local Monitoring Service" {
                    technology "Python"
                    description "Servicio de dominio que evalúa umbrales sin Internet"
                    tags "DomainService"
                }

                edgeRepository = component "Edge Repository" {
                    technology "Peewee ORM + SQLite"
                    description "Repositorio local sobre SQLite"
                    tags "Infrastructure"
                }

                cloudApiACL = component "ICHU Cloud API ACL" {
                    technology "Python"
                    description "ACL hacia el API central"
                    tags "Infrastructure,ACL"
                }

                localAlertAdapter = component "Local Alert Adapter" {
                    technology "Python"
                    description "Adaptador de alertas locales a la app movil"
                    tags "Infrastructure"
                }
            }


            // ========================================================
            // EDGE DATABASE
            // ========================================================

            edgeDatabase = container "Edge Database" {
                technology "SQLite"
                description "Base local del borde con telemetría y configuración en caché"
                tags "Database,Edge"
            }


            // ========================================================
            // SMARTFARM MODULAR MONOLITH
            // ========================================================

            backend = container "ICHU Modular Monolith" {
                technology ".NET 8 + ASP.NET Core Web API"
                description "Backend en la nube con los contextos acotados como módulos"
                tags "Monolith,API"


                // ====================================================
                // IDENTITY & ACCESS
                // ====================================================

                identityAPI = component "Identity & Profile API" {
                    technology "ASP.NET Core Controllers"
                    description "Interfaz de cuentas, perfiles y asesorías"
                    tags "Interface,IAM"
                }

                identityService = component "Identity & Profile Application Service" {
                    technology ".NET"
                    description "Servicio de aplicación de identidad y acceso"
                    tags "Application,IAM"
                }

                userAccount = component "User Account Aggregate" {
                    technology ".NET"
                    description "Agregado de la cuenta de usuario"
                    tags "DomainAggregate,IAM"
                }

                authorizationService = component "Authorization Domain Service" {
                    technology ".NET"
                    description "Servicio de dominio que resuelve el alcance de acceso"
                    tags "DomainService,IAM"
                }

                identityRepository = component "Identity Repository" {
                    technology ".NET + Entity Framework Core"
                    description "Repositorio del esquema iam"
                    tags "Infrastructure,IAM"
                }

                firebaseAuthACL = component "Firebase Authentication ACL" {
                    technology ".NET + Entity Framework Core"
                    description "ACL hacia el proveedor de autenticación"
                    tags "Infrastructure,ACL,IAM"
                }


                // ====================================================
                // CATTLE INFORMATION
                // ====================================================

                cattleAPI = component "Cattle Information API" {
                    technology "ASP.NET Core Controllers"
                    description "Interfaz de fichas de animales y lotes"
                    tags "Interface,Cattle"
                }

                cattleApplicationService = component "Cattle Application Service" {
                    technology ".NET"
                    description "Servicio de aplicación de información del ganado"
                    tags "Application,Cattle"
                }

                cattle = component "Cattle Aggregate" {
                    technology ".NET"
                    description "Agregado del animal y su ciclo de vida"
                    tags "DomainAggregate,Cattle"
                }

                cattleRepository = component "Cattle Repository" {
                    technology ".NET + Entity Framework Core"
                    description "Repositorio del esquema cattle"
                    tags "Infrastructure,Cattle"
                }


                // ====================================================
                // IOT ASSETS
                // ====================================================

                iotAssetsAPI = component "IoT Assets API" {
                    technology "ASP.NET Core Controllers"
                    description "Interfaz de inventario y asignación de dispositivos"
                    tags "Interface,IoTAssets"
                }

                iotAssetsApplicationService = component "IoT Assets Application Service" {
                    technology ".NET"
                    description "Servicio de aplicación de activos IoT"
                    tags "Application,IoTAssets"
                }

                iotDevice = component "IoT Device Aggregate" {
                    technology ".NET"
                    description "Agregado del dispositivo y su asignación vigente"
                    tags "DomainAggregate,IoTAssets"
                }

                deviceAssignmentService = component "Device Assignment Domain Service" {
                    technology ".NET"
                    description "Servicio de dominio que valida el límite del plan"
                    tags "DomainService,IoTAssets"
                }

                subscriptionEntitlementACL = component "Subscription Entitlement ACL" {
                    technology ".NET"
                    description "ACL hacia Subscription Plans"
                    tags "Infrastructure,ACL,IoTAssets"
                }

                cattleAssignmentACL = component "Cattle Assignment ACL" {
                    technology ".NET"
                    description "ACL hacia Cattle Information"
                    tags "Infrastructure,ACL,IoTAssets"
                }

                iotAssetsRepository = component "IoT Assets Repository" {
                    technology ".NET + Entity Framework Core"
                    description "Repositorio del esquema iot"
                    tags "Infrastructure,IoTAssets"
                }


                // ====================================================
                // OPERATIONS & MONITORING
                // ====================================================

                telemetryAPI = component "Telemetry API" {
                    technology "ASP.NET Core Controllers"
                    description "Interfaz de ingesta y consulta de telemetría"
                    tags "Interface,Monitoring"
                }

                operationsAPI = component "Operations API" {
                    technology "ASP.NET Core Controllers"
                    description "Interfaz de eventos de campo e intervenciones clínicas"
                    tags "Interface,Monitoring"
                }

                edgeConfigurationAPI = component "Edge Configuration API" {
                    technology "ASP.NET Core Controllers"
                    description "Interfaz de configuración y sincronización del borde"
                    tags "Interface,Monitoring"
                }

                telemetryIngestionService = component "Telemetry Ingestion Service" {
                    technology ".NET"
                    description "Servicio de aplicación que valida y persiste lecturas"
                    tags "Application,Monitoring"
                }

                operationsApplicationService = component "Operations Application Service" {
                    technology ".NET"
                    description "Servicio de aplicación de alertas y operaciones"
                    tags "Application,Monitoring"
                }

                edgeConfigurationService = component "Edge Configuration Service" {
                    technology ".NET"
                    description "Servicio de aplicación que entrega umbrales y geocercas"
                    tags "Application,Monitoring"
                }

                monitoringAggregate = component "Monitoring Aggregate" {
                    technology ".NET"
                    description "Agregado de la alerta y su regla de deduplicación"
                    tags "DomainAggregate,Monitoring"
                }

                livestockOperation = component "Livestock Operation Aggregate" {
                    technology ".NET"
                    description "Agregado del evento de campo y la intervencion clínica"
                    tags "DomainAggregate,Monitoring"
                }

                monitoringRulesService = component "Monitoring Rules Domain Service" {
                    technology ".NET"
                    description "Servicio de dominio que evalúa umbrales y geocercas"
                    tags "DomainService,Monitoring"
                }

                deviceRegistryACL = component "IoT Assets Lookup ACL" {
                    technology ".NET"
                    description "ACL hacia IoT Assets"
                    tags "Infrastructure,ACL,Monitoring"
                }

                cattleLookupACL = component "Cattle Lookup ACL" {
                    technology ".NET"
                    description "ACL hacia Cattle Information"
                    tags "Infrastructure,ACL,Monitoring"
                }

                monitoringRepository = component "Monitoring Repository" {
                    technology ".NET + Entity Framework Core"
                    description "Repositorio del esquema monitoring"
                    tags "Infrastructure,Monitoring"
                }


                // ====================================================
                // PLANNING
                // ====================================================

                planningAPI = component "Planning API" {
                    technology "ASP.NET Core Controllers"
                    description "Interfaz de campañas, recordatorios y retiros"
                    tags "Interface,Planning"
                }

                planningApplicationService = component "Planning Application Service" {
                    technology ".NET"
                    description "Servicio de aplicación del calendario ganadero"
                    tags "Application,Planning"
                }

                livestockCalendar = component "Livestock Calendar Aggregate" {
                    technology ".NET"
                    description "Agregado del calendario y sus campañas sanitarias"
                    tags "DomainAggregate,Planning"
                }

                reminderService = component "Reminder Domain Service" {
                    technology ".NET"
                    description "Servicio de dominio que emite los recordatorios"
                    tags "DomainService,Planning"
                }

                planningRepository = component "Planning Repository" {
                    technology ".NET + Entity Framework Core"
                    description "Repositorio del esquema planning"
                    tags "Infrastructure,Planning"
                }


                // ====================================================
                // DASHBOARD & ANALYTICS
                // ====================================================

                analyticsAPI = component "Dashboard & Analytics API" {
                    technology "ASP.NET Core Controllers"
                    description "Interfaz de indicadores, tendencias y reportes"
                    tags "Interface,Analytics"
                }

                analyticsApplicationService = component "Analytics Application Service" {
                    technology ".NET"
                    description "Servicio de aplicación de analítica"
                    tags "Application,Analytics"
                }

                analyticsService = component "Analytics Domain Service" {
                    technology ".NET"
                    description "Servicio de dominio que calcula indicadores y curvas"
                    tags "DomainService,Analytics"
                }

                analyticsRepository = component "Analytics Repository" {
                    technology ".NET + Entity Framework Core"
                    description "Repositorio de solo lectura sobre los esquemas de origen"
                    tags "Infrastructure,Analytics"
                }


                // ====================================================
                // SUBSCRIPTIONS & BILLING
                // ====================================================

                subscriptionAPI = component "Subscription API" {
                    technology "ASP.NET Core Controllers"
                    description "Interfaz de planes y suscripciones"
                    tags "Interface,Subscription"
                }

                billingAPI = component "Billing API" {
                    technology "ASP.NET Core Controllers"
                    description "Interfaz de pagos y facturación"
                    tags "Interface,Subscription"
                }

                subscriptionApplicationService = component "Subscription Application Service" {
                    technology ".NET"
                    description "Servicio de aplicación de suscripciones"
                    tags "Application,Subscription"
                }

                paymentApplicationService = component "Payment Application Service" {
                    technology ".NET"
                    description "Servicio de aplicación de cobros"
                    tags "Application,Subscription"
                }

                subscription = component "Subscription Aggregate" {
                    technology ".NET"
                    description "Agregado de la suscripción y su cobertura"
                    tags "DomainAggregate,Subscription"
                }

                subscriptionRepository = component "Subscription Repository" {
                    technology ".NET + Entity Framework Core"
                    description "Repositorio del esquema subscription"
                    tags "Infrastructure,Subscription"
                }

                paymentProviderACL = component "Payment Provider ACL" {
                    technology ".NET"
                    description "ACL hacia la pasarela de pagos"
                    tags "Infrastructure,ACL,Subscription"
                }


                // ====================================================
                // SHARED INFRASTRUCTURE
                // ====================================================

                domainEventDispatcher = component "Internal Domain Event Dispatcher" {
                    technology ".NET Domain Events"
                    description "Publica eventos de dominio entre módulos del monolito"
                    tags "Infrastructure"
                }

                notificationAdapter = component "Firebase Messaging Adapter" {
                    technology ".NET + Entity Framework Core"
                    description "Adaptador hacia el servicio de notificaciones push"
                    tags "Infrastructure,ACL"
                }
            }


            // ========================================================
            // SINGLE CLOUD DATABASE
            // ========================================================

            cloudDatabase = container "ICHU Cloud Database" {
                technology "PostgreSQL 16"
                description "Base relacional con un esquema por contexto acotado"
                tags "Database"
            }
        }


        // ============================================================
        // SYSTEM CONTEXT RELATIONSHIPS
        // IMPORTANT: DIRECT RELATIONSHIPS TO SMARTFARM
        // ============================================================

        ranchManager -> ichu "Gestiona hato, dispositivos, planificación y suscripción"

        fieldOperator -> ichu "Supervisa el hato y registra faenas"

        veterinarian -> ichu "Revisa salud e historial autorizados"

        visitor -> ichu "Consulta la propuesta y los planes"

        cattleBandHardware -> ichu "Aporta temperatura, movimiento y posición"

        waterControllerHardware -> ichu "Aporta temperatura del agua y estado del actuador"

        ichu -> firebaseAuth "Autentica usuarios"

        ichu -> firebaseMessaging "Envía notificaciones push"

        ichu -> mapProvider "Visualiza posiciones y geocercas"

        ichu -> paymentProvider "Procesa los cobros"


        // ============================================================
        // PERSON -> APPLICATION RELATIONSHIPS
        // ============================================================

        visitor -> landingPage "Visita el sitio público" "HTTPS"

        ranchManager -> webApplication "Gestiona el hato y consulta indicadores" "HTTPS"
        ranchManager -> mobileApplication "Consulta el hato y recibe alertas" "HTTPS"

        fieldOperator -> mobileApplication "Opera durante las faenas de campo" "HTTPS / Local Network"

        veterinarian -> webApplication "Revisa la información autorizada" "HTTPS"
        veterinarian -> mobileApplication "Revisa información durante la visita" "HTTPS"


        // ============================================================
        // AUTHENTICATION
        // ============================================================

        webApplication -> firebaseAuth "Autentica al usuario" "HTTPS"
        mobileApplication -> firebaseAuth "Autentica al usuario" "HTTPS"


        // ============================================================
        // MAP VISUALIZATION
        // ============================================================

        webApplication -> mapProvider "Muestra posiciones y geocercas" "HTTPS"
        mobileApplication -> mapProvider "Muestra posiciones y geocercas" "HTTPS"


        // ============================================================
        // CLIENT -> BACKEND
        // ============================================================

        landingPage -> backend "Consulta planes y contenido público" "HTTPS / JSON"
        webApplication -> backend "Consume el RESTful API" "HTTPS / JSON"
        mobileApplication -> backend "Consume el RESTful API" "HTTPS / JSON"


        // ============================================================
        // HIGH-LEVEL CONTAINER RELATIONSHIPS
        // ============================================================

        cattleBandEmbeddedApp -> cattleBandHardware "Lee sensores y posición"

        cattleBandEmbeddedApp -> backend "Envía telemetría cuando hay Wi-Fi" "HTTPS / JSON"

        cattleBandEmbeddedApp -> edgeGateway "Envía telemetría por BLE sin cobertura" "Bluetooth Low Energy"

        edgeGateway -> edgeDatabase "Guarda telemetría y configuración local" "SQLite"

        edgeGateway -> backend "Sincroniza al recuperar conexión" "HTTPS / JSON"

        edgeGateway -> mobileApplication "Entrega alertas locales sin Internet" "Local Wi-Fi"

        waterControllerEmbeddedApp -> waterControllerHardware "Lee el agua y acciona el calentador"

        waterControllerEmbeddedApp -> backend "Reporta temperatura y eventos del actuador" "HTTPS / JSON"

        backend -> cloudDatabase "Lee y escribe los datos de la nube" "Entity Framework Core / Npgsql"

        backend -> firebaseAuth "Valida la identidad del usuario" "Firebase Admin SDK"

        backend -> firebaseMessaging "Solicita las notificaciones push" "Firebase Admin SDK"

        backend -> paymentProvider "Solicita el cobro de la suscripción" "HTTPS"

        firebaseMessaging -> mobileApplication "Entrega la notificación al dispositivo" "Push Notification"


        // ============================================================
        // CATTLE BAND INTERNAL RELATIONSHIPS
        // ============================================================

        bandTelemetryInterface -> bandTelemetryService "Starts telemetry acquisition"

        bandTelemetryService -> cattleBandDevice "Updates cattle band state"

        bandTelemetryService -> cattleTelemetryProcessor "Processes cattle sensor readings"

        bandTelemetryService -> bandConnectivityService "Requests telemetry transmission"

        bandTelemetryService -> cattleBandLocalBuffer "Stores telemetry when communication is unavailable"

        cattleTelemetryProcessor -> cattleBandHAL "Reads normalized temperature, movement and GPS data"

        cattleBandDevice -> cattleBandHAL "Accesses device state and hardware"

        cattleBandHAL -> cattleBandHardwareACL "Uses hardware-specific drivers"

        cattleBandHardwareACL -> cattleBandHardware "Reads physical sensors and GPS/GNSS module"

        bandConnectivityService -> bandCloudAdapter "Uses cloud route when Wi-Fi and Internet are available"

        bandConnectivityService -> bandBleAdapter "Uses BLE route when cloud connectivity is unavailable"

        bandCloudAdapter -> backend "Envía telemetría directamente a la nube" "HTTPS / JSON"

        bandBleAdapter -> edgeGateway "Sends cattle telemetry to the Portable Edge Gateway" "Bluetooth Low Energy"


        // ============================================================
        // WATER CONTROLLER INTERNAL RELATIONSHIPS
        // ============================================================

        waterControlInterface -> waterControlService "Starts temperature monitoring"

        waterControlService -> waterControllerDevice "Updates controller state"

        waterControlService -> temperatureRegulationService "Requests temperature regulation evaluation"

        waterControlService -> waterLocalBuffer "Buffers events while cloud connectivity is unavailable"

        waterControlService -> waterCloudAdapter "Reports temperature and actuator events"

        temperatureRegulationService -> waterControllerDevice "Updates heating state"

        temperatureRegulationService -> waterControllerHAL "Reads temperature and controls heating actuator"

        waterControllerDevice -> waterControllerHAL "Executes device state changes"

        waterControllerHAL -> waterHardwareACL "Uses hardware-specific drivers"

        waterHardwareACL -> waterControllerHardware "Reads temperature sensor and operates heating actuator"

        waterCloudAdapter -> backend "Reports water telemetry and actuator events" "HTTPS / JSON"


        // ============================================================
        // EDGE GATEWAY INTERNAL RELATIONSHIPS
        // ============================================================

        bleDeviceInterface -> edgeTelemetryService "Provides telemetry received from cattle bands"

        edgeTelemetryService -> edgeTelemetry "Creates and updates local telemetry state"

        edgeTelemetryService -> edgeRepository "Stores received telemetry"

        edgeTelemetryService -> edgeMonitoringService "Evaluates critical offline monitoring rules"

        edgeMonitoringService -> edgeRepository "Loads cached cattle mappings, thresholds and geofences"

        edgeMonitoringService -> localAlertAdapter "Requests local alert when a critical condition is detected"

        localAlertAdapter -> mobileApplication "Delivers local fever or geofence alert" "Local Wi-Fi"

        edgeSyncOrchestrator -> edgeRepository "Loads pending telemetry and stores synchronized configuration"

        edgeSyncOrchestrator -> cloudApiACL "Requests upload of pending telemetry and download of monitoring configuration"

        cloudApiACL -> backend "Synchronizes telemetry, assignments, thresholds and geofences" "HTTPS / JSON"

        edgeRepository -> edgeDatabase "Persists telemetry, rules, mappings and synchronization state"


        // ============================================================
        // IDENTITY & ACCESS
        // ============================================================

        identityAPI -> identityService "Invokes identity and profile use cases"

        identityService -> userAccount "Creates and updates user account state"

        identityService -> authorizationService "Evaluates roles and permissions"

        identityService -> identityRepository "Lee y escribe cuentas, perfiles y asesorías"

        identityService -> firebaseAuthACL "Validates Firebase authenticated identities"

        firebaseAuthACL -> firebaseAuth "Uses Firebase Authentication" "Firebase Admin SDK"

        identityRepository -> cloudDatabase "Stores profile and ranch membership collections"


        // ============================================================
        // CATTLE INFORMATION
        // ============================================================

        cattleAPI -> cattleApplicationService "Invokes cattle information use cases"

        cattleApplicationService -> cattle "Creates and updates cattle information"

        cattleApplicationService -> cattleRepository "Loads and stores cattle information"

        cattleRepository -> cloudDatabase "Stores cattle collections"


        // ============================================================
        // IOT ASSETS
        // ============================================================

        iotAssetsAPI -> iotAssetsApplicationService "Invokes IoT asset management use cases"

        iotAssetsApplicationService -> iotDevice "Creates and updates IoT device state"

        iotAssetsApplicationService -> deviceAssignmentService "Coordinates device assignments"

        iotAssetsApplicationService -> iotAssetsRepository "Loads and stores IoT assets"

        deviceAssignmentService -> subscriptionEntitlementACL "Validates device entitlement"

        subscriptionEntitlementACL -> subscriptionApplicationService "Requests subscription and device limit information"

        deviceAssignmentService -> cattleAssignmentACL "Validates cattle assignment"

        cattleAssignmentACL -> cattleApplicationService "Requests cattle information"

        iotAssetsRepository -> cloudDatabase "Stores device and assignment collections"


        // ============================================================
        // OPERATIONS & MONITORING
        // ============================================================

        telemetryAPI -> telemetryIngestionService "Invokes telemetry ingestion"

        operationsAPI -> operationsApplicationService "Invokes livestock operational workflows"

        edgeConfigurationAPI -> edgeConfigurationService "Requests Edge monitoring configuration"

        telemetryIngestionService -> deviceRegistryACL "Validates device registration and assignment"

        deviceRegistryACL -> iotAssetsApplicationService "Queries IoT Assets module"

        telemetryIngestionService -> cattleLookupACL "Resolves cattle identity when required"

        cattleLookupACL -> cattleApplicationService "Queries Cattle Information module"

        telemetryIngestionService -> monitoringAggregate "Updates cloud monitoring state"

        telemetryIngestionService -> monitoringRulesService "Evaluates telemetry rules"

        telemetryIngestionService -> monitoringRepository "Stores accepted telemetry"

        operationsApplicationService -> livestockOperation "Creates and updates livestock operational events"

        operationsApplicationService -> cattleLookupACL "Validates cattle identity"

        operationsApplicationService -> monitoringRulesService "Evaluates operational monitoring conditions"

        operationsApplicationService -> monitoringRepository "Stores operational events"

        edgeConfigurationService -> deviceRegistryACL "Resolves device-to-cattle assignments"

        edgeConfigurationService -> monitoringRepository "Loads fever thresholds and geofence configuration"

        monitoringRulesService -> notificationAdapter "Requests notification when a critical condition exists"

        monitoringRulesService -> domainEventDispatcher "Publishes monitoring domain events"

        monitoringRepository -> cloudDatabase "Stores telemetry, monitoring and livestock operational data"


        // ============================================================
        // CLOUD NOTIFICATIONS
        // ============================================================

        notificationAdapter -> firebaseMessaging "Sends cloud push notification" "Firebase Admin SDK"


        // ============================================================
        // PLANNING
        // ============================================================

        planningAPI -> planningApplicationService "Invokes planning and calendar use cases"

        planningApplicationService -> livestockCalendar "Creates and updates planned livestock activities"

        planningApplicationService -> reminderService "Evaluates reminder requirements"

        planningApplicationService -> planningRepository "Loads and stores planning information"

        reminderService -> notificationAdapter "Requests scheduled notification"

        reminderService -> domainEventDispatcher "Publishes planning domain events"

        planningRepository -> cloudDatabase "Stores livestock calendar and campaign collections"


        // ============================================================
        // ANALYTICS
        // ============================================================

        analyticsAPI -> analyticsApplicationService "Invokes dashboard and analytics queries"

        analyticsApplicationService -> analyticsService "Calculates indicators and trends"

        analyticsApplicationService -> analyticsRepository "Loads analytical information"

        domainEventDispatcher -> analyticsApplicationService "Provides internal domain events"

        analyticsRepository -> cloudDatabase "Stores and retrieves analytical projections"


        // ============================================================
        // SUBSCRIPTIONS & BILLING
        // ============================================================

        subscriptionAPI -> subscriptionApplicationService "Invokes subscription lifecycle use cases"

        billingAPI -> paymentApplicationService "Invokes billing and payment workflows"

        subscriptionApplicationService -> subscription "Creates and updates subscription state"

        subscriptionApplicationService -> subscriptionRepository "Loads and stores subscriptions"

        subscriptionApplicationService -> domainEventDispatcher "Publishes subscription events"

        paymentApplicationService -> subscription "Updates subscription state after payment"

        paymentApplicationService -> paymentProviderACL "Delegates external payment operation"

        paymentApplicationService -> subscriptionRepository "Stores billing information"

        paymentProviderACL -> paymentProvider "Uses external payment provider" "HTTPS"

        subscriptionRepository -> cloudDatabase "Stores plan, subscription and billing collections"


        // ============================================================
        // DEPLOYMENT
        // ============================================================

        production = deploymentEnvironment "Production" {

            deploymentNode "Ranch / Grazing Environment" {

                deploymentNode "Cattle Band Device" {
                    technology "ESP32 + Wi-Fi + Bluetooth Low Energy"

                    containerInstance cattleBandEmbeddedApp
                }

                deploymentNode "Water Temperature Controller Device" {
                    technology "ESP32 + Wi-Fi"

                    containerInstance waterControllerEmbeddedApp
                }

                deploymentNode "Portable Edge Gateway Device" {
                    technology "Raspberry Pi or similar portable Edge computer with BLE and Wi-Fi"

                    containerInstance edgeGateway
                    containerInstance edgeDatabase
                }

                deploymentNode "Field Operator Mobile Device" {
                    technology "Android / iOS"

                    containerInstance mobileApplication
                }
            }


            deploymentNode "User Computer" {

                deploymentNode "Web Browser" {
                    containerInstance landingPage
                    containerInstance webApplication
                }
            }


            deploymentNode "Cloud Platform" {

                deploymentNode ".NET Application Runtime" {
                    technology ".NET 8 / ASP.NET Core"

                    containerInstance backend
                }

                deploymentNode "Firebase Cloud" {
                    technology "Google Firebase"

                    containerInstance cloudDatabase
                }
            }
        }
    }


    // ================================================================
    // VIEWS
    // ================================================================

    views {


        // ============================================================
        // LEVEL 1 - SYSTEM CONTEXT
        // CORRECTED TO EXPLICITLY SHOW USERS + EXTERNAL SYSTEMS
        // ============================================================

        // ============================================================
        // LEVEL 0 - SYSTEM LANDSCAPE
        // ============================================================

        systemLandscape "SystemLandscape" {
            title "ICHU - System Landscape"
            description "Personas, dispositivos y servicios externos del panorama de la solución"

            include *

            autoLayout lr
        }


        systemContext ichu "SystemContext" {
            title "ICHU - System Context"
            description "Usuarios, hardware IoT y servicios externos que interactúan con la plataforma"

            include ichu

            include ranchManager
            include fieldOperator
            include veterinarian
            include visitor

            include cattleBandHardware
            include waterControllerHardware

            include firebaseAuth
            include firebaseMessaging
            include mapProvider
            include paymentProvider

            autoLayout lr
        }


        // ============================================================
        // LEVEL 2 - CONTAINERS
        // ============================================================

        container ichu "ContainerDiagram" {
            title "ICHU - Container Diagram"
            description "Clientes web y móvil, dispositivos ESP32, pasarela de borde, backend y base relacional"

            include *

            autoLayout lr
        }


        // ============================================================
        // LEVEL 3 - CATTLE BAND COMPONENTS
        // ============================================================

        component cattleBandEmbeddedApp "CattleBandComponents" {
            title "Cattle Band Embedded Application - Components"
            description "Componentes del collar para la captura de telemetría y la conectividad"

            include *

            include cattleBandHardware
            include backend
            include edgeGateway

            autoLayout lr
        }


        // ============================================================
        // LEVEL 3 - EDGE GATEWAY COMPONENTS
        // ============================================================

        component edgeGateway "EdgeGatewayComponents" {
            title "Portable Edge Gateway - Components"
            description "Recepción, evaluación local y sincronización posterior durante el pastoreo"

            include *

            include edgeDatabase
            include cattleBandEmbeddedApp
            include backend
            include mobileApplication

            autoLayout lr
        }


        // ============================================================
        // LEVEL 3 - WATER CONTROLLER COMPONENTS
        // ============================================================

        component waterControllerEmbeddedApp "WaterControllerComponents" {
            title "Water Temperature Controller - Components"
            description "Componentes del controlador para la regulación local de la temperatura del agua"

            include *

            include waterControllerHardware
            include backend

            autoLayout lr
        }


        // ============================================================
        // LEVEL 3 - BACKEND: IDENTITY
        // ============================================================

        component backend "IdentityComponents" {
            title "ICHU Backend - Identity & Access"

            include identityAPI
            include identityService
            include userAccount
            include authorizationService
            include identityRepository
            include firebaseAuthACL

            include firebaseAuth
            include cloudDatabase

            autoLayout lr
        }


        // ============================================================
        // LEVEL 3 - BACKEND: CATTLE INFORMATION
        // ============================================================

        component backend "CattleComponents" {
            title "ICHU Backend - Cattle Information"

            include cattleAPI
            include cattleApplicationService
            include cattle
            include cattleRepository

            include cloudDatabase

            autoLayout lr
        }


        // ============================================================
        // LEVEL 3 - BACKEND: IOT ASSETS
        // ============================================================

        component backend "IoTAssetsComponents" {
            title "ICHU Backend - IoT Assets"

            include iotAssetsAPI
            include iotAssetsApplicationService
            include iotDevice
            include deviceAssignmentService
            include subscriptionEntitlementACL
            include cattleAssignmentACL
            include iotAssetsRepository

            include subscriptionApplicationService
            include cattleApplicationService
            include cloudDatabase

            autoLayout lr
        }


        // ============================================================
        // LEVEL 3 - BACKEND: OPERATIONS & MONITORING
        // ============================================================

        component backend "MonitoringComponents" {
            title "ICHU Backend - Operations & Monitoring"

            include telemetryAPI
            include operationsAPI
            include edgeConfigurationAPI

            include telemetryIngestionService
            include operationsApplicationService
            include edgeConfigurationService

            include monitoringAggregate
            include livestockOperation
            include monitoringRulesService

            include deviceRegistryACL
            include cattleLookupACL
            include monitoringRepository

            include notificationAdapter
            include domainEventDispatcher

            include iotAssetsApplicationService
            include cattleApplicationService

            include cloudDatabase
            include firebaseMessaging

            autoLayout lr
        }


        // ============================================================
        // LEVEL 3 - BACKEND: PLANNING
        // ============================================================

        component backend "PlanningComponents" {
            title "ICHU Backend - Planning"

            include planningAPI
            include planningApplicationService
            include livestockCalendar
            include reminderService
            include planningRepository

            include notificationAdapter
            include domainEventDispatcher

            include cloudDatabase
            include firebaseMessaging

            autoLayout lr
        }


        // ============================================================
        // LEVEL 3 - BACKEND: ANALYTICS
        // ============================================================

        component backend "AnalyticsComponents" {
            title "ICHU Backend - Dashboard & Analytics"

            include analyticsAPI
            include analyticsApplicationService
            include analyticsService
            include analyticsRepository
            include domainEventDispatcher

            include cloudDatabase

            autoLayout lr
        }


        // ============================================================
        // LEVEL 3 - BACKEND: SUBSCRIPTIONS
        // ============================================================

        component backend "SubscriptionComponents" {
            title "ICHU Backend - Subscriptions & Billing"

            include subscriptionAPI
            include billingAPI
            include subscriptionApplicationService
            include paymentApplicationService
            include subscription
            include subscriptionRepository
            include paymentProviderACL

            include domainEventDispatcher
            include paymentProvider
            include cloudDatabase

            autoLayout lr
        }


        // ============================================================
        // END-TO-END DYNAMIC FLOW - CONNECTED CATTLE BAND
        // ============================================================

        dynamic ichu "ConnectedTelemetryFlow" {
            title "ICHU - Connected Cattle Monitoring Flow"
            description "Flujo completo cuando el collar tiene cobertura"

            cattleBandEmbeddedApp -> backend "1. Sends temperature, movement and GPS telemetry through Wi-Fi"

            backend -> cloudDatabase "2. Stores telemetry and monitoring state"

            backend -> firebaseMessaging "3. Requests push notification when a critical rule is detected"

            firebaseMessaging -> mobileApplication "4. Delivers cattle alert to the user"

            autoLayout lr
        }


        // ============================================================
        // END-TO-END DYNAMIC FLOW - OFFLINE GRAZING
        // ============================================================

        dynamic ichu "OfflineGrazingFlow" {
            title "ICHU - Offline Grazing Flow"
            description "Flujo completo durante el pastoreo sin cobertura"

            cattleBandEmbeddedApp -> edgeGateway "1. Sends telemetry through Bluetooth Low Energy"

            edgeGateway -> edgeDatabase "2. Stores telemetry and uses cached monitoring configuration"

            edgeGateway -> mobileApplication "3. Delivers local fever or geofence alerts"

            autoLayout lr
        }


        // ============================================================
        // END-TO-END DYNAMIC FLOW - EDGE SYNCHRONIZATION
        // ============================================================

        dynamic ichu "EdgeSynchronizationFlow" {
            title "ICHU - Edge Gateway Synchronization"
            description "Sincronización al recuperar la conexión"

            edgeGateway -> backend "1. Uploads telemetry collected during offline grazing and requests updated configuration"

            backend -> cloudDatabase "2. Stores synchronized telemetry"

            backend -> firebaseMessaging "3. Requests cloud notifications when required"

            firebaseMessaging -> mobileApplication "4. Delivers cloud notification"

            autoLayout lr
        }


        // ============================================================
        // END-TO-END DYNAMIC FLOW - WATER CONTROLLER
        // ============================================================

        dynamic ichu "WaterControllerCloudFlow" {
            title "ICHU - Water Controller Cloud Flow"
            description "Reporte de temperatura del agua y eventos del actuador"

            waterControllerEmbeddedApp -> backend "1. Reports temperature and heating events"

            backend -> cloudDatabase "2. Stores water telemetry and actuator history"

            autoLayout lr
        }


        // ============================================================
        // INTERNAL DYNAMIC FLOW - CATTLE BAND
        // ============================================================

        dynamic cattleBandEmbeddedApp "CattleBandInternalFlow" {
            title "Cattle Band - Internal Telemetry Flow"
            description "Flujo interno de componentes dentro del collar"

            bandTelemetryInterface -> bandTelemetryService "1. Starts telemetry acquisition"

            bandTelemetryService -> cattleBandDevice "2. Updates device state"

            bandTelemetryService -> cattleTelemetryProcessor "3. Processes sensor readings"

            cattleTelemetryProcessor -> cattleBandHAL "4. Obtains temperature, movement and GPS data"

            cattleBandHAL -> cattleBandHardwareACL "5. Uses hardware-specific drivers"

            cattleBandHardwareACL -> cattleBandHardware "6. Reads physical sensors"

            bandTelemetryService -> bandConnectivityService "7. Selects the available communication route"

            autoLayout lr
        }


        // ============================================================
        // INTERNAL DYNAMIC FLOW - EDGE OFFLINE PROCESSING
        // ============================================================

        dynamic edgeGateway "EdgeGatewayInternalFlow" {
            title "Portable Edge Gateway - Offline Processing"
            description "Procesamiento en el borde durante el pastoreo sin cobertura"

            bleDeviceInterface -> edgeTelemetryService "1. Receives telemetry from cattle bands"

            edgeTelemetryService -> edgeTelemetry "2. Creates local telemetry state"

            edgeTelemetryService -> edgeRepository "3. Stores received telemetry"

            edgeRepository -> edgeDatabase "4. Persists telemetry in SQLite"

            edgeTelemetryService -> edgeMonitoringService "5. Evaluates offline monitoring rules"

            edgeMonitoringService -> edgeRepository "6. Loads cattle mappings, fever thresholds and geofences"

            edgeMonitoringService -> localAlertAdapter "7. Generates local alert when required"

            autoLayout lr
        }


        // ============================================================
        // INTERNAL DYNAMIC FLOW - EDGE CLOUD SYNC
        // ============================================================

        dynamic edgeGateway "EdgeGatewaySyncInternalFlow" {
            title "Portable Edge Gateway - Cloud Synchronization"
            description "Proceso interno de sincronización al restablecerse la conexión"

            edgeSyncOrchestrator -> edgeRepository "1. Loads unsynchronized telemetry"

            edgeRepository -> edgeDatabase "2. Reads pending telemetry and cached configuration"

            edgeSyncOrchestrator -> cloudApiACL "3. Prepares telemetry and configuration synchronization"

            autoLayout lr
        }


        // ============================================================
        // INTERNAL DYNAMIC FLOW - BACKEND TELEMETRY
        // ============================================================

        dynamic backend "CloudTelemetryProcessingFlow" {
            title "ICHU Backend - Telemetry Processing"
            description "Procesamiento interno de la telemetría en el backend"

            telemetryAPI -> telemetryIngestionService "1. Receives cattle or water telemetry"

            telemetryIngestionService -> deviceRegistryACL "2. Validates IoT device assignment"

            deviceRegistryACL -> iotAssetsApplicationService "3. Resolves registered device"

            telemetryIngestionService -> cattleLookupACL "4. Resolves cattle identity when required"

            telemetryIngestionService -> monitoringAggregate "5. Updates monitoring state"

            telemetryIngestionService -> monitoringRepository "6. Stores accepted telemetry"

            telemetryIngestionService -> monitoringRulesService "7. Evaluates fever, inactivity and geofence rules"

            monitoringRulesService -> notificationAdapter "8. Requests cloud notification when a critical condition exists"

            monitoringRulesService -> domainEventDispatcher "9. Publishes internal monitoring event"

            autoLayout lr
        }


        // ============================================================
        // INTERNAL DYNAMIC FLOW - EDGE CONFIGURATION
        // ============================================================

        dynamic backend "EdgeConfigurationFlow" {
            title "ICHU Backend - Edge Configuration Flow"
            description "Prepara la configuración que el borde necesita para operar sin conexión"

            edgeConfigurationAPI -> edgeConfigurationService "1. Receives configuration request from Edge"

            edgeConfigurationService -> deviceRegistryACL "2. Resolves cattle-band assignments"

            deviceRegistryACL -> iotAssetsApplicationService "3. Loads registered device assignments"

            edgeConfigurationService -> monitoringRepository "4. Loads fever thresholds and geofence configuration"

            autoLayout lr
        }


        // ============================================================
        // INTERNAL DYNAMIC FLOW - PLANNING
        // ============================================================

        dynamic backend "PlanningReminderFlow" {
            title "ICHU Backend - Planning Reminder Flow"
            description "Flujo interno de recordatorios del calendario ganadero"

            planningAPI -> planningApplicationService "1. Creates or updates scheduled livestock activity"

            planningApplicationService -> livestockCalendar "2. Updates calendar state"

            planningApplicationService -> planningRepository "3. Stores planned activity"

            planningApplicationService -> reminderService "4. Evaluates reminder schedule"

            reminderService -> notificationAdapter "5. Requests notification when reminder becomes due"

            autoLayout lr
        }


        // ============================================================
        // INTERNAL DYNAMIC FLOW - WATER CONTROLLER
        // ============================================================

        dynamic waterControllerEmbeddedApp "WaterControllerInternalFlow" {
            title "Water Controller - Local Temperature Regulation"
            description "La regulación local sigue operando aunque no haya conexión"

            waterControlInterface -> waterControlService "1. Starts water temperature monitoring"

            waterControlService -> temperatureRegulationService "2. Evaluates configured temperature threshold"

            temperatureRegulationService -> waterControllerHAL "3. Reads temperature and determines actuator action"

            waterControllerHAL -> waterHardwareACL "4. Uses hardware-specific driver"

            waterHardwareACL -> waterControllerHardware "5. Reads sensor or operates heating actuator"

            temperatureRegulationService -> waterControllerDevice "6. Updates heating state"

            autoLayout lr
        }


        // ============================================================
        // DEPLOYMENT
        // ============================================================

        deployment * production "ProductionDeployment" {
            title "ICHU - Production Deployment"
            description "Despliegue de dispositivos, borde, backend, aplicaciones y servicios en la nube"

            include *

            autoLayout lr
        }


        // ============================================================
        // STYLES
        // ============================================================

        styles {

            element "Element" {
                shape RoundedBox
            }

            element "Person" {
                shape Person
                background #08427b
                color #ffffff
            }

            element "Visitor" {
                shape Person
                background #777777
                color #ffffff
            }

            element "Software System" {
                background #1168bd
                color #ffffff
            }

            element "Container" {
                background #438dd5
                color #ffffff
            }

            element "Monolith" {
                background #277da1
                color #ffffff
            }

            element "Database" {
                shape Cylinder
                background #f4a261
                color #000000
            }

            element "Hardware" {
                background #666666
                color #ffffff
            }

            element "External" {
                background #999999
                color #ffffff
            }

            element "IoT" {
                background #168aad
                color #ffffff
            }

            element "Edge" {
                background #2a9d8f
                color #ffffff
            }

            element "Web" {
                shape WebBrowser
            }

            element "Mobile" {
                shape MobileDeviceLandscape
            }

            element "Component" {
                background #85bbf0
                color #000000
            }

            element "Interface" {
                background #fff2cc
                color #000000
            }

            element "Application" {
                background #cfe2f3
                color #000000
            }

            element "DomainAggregate" {
                background #d9ead3
                color #000000
            }

            element "DomainService" {
                background #d0e0e3
                color #000000
            }

            element "Infrastructure" {
                background #f4cccc
                color #000000
            }

            element "ACL" {
                shape Component
                background #f8f8f8
                stroke #cccccc
                color #000000
            }
        }
    }
}