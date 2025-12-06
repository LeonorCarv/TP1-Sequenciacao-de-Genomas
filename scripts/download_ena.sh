#!/usr/bin/env bash
# Script para descarregar leituras paired-end do ENA

# ---Verificar se o accession foi passado como argumento---
if [ -z "$1" ]; then
	echo "Erro: É necessário fornecer um Run Accession do ENA como argumento"
	echo "Uso: $0 <ENA_RUN_ACCESSION>"
	exit 1
fi

set -e

# ---Variáveis---
ACCESSION="$1"
VOLUME="$2"
PAIRED="$3"
DIR_SAIDA="data/raw"
ENA_FTP_BASE="ftp.sra.ebi.ac.uk/vol1/fastq" # URL base do FTP do ENA para ficheiros FASTQ
PREFIXO_DIR="${ACCESSION:0:6}"

# URL - Read 1
URL_R1="ftp://${ENA_FTP_BASE}/${PREFIXO_DIR}/${VOLUME}/${ACCESSION}/${ACCESSION}_1.fastq.gz"
echo "A iniciar o download para o accession: $ACCESSION (R1)"
wget -P "$DIR_SAIDA" "$URL_R1"

# Apenas se for paired-end -> URL - Read 2
if [ "$PAIRED" = "yes" ]; then
	URL_R2="ftp://${ENA_FTP_BASE}/${PREFIXO_DIR}/${VOLUME}/${ACCESSION}/${ACCESSION}_2.fastq.gz"
	echo "A iniciar o download para o accession: $ACCESSION (R2)"
	wget -P "$DIR_SAIDA" "$URL_R2"
fi

echo "A guardar em $DIR_SAIDA"
echo "Download de $ACCESSION concluído."
