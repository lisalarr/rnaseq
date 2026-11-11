#!/bin/bash
#SBATCH --account=class-467713-ws-2026
#SBATCH --partition=pibu_el8
#SBATCH --job-name=hisat2_map
#SBATCH --array=1-15
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=logs/06_map/%x_%A_%a.out
#SBATCH --error=logs/06_map/%x_%A_%a.err

# Map trimmed reads to GRCm39 (Ensembl 116), sort and index BAM files
# Tools: HISAT2 2.2.1, Samtools 1.20
# One array task per sample (sample IDs from metadata/samples.tsv)
# SAM output is piped directly into samtools sort (no SAM stored)

WORKDIR=/data/users/llarrass/rnaseq
INDEX=$WORKDIR/reference/hisat2_index/genome
TRIMDIR=$WORKDIR/results/03_trimmed_reads
OUTDIR=$WORKDIR/results/06_mapping
SIF=/containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif

cd $WORKDIR
mkdir -p $OUTDIR

# Get sample ID for this array task (skip header line)
SAMPLE=$(awk -v i=$SLURM_ARRAY_TASK_ID 'NR == i + 1 {print $1}' metadata/samples.tsv)
echo "Processing sample: $SAMPLE"

TMPDIR_SORT=$OUTDIR/tmp_${SAMPLE}
mkdir -p $TMPDIR_SORT

apptainer exec --bind /data:/data $SIF /bin/bash -c "
set -o pipefail
hisat2 -p 8 -x $INDEX \
    -1 $TRIMDIR/${SAMPLE}_1.trimmed.fastq.gz \
    -2 $TRIMDIR/${SAMPLE}_2.trimmed.fastq.gz \
    --rna-strandness RF \
    --summary-file $OUTDIR/${SAMPLE}_hisat2_summary.txt \
| samtools sort -m 1G -@ 4 -T $TMPDIR_SORT/${SAMPLE} \
    -o $OUTDIR/${SAMPLE}.sorted.bam##idx##$OUTDIR/${SAMPLE}.sorted.bam.bai \
    --write-index
"

rm -rf $TMPDIR_SORT