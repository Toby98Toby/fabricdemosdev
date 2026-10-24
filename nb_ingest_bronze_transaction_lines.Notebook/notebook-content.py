# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {}
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
