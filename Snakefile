rule all:
    input:
        "results/variants.vcf"

rule fastqc:
    input:
        "data/reads.fastq.gz"
    output:
        "results/qc/reads_fastqc.html",
        "results/qc/reads_fastqc.zip"
    shell:
        "fastqc {input} -o results/qc/"
