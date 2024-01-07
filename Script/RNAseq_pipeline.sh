#!/bin/bash

SECONDS=0

cd /Users/jeffwang/VSCode_Workspace/RNAseq_pipeline

# fastqc
fastqc Data/data.fastq -o Data/
echo "FastQC done."

# trim
java -jar "/Users/jeffwang/Libraries/Trimmomatic-0.39/trimmomatic-0.39.jar" SE -threads 4 Data/data.fastq Data/data_trimmed.fastq TRAILING:10 -phred33
echo "Trimmomatic done."

# fastqc trimmed
fastqc Data/data_trimmed.fastq -o Data/
echo "FastQC on trimmed data done."

# hisat2
hisat2 -q --rna-strandness R -x /Users/jeffwang/Libraries/HISAT2/grch38/genome -U Data/data_trimmed.fastq | samtools sort -o HISAT2/data_trimmed.bam
echo "HISAT2 done."
# samtools view -h HISAT2/data_trimmed.bam | less

# featureCounts
featureCounts -S 2 -a /Users/jeffwang/Libraries/hg38/Homo_sapiens.GRCh38.110.gtf -o Quants/data_featurecounts.txt HISAT2/data_trimmed.bam
echo "featureCounts done."
# cat Quants/data_featurecounts.txt| cut -f1,7 | less

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds."