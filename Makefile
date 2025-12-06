# Makefile

# --------------------------------------------------------------
# --------Automatizar a análise de qualidade dos scripts--------
# --------------------------------------------------------------

# ---Configurações---
DIR_SCRIPTS := scripts
# Econtrar dinamicamente todos os scripts
SCRIPTS_A_ANALISAR := $(wildcard $(DIR_SCRIPTS)/*.sh)
# Fichiero de saída que irá guardar o resultado da análise
FICHEIRO_RESULTADO := logs/analise_qualidade.log

# ---Regras---
# Regra Default
.PHONY: all # .PHONY diz ao make que 'all' não é um ficheiro real
all: $(FICHEIRO_RESULTADO)
# Regra Principal
$(FICHEIRO_RESULTADO): $(SCRIPTS_A_ANALISAR) # verificar se algum script é mais recente
	@echo "Um ou mais scripts foram modificados. A executar a análise de qualidade"
	@./$(DIR_SCRIPTS)/analisar_scripts.sh > $(FICHEIRO_RESULTADO)
	@echo "Análise concluída. Resultados guardados em $(FICHEIRO_RESULTADO)"

# --------------------------------------------------------------
# Download
# --------------------------------------------------------------
DIR_SAIDA := data/raw

# Illumina paired-out
ILLUMINA_ID=ERX2780812	# ID
ILLUMINA_RUN := ERR2767971
ILLUMINA_VOLUME := 001
FASTQ_R1_ILLUMINA := $(DIR_SAIDA)/$(ILLUMINA_RUN)_1.fastq.gz
FASTQ_R2_ILLUMINA := $(DIR_SAIDA)/$(ILLUMINA_RUN)_2.fastq.gz

# Nanopore single-end
NANOPORE_ID=ERX4296810	# ID
NANOPORE_RUN := ERR4352271
NANOPORE_VOLUME := 001
FASTQ_R1_NANOPORE := $(DIR_SAIDA)/$(NANOPORE_RUN)_1.fastq.gz


SCRIPT_DOWNLOAD := $(DIR_SCRIPTS)/download_ena.sh

# Nova regra PHONY para facilitar a chamada do download
.PHONY: dados
dados: illumina nanopore

.PHONY: illumina
# Regra para descarregar os ficheiros FASTQ
illumina: $(SCRIPT_DOWNLOAD)
	@./$(SCRIPT_DOWNLOAD) $(ILLUMINA_RUN) $(ILLUMINA_VOLUME) yes

.PHONY: nanopore
nanopore: $(SCRIPT_DOWNLOAD)
	@./$(SCRIPT_DOWNLOAD) $(NANOPORE_RUN) $(NANOPORE_VOLUME) no

# Apagar/ editar a regra 'clean' existente para apagar também os dados descarregados
.PHONY: clean
clean:
	@echo "A remover ficheiros de resultados e dados brutos..."
	@rm -fv $(FICHEIRO_RESULTADO)
	echo "$(DIR_SAIDA)/$(ILLUMINA_RUN)_*.fastq.gz"
	@rm -fv $(DIR_SAIDA)/$(ILLUMINA_RUN)_*.fastq.gz
	@rm -fv $(DIR_SAIDA)/$(NANOPORE_RUN)_*.fastq.gz



REFERENCE_ID=GCA_903989475


# --------------------------------------------------------------
# QC
# --------------------------------------------------------------
.PHONY: qc
qc:
	fastqc data/raw/*.fastq.gz -o results/qc

