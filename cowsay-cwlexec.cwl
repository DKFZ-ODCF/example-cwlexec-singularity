#!/usr/bin/env cwlexec -w "$PWD/cwlexec" --exec-config lsf.json cowsay-cwlexec.cwl cowsay.yaml

cwlVersion: v1.0

# CWLexec does not automatically convert a remote Docker image into a Singularity image. Therefore 
# get the image with `singularity pull /path/to/your/grycap-cowsay.sif docker://grypcap/cowsay`

class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}

hints:
  DockerRequirement:
    dockerPull: grycap-cowsay.sif

inputs:
  message:
    type: string

outputs:
  ungulateSaid:
    label: Ungulate words
    type: File
    outputSource: say/words

steps:
  say:
    in:
      message: message
    out:
      [words]
    run:
      class: CommandLineTool
      requirements:
        - class: ResourceRequirement
          coresMin: 1
          coresMax: 1
          ramMin: 50M
          ramMax: 50M
      inputs:
        message:
          type: string
          inputBinding:
            position: 1
      # If there is not application profile:
      # baseCommand:
      #   - "source /etc/profile;"
      #   - "singularity"
      #   - "run"
      #   - "docker://grypcap/cowsay:latest"
      #   - "/usr/games/cowsay"
      baseCommand:
        - "/usr/games/cowsay"
      outputs:
        words:
          type: stdout
