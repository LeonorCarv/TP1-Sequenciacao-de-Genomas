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
# ----------------------Download dos dados----------------------
# --------------------------------------------------------------
DIR_SAIDA := data/raw

# Illumina paired-out
ILLUMINA_ID=ERX2780812	# ID
ILLUMINA_RUN := ERR2767971	# Run Accession
ILLUMINA_VOLUME := 001
FASTQ_R1_ILLUMINA := $(DIR_SAIDA)/$(ILLUMINA_RUN)_1.fastq.gz
FASTQ_R2_ILLUMINA := $(DIR_SAIDA)/$(ILLUMINA_RUN)_2.fastq.gz

# Nanopore single-end
NANOPORE_ID=ERX4296810	# ID
NANOPORE_RUN := ERR4352271	# Run Accession
NANOPORE_VOLUME := 001
FASTQ_R1_NANOPORE := $(DIR_SAIDA)/$(NANOPORE_RUN)_1.fastq.gz


SCRIPT_DOWNLOAD := $(DIR_SCRIPTS)/download_ena.sh

# Nova regra PHONY para facilitar a chamada do download
.PHONY: dados
dados: $(FASTQ_R1_ILLUMINA) $(FASTQ_R2_ILLUMINA) $(FASTQ_R1_NANOPORE)

# Regra para descarregar os ficheiros FASTQ
$(FASTQ_R1_ILLUMINA) $(FASTQ_R2_ILLUMINA) &: $(SCRIPT_DOWNLOAD)
	@echo "Ficheiros FASTQ para $(ILLUMINA_RUN) não encontrados. A executar o download..."
	@test -f $@ || ./$(SCRIPT_DOWNLOAD) $(ILLUMINA_RUN) $(ILLUMINA_VOLUME) yes

$(FASTQ_R1_NANOPORE): $(SCRIPT_DOWNLOAD)
	@echo "Ficheiros FASTQ para $(NANOPORE_ID) não encontrados. A executar o download..."
	@test -f $@ || ./$(SCRIPT_DOWNLOAD) $(NANOPORE_RUN) $(NANOPORE_VOLUME) no

# Apagar/ editar a regra 'clean' existente para apagar também os dados descarregados
.PHONY: clean
clean:
	@echo "A remover ficheiros de resultados e dados brutos..."
	@rm -f $(FICHEIRO_RESULTADO)
	@rm -f $(DIR_SAIDA)/$(ILLUMINA_RUN)_*.fastq.gz
	@rm -f $(DIR_SAIDA)/$(NANOPORE_RUN)_*.fastq.gz



REFERENCE_ID=GCA_903989475



