#!/usr/bin/env bash
set -euxo pipefail

# From fork: https://github.com/tonyo/tpm/
REVISION="47a8e9b34bfdf2f4e2bfcecb2b42f5319a20b73c"
TPM_DIR=${HOME}/.tmux/plugins/tpm

mkdir -p "${TPM_DIR}"

git clone https://github.com/tonyo/tpm "${TPM_DIR}"
cd "${TPM_DIR}"
git checkout -f "${REVISION}"

echo 'Done.'
