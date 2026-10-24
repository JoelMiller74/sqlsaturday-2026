# MCP Tool Capability Catalog

This document inventories the MCP tools available from the servers configured in .mcp.json and groups them by capability type.

## Source Profile

Configured servers in .mcp.json:

| Server name in profile | Endpoint | Primary tool family |
|---|---|---|
| Fabric Core MCP (Remote) | https://api.fabric.microsoft.com/v1/mcp/core | mcp_fabricmcpserv_* |
| Fabric Data Warehouse MCP (Global) | https://api.fabric.microsoft.com/v1/mcp/dataPlane/sqlEndpoint | mcp_microsoft_fab_* |
| Fabric Eventhouse MCP (Global) | https://api.fabric.microsoft.com/v1/mcp/dataPlane/kqlEndpoint | mcp_microsoft_fa2_* |
| Fabric IQ MCP (Remote) | https://fabriciq.svc.cloud.microsoft/v1/mcp/fabriciq | mcp_fabriciq_* |
| Power BI Authoring MCP (Remote) | https://api.fabric.microsoft.com/v1/mcp/powerbi/authoring | mcp_power_bi_aut2_* |

## Categorization Method

Best grouping is capability-first, not server-first.

- Reason 1: multiple servers overlap on discovery and semantic model scenarios.
- Reason 2: demo and implementation decisions are usually task-driven (querying, authoring, catalog lookup, governance).
- Reason 3: this avoids duplicate listings when two servers can do similar work.

Each tool below is listed with:

- what the tool is
- what the tool does
- which MCP server provides it

## 1) Platform Discovery and Metadata

| Tool | What it is and does | MCP server |
|---|---|---|
| mcp_fabricmcpserv_search_catalog | Cross-workspace catalog search over Fabric items and workspaces using text and optional type filters. | Fabric Core MCP (Remote) |
| mcp_fabriciq_DiscoverArtifacts | Semantic-model/report discovery helper that finds Power BI artifacts by natural search text. | Fabric IQ MCP (Remote) |
| mcp_fabriciq_ResolveFabricItem | Resolves item URLs or IDs into canonical Fabric identity fields for downstream calls. | Fabric IQ MCP (Remote) |
| mcp_fabriciq_GetReportMetadata | Reads report structure and context (pages, visuals, filters) to guide correct semantic model query context. | Fabric IQ MCP (Remote) |
| mcp_fabriciq_GetSemanticModelSchema | Reads semantic model schema, author instructions, and verified answers for query planning. | Fabric IQ MCP (Remote) |
| mcp_fabriciq_ValueSearch | Resolves business terms and filter values to exact table/column/value matches in a semantic model. | Fabric IQ MCP (Remote) |
| mcp_microsoft_fa2_getSchema | Returns Eventhouse/KQL schema metadata to support correct KQL query authoring. | Fabric Eventhouse MCP (Global) |

## 2) Query and Data Retrieval

| Tool | What it is and does | MCP server |
|---|---|---|
| mcp_microsoft_fab_execute_query | Executes T-SQL against Fabric SQL endpoint items (for example Warehouse, SQL Database, SQL Endpoint items). | Fabric Data Warehouse MCP (Global) |
| mcp_microsoft_fa2_executeQuery | Executes KQL against Eventhouse/KQL endpoints. | Fabric Eventhouse MCP (Global) |
| mcp_fabriciq_ExecuteQuery | Executes DAX against a semantic model (or report-backed model) and returns tabular results. | Fabric IQ MCP (Remote) |
| mcp_power_bi_aut2_dax_query_operations | Power BI Authoring query tool for DAX execute, validate, and cache clear operations. | Power BI Authoring MCP (Remote) |

## 3) Semantic Model Authoring and Management

| Tool | What it is and does | MCP server |
|---|---|---|
| mcp_power_bi_aut2_connection_operations | Connects/disconnects to Fabric semantic models and lists active authoring connections. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_database_operations | Semantic model database-level list/create/update/export (TMDL and TMSL). | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_model_operations | Model-level get/create/update/rename/stats/refresh/export operations. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_table_operations | Table list/get/create/update/delete/rename/schema/refresh and table exports. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_column_operations | Column create/update/delete/get/list/rename/export operations. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_measure_operations | Measure create/update/delete/get/list/rename/move/export operations. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_relationship_operations | Relationship list/get/create/update/delete/rename/activate/deactivate/find/export. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_partition_operations | Partition list/get/create/update/delete/refresh/rename/export operations. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_user_hierarchy_operations | User hierarchy and hierarchy-level management operations. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_perspective_operations | Perspective and perspective object membership management for tables/columns/measures/hierarchies. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_calculation_group_operations | Calculation group and calculation item lifecycle operations. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_calendar_operations | Calendar object and calendar column-group operations for time intelligence support. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_named_expression_operations | Named expression and Power Query parameter operations. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_function_operations | Semantic model function operations (create/update/list/delete/rename/export). | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_security_role_operations | Security role and table permission operations, including effective permissions and exports. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_culture_operations | Culture lifecycle and culture metadata lookups and export operations. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_object_translation_operations | Translation create/update/delete/get/list for localized model metadata. | Power BI Authoring MCP (Remote) |
| mcp_power_bi_aut2_query_group_operations | Query group create/update/delete/get/list/export operations. | Power BI Authoring MCP (Remote) |

## 4) Fabric Item and Workspace Lifecycle

| Tool | What it is and does | MCP server |
|---|---|---|
| mcp_fabricmcpserv_create_item | Creates new Fabric items in a workspace, with optional definition payloads. | Fabric Core MCP (Remote) |
| mcp_fabricmcpserv_update_item | Updates item metadata such as display name and description. | Fabric Core MCP (Remote) |
| mcp_fabricmcpserv_bulk_move_items | Moves multiple items to a target workspace folder in one operation. | Fabric Core MCP (Remote) |
| mcp_fabricmcpserv_update_folder | Renames a workspace folder. | Fabric Core MCP (Remote) |
| activate_workspace_management_tools | Activates workspace management toolset (create/delete/get workspace, list folders/items, role assignment management). | Fabric Core MCP (Remote) |
| activate_folder_management_tools | Activates folder management toolset (create/move folders). | Fabric Core MCP (Remote) |
| activate_workspace_access_management | Activates workspace access/security management toolset (grant/revoke roles, delete items/folders). | Fabric Core MCP (Remote) |
| activate_item_definition_management | Activates item definition toolset (retrieve and update item definitions). | Fabric Core MCP (Remote) |

## 5) OneLake Governance and Storage Controls

| Tool | What it is and does | MCP server |
|---|---|---|
| mcp_fabricmcpserv_onelake_modify_default_tier | Modifies the default OneLake storage tier for a workspace (Hot/Cool/Cold). | Fabric Core MCP (Remote) |
| activate_onelake_data_access_roles | Activates OneLake data access role toolset (create/update/list/delete roles). | Fabric Core MCP (Remote) |
| activate_onelake_shortcut_management | Activates OneLake shortcut toolset (create/update/delete/list/get shortcuts). | Fabric Core MCP (Remote) |
| activate_onelake_workspace_settings | Activates OneLake workspace settings toolset (diagnostics, immutability, settings updates). | Fabric Core MCP (Remote) |

## 6) Eventhouse Query Authoring Support

| Tool | What it is and does | MCP server |
|---|---|---|
| mcp_microsoft_fa2_getGeneralKQLExamples | Returns general KQL examples for common query patterns. | Fabric Eventhouse MCP (Global) |
| mcp_microsoft_fa2_getSpecificKQLExamples | Returns targeted KQL examples for specific scenarios. | Fabric Eventhouse MCP (Global) |
| activate_fallback_mcp_microsoft_fa2_getGeneralKQLExamples_1 | Activates the KQL helper tool group (general examples, specific examples, schema). | Fabric Eventhouse MCP (Global) |

## 7) Knowledge and Definition Guidance

| Tool | What it is and does | MCP server |
|---|---|---|
| mcp_fabricmcpserv_get_knowledge | Returns domain knowledge for item definition formats (Notebook, Dataflow, Lakehouse, Report, SemanticModel). | Fabric Core MCP (Remote) |

## 8) Tool-Pack Activators

These tools do not perform business actions directly. They activate additional tool groups.

| Tool | What it is and does | MCP server |
|---|---|---|
| activate_fallback_mcp_fabriciq_GetReportMetadata_1 | Activates additional Fabric IQ tools: GetReportMetadata, GetSemanticModelSchema, ResolveFabricItem, ValueSearch. | Fabric IQ MCP (Remote) |
| activate_fallback_mcp_power_bi_aut2_culture_operations_1 | Activates full Power BI Authoring operation tools in fallback environments. | Power BI Authoring MCP (Remote) |

## Overlap and Best-Use Guidance

Capability overlaps are expected. Use these tie-breakers:

1. SQL reads and T-SQL execution
   - Prefer mcp_microsoft_fab_execute_query for direct SQL endpoint work.

2. KQL reads in Eventhouse
   - Use mcp_microsoft_fa2_executeQuery.
   - Add KQL example/schema tools when authoring complex KQL.

3. Semantic model data answers
   - For quick data Q and A and value resolution, use Fabric IQ tools.
   - For deep authoring, governance, refresh, and model object lifecycle, use Power BI Authoring tools.

4. Workspace and item inventory vs semantic artifact discovery
   - Use mcp_fabricmcpserv_search_catalog for broad Fabric inventory.
   - Use mcp_fabriciq_DiscoverArtifacts when your target is specifically semantic models/reports.
