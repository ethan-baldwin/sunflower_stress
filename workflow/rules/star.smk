rule index_star:
    input:
        config['transcriptome']
    output:
        directory("star_index")
    envmodules:
        "STAR/2.7.11b-GCC-13.3.0"
    resources:
        mem_mb=50000,
        cpus_per_task=12
    params:
        genome=config["genome_path"],
        gff=config["gff_path"]
    shell:
        "STAR --runThreadN {resources.cpus_per_task} --runMode genomeGenerate --genomeDir {output} --genomeFastaFiles {params.genome} --sjdbGTFfile {params.gff} --sjdbGTFtagExonParentTranscript Parent"

rule star:
    input:
        r1="trimmed_reads/{replicate}_P_R1.fastq.gz",
        r2="trimmed_reads/{replicate}_P_R2.fastq.gz",
        index="star_index"
    output:
        directory=directory("star_out/{replicate}"),
        abundance="star_out/{replicate}/Log.final.out"
    envmodules:
        "STAR/2.7.11b-GCC-13.3.0"
    resources:
        mem_mb=60000,
        cpus_per_task=16
    shell:
        "STAR --runThreadN {resources.cpus_per_task} --genomeDir {input.index} --readFilesIn {input.r1} {input.r2} --readFilesCommand zcat --outFileNamePrefix {output.directory}/"

rule star_stats:
    input:
        expand("star_out/{replicate}/Log.final.out", replicate=REPLICATES["replicate_name"])
    output:
        "star_alignment_stats.txt"
    resources:
        mem_mb=4000,
        cpus_per_task=1
    shell:
        """
        grep "Uniquely mapped reads %" star_out/*/Log.final.out > {output}
        """