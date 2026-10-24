[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared Query = let
  Source = SharePoint.Files("https://thfabricdemos.sharepoint.com/sites/THFabricDemos", [ApiVersion = 15]),
  Navigation = Source{[Name = "Transactions.xlsx", #"Folder Path" = "https://thfabricdemos.sharepoint.com/sites/THFabricDemos/Shared Documents/Transactions/Transactions/"]}[Content],
  #"Imported Excel workbook" = Excel.Workbook(Navigation, null, true),
  #"Navigation 1" = #"Imported Excel workbook"{[Item = "Sheet1", Kind = "Sheet"]}[Data],
  #"Promoted headers" = Table.PromoteHeaders(#"Navigation 1", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"transaction_id", type text}, {"customer_id", Int64.Type}, {"location_id", Int64.Type}, {"status_id", Int64.Type}, {"order_type", type text}, {"created_date", type datetime}, {"order_ready_date", type datetime}, {"order_completed_date", type datetime}})
in
  #"Changed column type";
