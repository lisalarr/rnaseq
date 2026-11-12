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

| Group | Genotype | Infection | Samples |
|---|---|---|---|
| Lung_WT_Case | Wild type | *T. gondii* | 5 |
| Lung_WT_Control | Wild type | Uninfected | 3 |
| Lung_DKO_Case | IFNAR/IFNGR DKO | *T. gondii* | 4 |
| Lung_DKO_Control | IFNAR/IFNGR DKO | Uninfected | 3 |

Sample IDs: [`metadata/samples.tsv`](metadata/samples.tsv)

## Workflow 
Adapted from the DifferentialGeneExpression_projects slides provided in the course (slide 5): 
```
todo
```

| Step | Description | Tool | Scripts |
|---|---|---|---|
| Getting started | Set up working directory, link raw data, initialise Git repository, create sample sheet | Git, Apptainer | – |
| Quality checks | Quality control of raw reads and summary report; adapter/quality trimming and QC of trimmed reads | FastQC, MultiQC, fastp | [`01_fastqc.sh`](scripts/01_fastqc.sh)<br>[`02_multiqc.sh`](scripts/02_multiqc.sh)<br>[`03_fastqc_trimmed.sh`](scripts/03_fastqc_trimmed.sh)<br>[`04_multiqc_trimmed.sh`](scripts/04_multiqc_trimmed.sh) |
| Map reads to the reference genome | Download genome + annotation (Ensembl) and verify checksums (manually, see below); build index; map trimmed reads; sort and index BAM files | HISAT2, Samtools | [`05_build.sh`](scripts/05_build.sh)<br>[`06_map.sh`](scripts/06_map.sh) |
| Count reads per gene | Count reads per gene from all BAM files | featureCounts | |
| Exploratory data analysis | Create DESeqDataSet, variance-stabilising transformation, PCA | DESeq2 | |
| Differential expression analysis | Extract results for pairwise contrast(s), count up-/down-regulated genes (padj < 0.05), normalised counts of genes of interest | DESeq2 | |
| Overrepresentation analysis | GO enrichment of DE genes against all measured genes | clusterProfiler, org.Mm.eg.db | |

## Software and reference
 
| | Version |
|---|---|
| Reference genome | GRCm39, Ensembl release 116 |
| FastQC | 0.12.1 |
| MultiQC | 1.33 |
| fastp | 0.24.1 |
| HISAT2 / Samtools | 2.2.1 / 1.20 |
 
Cluster tools were run in Apptainer containers from `/containers/apptainer/`. Container paths and Slurm resources are listed in the script headers.
 
Reference files were downloaded manually from Ensembl release 116 (`Mus_musculus.GRCm39.dna.primary_assembly.fa.gz`, `Mus_musculus.GRCm39.116.gtf.gz`) and verified with `sum` against the Ensembl CHECKSUMS files

## Repository structure 
```
.
├── logs
│   ├── 01_fastqc
│   ├── 02_multiqc
│   ├── 03_fastqc_trimmed
│   ├── 04_multiqc_trimmed
│   ├── 05_build
│   └── 06_map
├── metadata
├── raw_data -> /data/courses/rnaseq_course/toxoplasma_de/reads_Lung
├── reference
│   ├── hisat2_index
│   └── logs
├── results
│   ├── 01_fastqc
│   ├── 03_fastqc_trimmed
│   ├── 03_trimmed_reads
│   └── 04_multiqc_trimmed
└── scripts
```

Subfolders in `logs/` and `results/` use the same numbers as the scripts that produce them.
Raw data, reference files, trimmed reads and BAM files are not tracked (see `.gitignore`).

## References 
- Singhania A, et al. (2019). Transcriptional profiling unveils type I and II interferon networks in blood and tissues across diseases. *Nature Communications* 10, 2887. https://doi.org/10.1038/s41467-019-10601-6.
- Course instructions: *Detect differentially expressed genes from bulk RNA-seq data*. RNA-Seq course (467713), University of Bern, AS 2026.
