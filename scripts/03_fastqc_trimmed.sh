#!/bin/bash
#SBATCH --account=class-467713-ws-2026
#SBATCH --partition=pibu_el8
#SBATCH --job-name=fastp_fastqc
#SBATCH --array=1-15
#SBATCH --cpus-per-task=4
#SBATCH --mem=4000M
#SBATCH --time=02:00:00
#SBATCH --output=logs/03_fastqc_trimmed/%x_%A_%a.out
#SBATCH --error=logs/03_fastqc_trimmed/%x_%A_%a.err

# Adapter/quality trimming of raw reads and QC of trimmed reads
# Tools: fastp 0.24.1, FastQC 0.12.1 

WORKDIR=/data/users/llarrass/rnaseq
TRIMDIR=$WORKDIR/results/03_trimmed_reads
QCDIR=$WORKDIR/results/03_fastqc_trimmed
FASTP_SIF=/containers/apptainer/fastp_0.24.1.sif
FASTQC_SIF=/containers/apptainer/fastqc-0.12.1.sif

cd $WORKDIR
mkdir -p $TRIMDIR $QCDIR

# Get sample ID for this array task (skip header)
SAMPLE=$(awk -v i=$SLURM_ARRAY_TASK_ID 'NR == i + 1 {print $1}' metadata/samples.tsv)
echo "Processing sample: $SAMPLE"

# Trimming
apptainer exec --bind /data:/data $FASTP_SIF \
    fastp \
    -i raw_data/${SAMPLE}_1.fastq.gz \
    -I raw_data/${SAMPLE}_2.fastq.gz \
    -o $TRIMDIR/${SAMPLE}_1.trimmed.fastq.gz \
    -O $TRIMDIR/${SAMPLE}_2.trimmed.fastq.gz \
    --detect_adapter_for_pe \
    -w 4 \
    -j $TRIMDIR/${SAMPLE}_fastp.json \
    -h $TRIMDIR/${SAMPLE}_fastp.html

# QC of trimmed reads
apptainer exec --bind /data:/data $FASTQC_SIF \
    fastqc -t 2 -o $QCDIR \
    $TRIMDIR/${SAMPLE}_1.trimmed.fastq.gz \
    $TRIMDIR/${SAMPLE}_2.trimmed.fastq.gz