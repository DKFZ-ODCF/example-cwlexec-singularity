#!/usr/bin/env cwlexec -w "$PWD/cwlexec" --exec-config lsf.json cowsay-cwlexec.cwl cowsay-cwlexec.yaml

cwlVersion: v1.0
class: CommandLineTool

# Do a `singularity pull docker://grycap/cowsay` no retrieve and convert the singularity image.

baseCommand:
  - "singularity"
  - "run"
  - "/icgc/dkfzlsdf/analysis/W610/kensche/WFMS/cwl/workflows/cowsay/grycap-cowsay.img"
  - "/usr/games/cowsay"

inputs:
  message:
    type: string
    inputBinding:
      position: 1

outputs:
  cowsaid:
    type: stdout
