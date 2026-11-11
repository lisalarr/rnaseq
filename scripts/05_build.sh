#!/bin/bash
#SBATCH --account=class-467713-ws-2026
#SBATCH --partition=pibu_el8
#SBATCH --job-name=hisat2_build
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=03:00:00
#SBATCH --output=logs/05_build/%x_%j.out
#SBATCH --error=logs/05_build/%x_%j.err

# Build HISAT2 index for mouse reference 
# Reference: GRCm39, Ensembl release 116 (downloaded manually, checksums verified)
# Tool: HISAT2 2.2.1

WORKDIR=/data/users/llarrass/rnaseq
REFDIR=$WORKDIR/reference
SIF=/containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif

cd $WORKDIR
mkdir -p $REFDIR/hisat2_index

apptainer exec --bind /data:/data $SIF \
    hisat2-build -p 8 \
    $REFDIR/Mus_musculus.GRCm39.dna.primary_assembly.fa \
    $REFDIR/hisat2_index/genome