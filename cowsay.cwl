#!/usr/bin/env cwltool --singularity cowsay.cwl cowsay.yaml

cwlVersion: v1.0
class: CommandLineTool

requirements:
  DockerRequirement:
    dockerPull: grycap/cowsay

baseCommand:
  - "/usr/games/cowsay"

inputs:
  message:
    type: string
    inputBinding:
      position: 1

outputs:
  cowsaid:
    type: stdout
