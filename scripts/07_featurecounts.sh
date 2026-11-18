#!/bin/bash
#SBATCH --account=class-467713-ws-2026
#SBATCH --partition=pibu_el8
#SBATCH --job-name=featurecounts
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --time=02:00:00
#SBATCH --output=logs/07_featurecounts/%x_%j.out
#SBATCH --error=logs/07_featurecounts/%x_%j.err

WORKDIR=/data/users/${USER}/rnaseq
BAMDIR=${WORKDIR}/results/06_mapping
GTF=${WORKDIR}/reference/Mus_musculus.GRCm39.116.gtf
OUTDIR=${WORKDIR}/results/07_featurecounts
CONTAINER=/containers/apptainer/subread_2.0.6.sif

mkdir -p "${OUTDIR}"

# all sorted bams (= column order in count table)
BAMS=$(ls ${BAMDIR}/*.sorted.bam)
echo "Number of BAM files: $(echo ${BAMS} | wc -w)"
echo "${BAMS}" | tr ' ' '\n'

# log tool version for reproducibility
apptainer exec --bind /data "${CONTAINER}" featureCounts -v 

# featurecounts 
apptainer exec --bind /data "${CONTAINER}" \
    featureCounts \
        -T ${SLURM_CPUS_PER_TASK} \
        -p --countReadPairs \
        -s 2 \
        -t exon \
        -g gene_id \
        --extraAttributes gene_name,gene_biotype \
        -a "${GTF}" \
        -o "${OUTDIR}/gene_counts.txt" \
        ${BAMS}

# per-sample summary for the report with proportions relative to all fragments listed in .summary
awk -F'\t' '
NR==1 { for (i=2; i<=NF; i++) { n=split($i, p, "/"); s=p[n]; sub(/\.sorted\.bam$/, "", s); name[i]=s }; nc=NF; next }
{
  for (i=2; i<=NF; i++) {
    tot[i] += $i
    if ($1=="Assigned")                ass[i]=$i
    if ($1=="Unassigned_Ambiguity")    amb[i]=$i
    if ($1=="Unassigned_MultiMapping") mm[i]=$i
    if ($1=="Unassigned_NoFeatures")   nof[i]=$i
  }
}
END {
  OFS="\t"
  print "sample","total_fragments","assigned","assigned_pct","ambiguity","ambiguity_pct","multimapping_pct","no_features_pct"
  for (i=2; i<=nc; i++) {
    printf "%s\t%d\t%d\t%.2f\t%d\t%.2f\t%.2f\t%.2f\n", name[i], tot[i], ass[i], 100*ass[i]/tot[i], amb[i], 100*amb[i]/tot[i], 100*mm[i]/tot[i], 100*nof[i]/tot[i]
    sa+=100*ass[i]/tot[i]; sb+=amb[i]; sbp+=100*amb[i]/tot[i]; k++
  }
  printf "MEAN\t\t\t%.2f\t%.0f\t%.2f\t\t\n", sa/k, sb/k, sbp/k
}' "${OUTDIR}/gene_counts.txt.summary" > "${OUTDIR}/featurecounts_summary.tsv"

column -t -s $'\t' "${OUTDIR}/featurecounts_summary.tsv"
echo "Done."