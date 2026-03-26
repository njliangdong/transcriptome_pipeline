#!/bin/bash
#SBATCH -p amd_512
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 24

module load miniforge/24.11
source activate /public3/home/scg4618/.conda/envs/trimmomatic-0.39
exe_path='/public3/home/scg4618/.conda/envs/trimmomatic-0.39/bin'
adapter_path='/public3/home/scg4618/.conda/envs/trimmomatic-0.39/share/trimmomatic-0.39-2/adapters'
threads=24

cd /public3/home/scg4618/thk/RNA-seq

for r1 in SRR*_1.fastq
do
    sample=${r1%_1.fastq}
    r2=${sample}_2.fastq

    echo "Processing $sample ..."

    $exe_path/trimmomatic PE -threads $threads -phred33 \
        $r1 $r2 \
        ${sample}_1.clean.fastq ${sample}_1.unpaired.fq \
        ${sample}_2.clean.fastq ${sample}_2.unpaired.fq \
        ILLUMINACLIP:$adapter_path/TruSeq3-PE.fa:2:30:10 \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50 \
        > ${sample}.trimlogfile
        
    rm ${sample}_1.unpaired.fq ${sample}_2.unpaired.fq
done
