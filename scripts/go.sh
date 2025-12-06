#!/usr/bin/env bash
# shellcheck disable=SC1091

set -e # Parar em caso de Erro

#set -x # Debug


# Mudar para o diretório raíz do projeto
#cd "$(dirname "$0")/.."


#chmod +x scripts/go.sh # Ajustar permissões

NOME_AMBIENTE="genomica_tp1"
ENV_FILE="env/environment.yml"

echo "Verificar se o ambiente '$NOME_AMBIENTE' existe"
#if conda env list | grep -q "$NOME_AMBIENTE"; then
#	echo "Ambiente já existe. A removê-lo para garantir reprodutibilidade"
#	conda env remove -n "$NOME_AMBIENTE" -y
#fi
#echo "Criar ambiente a partir de '$ENV_FILE'."
#conda env create -f "$ENV_FILE"
#echo "Ambiente criado com sucesso."

if conda env list | grep -q "$NOME_AMBIENTE"; then
	echo "Ambiente já existe"
else
	echo "Criar ambiente"
	conda env create -f "$ENV_FILE"
fi
echo ""


echo "Ativar ambiente Conda"
# Inicializar conda dentro de scripts
source "$(conda info --base)/etc/profile.d/conda.sh"
# Ativar o ambiente
conda activate "$NOME_AMBIENTE"
echo "Ambiente ativo: $CONDA_DEFAULT_ENV"

echo "Executar Makefile"
make all
