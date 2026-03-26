#!/bin/bash
#SBATCH -p amd_512
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 24

# wget https://github.com/sortmerna/sortmerna/releases/download/v4.3.7/sortmerna-4.3.7-conda-linux-64.tar.bz2 -P ~/software/
# mamba create --name sortmerna_env
# mamba activate sortmerna_env
# mamba install ~/software/sortmerna-4.3.7-conda-linux-64.tar.bz2
# which sortmerna  
# sortmerna -h

# mkdir -p ~/bioinfo_database/sortmerna_db
# 建议手动下载
# wget https://github.com/biocore/sortmerna/releases/download/v4.3.4/database.tar.gz -P ~/bioinfo_database/sortmerna_db
# mkdir -p ~/bioinfo_database/sortmerna_db/rRNA_databases_v4
# tar -xvf ~/bioinfo_database/sortmerna_db/database.tar.gz -C ~/bioinfo_database/sortmerna_db/rRNA_databases_v4

module load miniforge/24.11
source activate /public3/home/scg4618/.local/share/mamba/envs/sortmerna_env
db_path='/public3/home/scg4618/bioinfo_database/sortmerna_db/rRNA_databases_v4'

cd /public3/home/scg4618/thk/RNA-seq && mkdir sortmerna_workdir
cd /public3/home/scg4618/thk/RNA-seq/clean_reads
for sample in $(ls *_1.clean.fastq | sed 's/_1.clean.fastq//')
do
  echo "Processing $sample ..."

  sortmerna \
    --ref $db_path/smr_v4.3_default_db.fasta \
    --reads ${sample}_1.clean.fastq \
    --reads ${sample}_2.clean.fastq \
    --paired_in \
    --fastx \
    --other ../sortmerna_workdir/non_rRNA/${sample} \
    --aligned ../sortmerna_workdir/rRNA/${sample} \
    --threads 24 \
    --num_alignments 1 \
    --no-best \
    --workdir ../sortmerna_workdir/${sample}

done

