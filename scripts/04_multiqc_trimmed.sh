#!/bin/bash
#SBATCH --account=class-467713-ws-2026
#SBATCH --partition=pibu_el8
#SBATCH --job-name=multiqc_trimmed
#SBATCH --cpus-per-task=1
#SBATCH --mem=2000M
#SBATCH --time=00:30:00
#SBATCH --output=logs/04_multiqc_trimmed/%x_%j.out
#SBATCH --error=logs/04_multiqc_trimmed/%x_%j.err

# Summary report after fastp; for trimmed fastqc's
# Tool: MultiQC 1.33

WORKDIR=/data/users/llarrass/rnaseq
OUTDIR=$WORKDIR/results/04_multiqc_trimmed

cd $WORKDIR
mkdir -p $OUTDIR

apptainer exec --bind /data:/data /containers/apptainer/multiqc-1.33.sif \
    multiqc results/03_trimmed_reads results/03_fastqc_trimmed -o $OUTDIR