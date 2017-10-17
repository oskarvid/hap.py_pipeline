workflow VarRecAppRecHap {

# Input files
  File SnpInput
  File IndelInput
  File SnpInputIndex
  File IndelInputIndex

# Hap.py reference files
  File ref_fasta
  File ref_fasta_index
  File ref_sdf_fasta
  File GoldStandardSNP
  File GoldStandardINDEL

  call SelectVariants as SelVarSNP {
    input:
      Input_Vcf = SnpInput,
      Mode = "INDEL",
      Output_Vcf_Name = "selectVar.applyRec.SNP",
  }

  call SelectVariants as SelVarINDEL {
    input:
      Input_Vcf = IndelInput,
      Mode = "SNP",
      Output_Vcf_Name = "selectVar.applyRec.INDEL",
  }
  call happy as happySNP {
    input:
      ref_sdf_fasta = ref_sdf_fasta,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      GoldStandard = GoldStandardSNP,
      Input_Vcf = SelVarSNP.selVar,
      Output_Vcf_Name = "hap.py.selectVar.applyRec.SNP"
  }

  call happy as happyINDEL {
    input:
      ref_sdf_fasta = ref_sdf_fasta,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      GoldStandard = GoldStandardINDEL,
      Input_Vcf = SelVarINDEL.selVar,
      Output_Vcf_Name = "hap.py.selectVar.applyRec.INDEL"
  }
}

  task SelectVariants {
    File Input_Vcf
    String Mode
    String Output_Vcf_Name

    command {
      gatk-launch \
      SelectVariants \
      --variant ${Input_Vcf} \
      -O ${Output_Vcf_Name}.vcf \
      --selectTypeToExclude ${Mode}
    }
    output {
      File selVar = "${Output_Vcf_Name}.vcf"
      File selVarIndex = "${Output_Vcf_Name}.vcf.idx"
    }
  }

  task happy {
    File ref_fasta
    File ref_fasta_index
    File ref_sdf_fasta
    File GoldStandard
    File Input_Vcf
    String Output_Vcf_Name

    command {
      /opt/hap.py/bin/hap.py \
      --threads 16 \
      --engine-vcfeval-template ${ref_sdf_fasta} \
      -r ${ref_fasta} \
      ${GoldStandard} \
      ${Input_Vcf} \
      -o ${Output_Vcf_Name} \
      --pass-only \
      -V \
      --roc GQX \
      --engine vcfeval \
      --verbose
    }
    output {
      File happyextended = "${Output_Vcf_Name}.extended.csv"
      File happymetrics = "${Output_Vcf_Name}.metrics.json.gz"
      File happyall = "${Output_Vcf_Name}.roc.all.csv.gz"
      File happyroclocind = "${Output_Vcf_Name}.roc.Locations.INDEL.csv.gz"
      File happyrocindpass = "${Output_Vcf_Name}.roc.Locations.INDEL.PASS.csv.gz"
      File happyroclocsnp = "${Output_Vcf_Name}.roc.Locations.SNP.csv.gz"
      File happyrocsnppass = "${Output_Vcf_Name}.roc.Locations.SNP.PASS.csv.gz"
      File happyroc = "${Output_Vcf_Name}.roc.tsv"
      File happyruninfo = "${Output_Vcf_Name}.runinfo.json"
      File happysummary = "${Output_Vcf_Name}.summary.csv"
      File happyvcf = "${Output_Vcf_Name}.vcf.gz"
      File happyvcfindex = "${Output_Vcf_Name}.vcf.gz.tbi"
    }
    runtime {
      docker: "pkrusche/hap.py"
    }
  }