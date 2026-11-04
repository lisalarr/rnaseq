#!/bin/bash
#SBATCH --account=class-467713-ws-2026
#SBATCH --job-name=fastqc
#SBATCH --cpus-per-task=1
#SBATCH --mem=1000M
#SBATCH --time=01:00:00
#SBATCH --output=logs/fastqc_%j.out
#SBATCH --error=logs/fastqc_%j.err

# Tool: FastQC 0.12.1
apptainer exec /containers/apptainer/fastqc-0.12.1.sif \
    fastqc -t 1 -o results/01_fastqc raw_data/*.f*q.gz
