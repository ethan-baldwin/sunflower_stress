rule index:
    input:
        config['transcriptome']
    output:
        f"{config['index_prefix']}.idx"
    envmodules:
        "kallisto/0.51.1-gompi-2023a"
    resources:
        mem_mb=10000
    shell:
        "kallisto index -i {output} {input}"