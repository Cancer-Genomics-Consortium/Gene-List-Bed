
# BED File Creation Instructions

This guide outlines the steps to create a BED file using gene information and the UCSC Genome Table Browser.

---

## 🧬 Step 1: Generate List of Unique Gene Names

1. Open the Excel file with gene data.
2. Copy the **Gene Names** column.
3. Use Excel’s **Remove Duplicates** feature.
4. Copy and paste the unique list into a **.txt file** and save it.

---

## 🌐 Step 2: Use UCSC Genome Table Browser

1. Go to **Tools → Table Browser**:  
   [https://genome.ucsc.edu/cgi-bin/hgTables](https://genome.ucsc.edu/cgi-bin/hgTables)
2. Select:
   - **Track**: `NCBI Refseq`
   - **Region**: `Genome`
3. Under **Identifiers**, click `Upload list` and upload the `.txt` file created in Step 1.
4. For **output**, choose:  
   `selected fields from primary and related tables`
5. Click **Get output**, then select the following fields:
   - `name`
   - `chrom`
   - `strand`
   - `txStart`
   - `txEnd`
   - `name2`
6. Click **Get Output** again.
7. Save the resulting gene list to a `.txt` file.
8. **Important:** Remove any chromosomes with `"fix"` in their names from the file.

---

## 🧪 Step 3: Setup R Environment

> You may need to download and install [R](https://cran.r-project.org/) and [RStudio](https://www.rstudio.com/).

### Install Required Packages

```r
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("REMP")
```

---

## 📂 Step 4: Set Working Directory and Load Files

1. Place the following in the same working directory:
   - Gene info Excel saved as `gene_info.txt`
   - UCSC output file (from Step 2)

2. Format your `gene_info.txt` with **exact column headers**:
   ```
   Genes	Significance.Level	Subtype	Type.of.Genomic.Abnormalities	Functional.Mechanism
   ```

### Example R Code:

```r
setwd("C:/YOUR FILE PATH HERE")

geneinfo <- read.delim("gene_info.txt", header = TRUE)
head(geneinfo)

genenames <- unique(geneinfo$Genes)
length(genenames)

geneinfo$Annotation <- paste0(
  geneinfo$Genes, "",
  geneinfo$Significance.Level, "",
  geneinfo$Subtype, "",
  geneinfo$Type.of.Genomic.Abnormalities, "",
  geneinfo$Functional.Mechanism
)
```

---

## 🧭 Step 5: Extract Genomic Coordinates

```r
chrloc <- function(x, y){  # choose either "hg19" or "hg38"
    library(REMP)
    refgene <- fetchRefSeqGene(annotation.source = "UCSC", genome = y, mainOnly=TRUE, verbose = TRUE)
    genetable <- NULL
    missing_genes <- c()

    for (i in 1:length(x)){
        matches <- which(refgene$GeneSymbol == x[i])
        if (length(matches) > 0) {
            generanges <- range(refgene[matches])
            generanges <- as.data.frame(generanges)
            generanges$name <- x[i]
            genetable <- rbind(genetable, generanges)
        } else {
            message(paste("Gene not found in reference:", x[i]))
            missing_genes <- c(missing_genes, x[i])
        }
    }
    write.table(missing_genes, "missing_genes.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
    return(genetable)
}
```

### Run with Genome Build

```r
# For hg19
geneloc.hg19 <- chrloc(genenames, "hg19")

# For hg38
geneloc.hg38 <- chrloc(genenames, "hg38")
```

---

## 🧷 Step 6: Annotate Gene Table

```r
# For hg19
geneloc.hg19$Annotation <- geneinfo$Annotation[match(geneloc.hg19$name, geneinfo$Genes)]
head(geneloc.hg19)

# For hg38
geneloc.hg38$Annotation <- geneinfo$Annotation[match(geneloc.hg38$name, geneinfo$Genes)]
head(geneloc.hg38)
```

---

## 🧾 Step 7: Export BED File

```r
write.table(
    geneloc.hg19[, c("seqnames", "start", "end", "Annotation")],
    "GENELISTNAME.bed",
    quote = FALSE,
    sep = "	",
    row.names = FALSE,
    col.names = FALSE
)
```

> Replace `"GENELISTNAME"` with an appropriate filename for your BED file.
