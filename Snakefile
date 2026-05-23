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

rule bwa_map:
    input:
        ref="data/reference.fasta",
        reads="data/reads.fastq.gz"
    output:
        "results/mapped_reads.sam"
    shell:
        "bwa mem {input.ref} {input.reads} > {output}"

rule sam_to_bam:
    input:
        "results/mapped_reads.sam"
    output:
        "results/mapped_reads.bam"
    shell:
        "samtools view -Sb {input} > {output}"
