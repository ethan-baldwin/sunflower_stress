rule kallisto:
    input:
        r1="trimmed_reads/{replicate}_P_R1.fastq.gz",
        r2="trimmed_reads/{replicate}_P_R1.fastq.gz",
        index=f"{config['index_prefix']}.idx"
    output:
        directory=directory("kallisto_quant/{replicate}"),
        abundance="kallisto_quant/{replicate}/abundance.h5"
    log:
        "logs/kallisto_{replicate}.log"
    envmodules:
        "kallisto/0.51.1-gompi-2023a"
    resources:
        mem_mb=12000,
        cpus_per_task=8
    shell:
        "kallisto quant -i {input.index} -o {output.directory} -b 100 -t {resources.cpus_per_task} {input.r1} {input.r2}"


rule kallisto_stats:
    input:
        abundance="kallisto_quant/{replicate}/abundance.h5"
    output:
        "psuedoalignment_stats.txt"
    log:
        "logs/kallisto_stats.log"
    resources:
        mem_mb=4000,
        cpus_per_task=1
    shell:
        """
        grep "p_pseudoaligned" kallisto_quant/*/run_info.json | awk -F'[/: ,]+' '{print $2, $5}' > {output}
        """