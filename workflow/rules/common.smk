import pandas as pd

REPLICATES = pd.read_table(config["replicates"],header=0,sep="\\s+").set_index("REPLICATES", drop=False)

get_sample_read1 = REPLICATES["read1"].to_dict()
get_sample_read2 = REPLICATES["read2"].to_dict()
