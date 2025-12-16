# Dilcore-InfraAsCode

[![CodeRabbit Reviews](https://img.shields.io/coderabbit/prs/github/aytymchuk/Dilcore-Shared-InfraAsCode?utm_source=oss&utm_medium=github&utm_campaign=aytymchuk%2FDilcore-Shared-InfraAsCode&labelColor=171717&color=FF570A&link=https%3A%2F%2Fcoderabbit.ai&label=CodeRabbit+Reviews)](https://coderabbit.ai)

This repository contains the Infrastructure as Code (IaC) definitions for the Dilcore project.

## Infra

The infrastructure is managed using Terraform and is organized into modular components.

- **[Shared Infrastructure](./infra/shared/)**: This is the base of the infrastructure setup. It contains the foundational components such as the Container App Environment, App Configuration, and Log Analytics Workspace. It must be provisioned before other modules.
- **[Platform Infrastructure](./infra/platform/)**: This module contains the platform-specific resources, including the main API Container App. It has a direct relation to the container app environment provisioned in the shared module.
- **[MongoDB Infrastructure](./infra/mongodb/)**: This module manages the MongoDB Atlas resources, including the Atlas Project and Cluster. It stores the connection string in the shared App Configuration.

### Infrastructure Overview

The following diagram illustrates the relationship between the Shared, Platform, and MongoDB infrastructure components.

```mermaid
graph TD
    subgraph Shared_Infrastructure["Shared Infrastructure"]
        style Shared_Infrastructure fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
        subgraph SharedRG["Shared Resource Group"]
            style SharedRG fill:#ffffff,stroke:#90caf9
            LAW["Log Analytics Workspace"]
            AppConfig["App Configuration"]
            AppInsights["Application Insights"]
            CAE["Container App Environment"]
        end
    end

    subgraph Platform_Infrastructure["Platform Infrastructure"]
        style Platform_Infrastructure fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
        subgraph PlatformRG["Platform Resource Group"]
            style PlatformRG fill:#ffffff,stroke:#ce93d8
            ContainerApp["Container App (API)"]
            Storage["Storage Account"]
        end
    end
    
    subgraph MongoDB_Infrastructure["MongoDB Infrastructure"]
        style MongoDB_Infrastructure fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px
        subgraph Atlas["MongoDB Atlas"]
            style Atlas fill:#ffffff,stroke:#a5d6a7
            AtlasCluster["Atlas Cluster"]
        end
    end

    %% Cross-Group Relationships
    ContainerApp -->|Hosted In| CAE
    ContainerApp -->|Reads Settings| AppConfig
    ContainerApp -->|Read/Write| Storage
    ContainerApp -->|Connects To| AtlasCluster
    
    %% Logging & Monitoring
    AppInsights -->|Logs| LAW
    CAE -->|Logs| LAW
    
    %% Configuration Flow (Terraform managed)
    Storage -.->|Connection String| AppConfig
    AppInsights -.->|Connection String| AppConfig
    AtlasCluster -.->|Connection String| AppConfig
```

## Configuration

Configuration will be implemented soon.
