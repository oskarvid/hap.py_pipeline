workflow VarRecAppRecHap {

# Input files
  File BedFile
  Array[File] Input
  Array[File] InputIndex

# Hap.py reference files
  File ref_fasta
  File ref_fasta_index
  File ref_sdf_fasta
  File GoldStandard

  scatter (Input_Vcf in Input) {
    call happy {
      input:
        ref_fasta = ref_fasta,
        ref_fasta_index = ref_fasta_index,
        ref_sdf_fasta = ref_sdf_fasta,
        Bed_File = BedFile,
        InputVcf = Input_Vcf,
        GoldStandard = GoldStandard,
        Output_Vcf_Name = "hap.py."
    }
  }
}
  task happy {
    File ref_fasta
    File ref_fasta_index
    File ref_sdf_fasta
    File GoldStandard
    File InputVcf
    File Bed_File
    String Output_Vcf_Name

    command {
      /opt/hap.py/bin/hap.py \
      --threads 4 \
      --engine-vcfeval-template ${ref_sdf_fasta} \
      -r ${ref_fasta} \
      ${GoldStandard} \
      ${InputVcf} \
      -o ${Output_Vcf_Name} \
      -f ${Bed_File} \
      --verbose
    }
    output {
      File happyrocindpass = "${Output_Vcf_Name}.roc.Locations.INDEL.PASS.csv.gz"
      File happyrocsnppass = "${Output_Vcf_Name}.roc.Locations.SNP.PASS.csv.gz"
      File happyroclocind = "${Output_Vcf_Name}.roc.Locations.INDEL.csv.gz"
      File happyroclocsnp = "${Output_Vcf_Name}.roc.Locations.SNP.csv.gz"
      File happymetrics = "${Output_Vcf_Name}.metrics.json.gz"
      File happyextended = "${Output_Vcf_Name}.extended.csv"
      File happyruninfo = "${Output_Vcf_Name}.runinfo.json"
      File happysummary = "${Output_Vcf_Name}.summary.csv"
      File happyvcfindex = "${Output_Vcf_Name}.vcf.gz.tbi"
      File happyall = "${Output_Vcf_Name}.roc.all.csv.gz"
      File happyroc = "${Output_Vcf_Name}.roc.tsv"
      File happyvcf = "${Output_Vcf_Name}.vcf.gz"
    }
    runtime {
      docker: "pkrusche/hap.py"
    }
  }