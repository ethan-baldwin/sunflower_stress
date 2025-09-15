rule index_kallisto:
    input:
        config['transcriptome']
    output:
        f"{config['kallisto_index_prefix']}.idx"
    envmodules:
        "kallisto/0.51.1-gompi-2023b"
    resources:
        mem_mb=10000
    shell:
        "kallisto index -i {output} {input}"


rule kallisto:
    input:
        r1="trimmed_reads/{replicate}_P_R1.fastq.gz",
        r2="trimmed_reads/{replicate}_P_R2.fastq.gz",
        index=f"{config['kallisto_index_prefix']}.idx"
    output:
        directory=directory("kallisto_quant/{replicate}"),
        abundance="kallisto_quant/{replicate}/abundance.h5",
        std_err="kallisto_reports/{replicate}.stderr"
    envmodules:
        "kallisto/0.51.1-gompi-2023b"
    resources:
        mem_mb=12000,
        cpus_per_task=8
    shell:
        "kallisto quant -i {input.index} -o {output.directory} -b 100 -t {resources.cpus_per_task} {input.r1} {input.r2} 2> {output.std_err}"


rule kallisto_stats:
    input:
        expand("kallisto_reports/{replicate}.stderr", replicate=REPLICATES["replicate_name"])
    output:
        "psuedoalignment_stats.html"
    envmodules:
        "MultiQC/1.28-foss-2024a"
    resources:
        mem_mb=4000,
        cpus_per_task=1
    params:
        directory="kallisto_reports"
    shell:
        """
        multiqc -f {params.directory} -n {output}
#        grep "p_pseudoaligned" kallisto_quant/*/run_info.json | awk -F'[/: ,]+' '{{print $2, $5}}' > {output}
        """