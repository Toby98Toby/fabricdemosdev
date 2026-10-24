# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "f58a7753-fb60-4e88-adb5-8a347a799a31",
# META       "default_lakehouse_name": "lh_bronze",
# META       "default_lakehouse_workspace_id": "02a2312e-49eb-4254-9a6a-35ccb74a5d03",
# META       "known_lakehouses": [
# META         {
# META           "id": "f58a7753-fb60-4e88-adb5-8a347a799a31"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

spark.catalog.clearCache()

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

import pandas as pd
from delta.tables import DeltaTable


shortcut_path = "/lakehouse/default/Files/TransactionLines/TransactionLines.xlsx"

pdframe = pd.read_excel(shortcut_path)

df_incoming = spark.createDataFrame(pdframe)

display(df_incoming)




# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

#df_incoming.write.format("delta").mode("overwrite").saveAsTable("bronze_transaction_lines")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# temporary SQL view
df_incoming.createOrReplaceTempView("incoming_data")

# MERGE using a composite key (transaction_id + line_id)
spark.sql("""
    MERGE INTO bronze_transaction_lines AS target
    USING incoming_data AS source
    ON target.transaction_id = source.transaction_id 
       AND target.line_id = source.line_id
    WHEN MATCHED THEN 
        UPDATE SET *
    WHEN NOT MATCHED THEN 
        INSERT *
""")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
