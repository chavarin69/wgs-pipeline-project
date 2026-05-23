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

rule download_reference:
    output:
        "data/reference.fasta"
    shell:
        "mkdir -p data && wget -O {output} https://raw.githubusercontent.com/eriqande/mega-non-model-wgs-snakeflow/master/.test/resources/genome.fasta"

rule download_reads:
    output:
        "data/reads.fastq.gz"
    shell:
        "mkdir -p data && wget -O {output} https://raw.githubusercontent.com/eriqande/mega-non-model-wgs-snakeflow/master/.test/data/pe_reads/s001---1_R1.fq.gz"

rule call_variants:
    input:
        ref="data/reference.fasta",
        bam="results/mapped_reads.bam"
    output:
        "results/variants.vcf"
    shell:
        "bcftools mpileup -Ou -f {input.ref} {input.bam} | bcftools call -mv -Ob -o {output}"

