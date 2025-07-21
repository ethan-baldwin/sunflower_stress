rule fastp:
    input:
        r1=lambda wildcards: f"raw_files/raw_reads_combined_runs/{get_sample_read1[wildcards.replicate]}",
        r2=lambda wildcards: f"raw_files/raw_reads_combined_runs/{get_sample_read2[wildcards.replicate]}"
    output:
        trimmed1="trimmed_reads/{replicate}_P_R1.fastq.gz",
        trimmed2="trimmed_reads/{replicate}_P_R2.fastq.gz",
        # Unpaired reads separately
        unpaired1="trimmed_reads/failed/{replicate}_U_R1.fastq.gz",
        unpaired2="trimmed_reads/failed/{replicate}_U_R2.fastq.gz",
        failed="trimmed_reads/failed/{replicate}.failed.fastq",
        html="fastp_report/{replicate}.html",
        json="fastp_report/{replicate}.json"
    log:
        "logs/fastp_{replicate}.log"
    envmodules:
        "fastp/0.23.2-GCC-11.3.0"
    resources:
        mem_mb=8000,
        cpus_per_task=4
    shell:
        "fastp -w {resources.cpus_per_task} --dont_overwrite --in1 {input.r1} --in2 {input.r2} --out1 {output.trimmed1} --out2 {output.trimmed2} --unpaired1 {output.unpaired1} --unpaired2 {output.unpaired2} --failed_out {output.failed} -j {output.json} -h {output.html}"