# Makefile

# ===1. Automatizar a análise de qualidade dos scripts===

# ------Configurações------
DIR_SCRIPTS := scripts
# Econtrar dinamicamente todos os scripts
SCRIPTS_A_ANALISAR := $(wildcard $(DIR_SCRIPTS)/*.sh)
# Fichiero de saída que irá guardar o resultado da análise
FICHEIRO_RESULTADO := logs/analise_qualidade.log

# ------Regras------
# Regra Default
.PHONY: all # .PHONY diz ao make que 'all' não é um ficheiro real
all: $(FICHEIRO_RESULTADO)
# Regra Principal
$(FICHEIRO_RESULTADO): $(SCRIPTS_A_ANALISAR) # verificar se algum script é mais recente
	@echo "Um ou mais scripts foram modificados. A executar a análise de qualidade"
	@./$(DIR_SCRIPTS)/analisar_scripts.sh > $(FICHEIRO_RESULTADO)
	@echo "Análise concluída. Resultados guardados em $(FICHEIRO_RESULTADO)"
# Regra para limpar os ficheiros gerados. Útil para recomeçar
.PHONY: clean
clean:
	@echo "A remover ficheiro de resultados gerado"
	@rm -f $(FICHEIRO_RESULTADO)
