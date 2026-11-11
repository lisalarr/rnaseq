# Detect differentially expressed genes from bulk RNA-seq data

**Course**: RNA-Seq (467713), AS 2026 <br>
**Author:** Lisa Marie Larrass <br>
**Tissue analysed:** Lung

The workflow goes from raw Illumina reads (FASTQ) to lists of differentially expressed (DE) genes and enriched Gene Ontology (GO) terms.
It follows the course instructions *Detect differentially expressed genes from bulk RNA-seq data*.

## Background 
The data are a subset of [Singhania et al. 2019](https://doi.org/10.1038/s41467-019-10601-6).
The samples are from *Mus musculus*. The libraries are strand-specific (RF) and paired-end, and were sequenced on an Illumina HiSeq 4000.
The study describes how type I and type II interferon (IFN) signalling shapes the host transcriptional response to infection.
Here, wild type mice and mice lacking both the type I and type II IFN receptors (*Ifnar1*/*Ifngr1* double knockout, DKO) are compared, with and without *Toxoplasma gondii* infection.

## Workflow 
| Step | Description | Tool | Scripts |
|---|---|---|---|
| Quality checks | Quality control of raw reads and summary report; trimming and QC of trimmed reads | FastQC, MultiQC, fastp | `01_fastqc.sh`<br>`02_multiqc.sh`<br>`03_fastqc_trimmed.sh`<br>`04_multiqc_trimmed.sh` |
| Map reads to reference genome | Download genome + annotation (Ensembl) and verify checksums; build index; map reads; convert SAM → BAM, sort and index | HISAT2, Samtools | `05_build.sh`<br>`06_map.sh` |
| Count reads per gene | Count reads per gene from all BAM files | featureCounts | |
| Exploratory data analysis | Create DESeqDataSet, variance-stabilising transformation, PCA | DESeq2 | |
| Differential expression analysis | Extract results for pairwise contrast(s), count up-/down-regulated genes (padj < 0.05), normalised counts of genes of interest | DESeq2 | |
| Overrepresentation analysis | GO enrichment of DE genes against all measured genes | clusterProfiler, org.Mm.eg.db | |

## Repository structure 
```
scripts/     analysis scripts, numbered in run order
metadata/    sample sheet
results/     small outputs only (QC summaries, count summary, figures, tables)
report/      final report
```
Raw data, reference files and BAM/SAM files are not tracked (see `.gitignore`).

## References 
Singhania A, et al. (2019). Transcriptional profiling unveils type I and II interferon networks in blood and tissues across diseases. *Nature Communications* 10, 2887. https://doi.org/10.1038/s41467-019-10601-6
