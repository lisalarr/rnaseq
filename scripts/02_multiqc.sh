#!/bin/bash
#SBATCH --account=class-467713-ws-2026
#SBATCH --partition=pibu_el8
#SBATCH --job-name=multiqc
#SBATCH --cpus-per-task=1
#SBATCH --mem=2000M
#SBATCH --time=00:30:00
#SBATCH --output=logs/multiqc_%j.out
#SBATCH --error=logs/multiqc_%j.err

# Summary report of FastQC results (raw reads)
# Tool: MultiQC 1.33

WORKDIR=/data/users/llarrass/rnaseq
OUTDIR=$WORKDIR/results/02_multiqc

cd $WORKDIR
mkdir -p $OUTDIR

apptainer exec --bind /data:/data /containers/apptainer/multiqc-1.33.sif \
    multiqc results/01_fastqc -o results/01_fastqc/multiqc
