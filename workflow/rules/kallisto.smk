rule kallisto:
    input:
        r1="trimmed_reads/{replicate}_P_R1.fastq.gz",
        r2="trimmed_reads/{replicate}_P_R1.fastq.gz",
        index=f"{config['index_prefix']}.idx"
    output:
        "kallisto_quant/{replicate}/abundance.h5"
    log:
        "logs/kallisto_{replicate}.log"
    envmodules:
        "kallisto/0.51.1-gompi-2023a"
    resources:
        mem_mb=12000,
        cpus_per_task=8
    shell:
        "kallisto quant -i {input.index} -o {output} -b 100 -t {resources.cpus_per_task} {input.r1} {input.r2}"