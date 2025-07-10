#!/bin/bash
#SBATCH --job-name=combine_reads
#SBATCH --partition=batch
#SBATCH --mail-type=END,FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2gb
#SBATCH --time=2:00:00
#SBATCH --array=1-1143
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.err

cd $SLURM_SUBMIT_DIR

prefix=$(awk "NR==${SLURM_ARRAY_TASK_ID}" read_prefixes.txt)

READS_DIR="/scratch/eab77806/salt_stress/raw_files/raw_reads"

cat ${READS_DIR}/${prefix}_L001_R1_001.fastq.gz ${READS_DIR}/${prefix}_L002_R1_001.fastq.gz ${READS_DIR}/${prefix}_L003_R1_001.fastq.gz ${READS_DIR}/${prefix}_L004_R1_001.fastq.gz > raw_reads_combined_lanes/${prefix}_R1_001.fastq.gz
cat ${READS_DIR}/${prefix}_L001_R2_001.fastq.gz ${READS_DIR}/${prefix}_L002_R2_001.fastq.gz ${READS_DIR}/${prefix}_L003_R2_001.fastq.gz ${READS_DIR}/${prefix}_L004_R2_001.fastq.gz > raw_reads_combined_lanes/${prefix}_R2_001.fastq.gz
