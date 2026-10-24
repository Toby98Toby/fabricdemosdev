[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Query_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Query = let
  Source = SharePoint.Files("https://thfabricdemos.sharepoint.com/sites/THFabricDemos", [ApiVersion = 15]),
  Navigation = Source{[Name = "Transactions.xlsx", #"Folder Path" = "https://thfabricdemos.sharepoint.com/sites/THFabricDemos/Shared Documents/Transactions/Transactions/"]}[Content],
  #"Imported Excel workbook" = Excel.Workbook(Navigation, null, true),
  #"Navigation 1" = #"Imported Excel workbook"{[Item = "Sheet1", Kind = "Sheet"]}[Data],
  #"Promoted headers" = Table.PromoteHeaders(#"Navigation 1", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"transaction_id", type text}, {"customer_id", Int64.Type}, {"location_id", Int64.Type}, {"status_id", Int64.Type}, {"order_type", type text}, {"created_date", type datetime}, {"order_ready_date", type datetime}, {"order_completed_date", type datetime}})
in
  #"Changed column type";
shared Query_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "02a2312e-49eb-4254-9a6a-35ccb74a5d03"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "f58a7753-fb60-4e88-adb5-8a347a799a31"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "bronze_transactions", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
