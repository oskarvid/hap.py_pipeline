### Pipeline for haplotype comparisons

This pipeline will compare your vcf file with a gold standard to see how many of your variants 
are found in a gold standard. The first step will strip your vcf file from SNPs/INDELs, and then
compare the stripped file with the gold standard. A number of output files are produced with 
results regarding the number of SNPs and INDELs in your file compared to the gold standard, 
quality measures and other statistics. See https://github.com/Illumina/hap.py/ for more information
about what hap.py does.  



### Requirements  
The pipeline has been tested with docker version 17.09, GATK 4 and java 8 on Ubuntu 16.04.
You need a reference file for hap.py, you can download one from here if you don't have one already: ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle
There is no password. You can automatically download e.g the hg38 folder with this command:
wget -m ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/hg38
Depending on if you have the hg19 or hg38 reference file, you need to download the gold standard VCF from 
genome in a bottle (GIAB) from here: ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/latest/  

Now edit the variantrecalSNP_INDEL.json file and edit the file paths to your reference files etc.

Usage:  
First download cromwell using the download cromwell script:  
sh script/dl-cromwell.sh  
Then run the following scripts:  
1. sh scripts/start-mysql-server.sh to start the mysql server.  
2. sh scripts/start-cromwell.sh to start the cromwell webserver.  
Now that both cromwell and the mysql server are running, the following script will start the 
pipeline with a small sample input file located in the data folder.
3. sh scripts/start-pipeline.sh

It should run fine on a laptop with four cores and 8GB RAM with the test file, but can consume 
up to 64 GB RAM and 40 cores per VCF file depending on the scenario. Although when used with an 
exome bed file, like the one supplied in this repository, you'll have a decent margin on a machine 
with 32GB RAM using an input VCF that's 1GB.
