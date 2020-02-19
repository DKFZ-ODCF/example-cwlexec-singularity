# Example Singularity-based cluster job

## Local test

You can run the singularity container locally with cwltool as follows:

```bash
cwltool --singularity cowsay.cwl cowsay.yaml
```

This is just to validate, that the "workflow" actually runs.

## LSF test

The preferred tool to run the workflow on the LSF cluster, is cwlexec from IBM. In contrast to cwltool or toil it allows to set per-workflow resource requirements and queues (lsf.json).

Note that the CWL and configuration YAML are different than for cwltool.

```bash
cwlexec -w "$PWD" --exec-config lsf.json cowsay-singularity.cwl cowsay-cwlexec.yaml
```

### Differences to cwltool

cwltool is the reference implementation and thus the golden standard.

cwlexec cannot automatically convert Docker into Singularity images. Therefore the conversion needs to be done manually. Specifically the base-command is extended by the singularity command and the DockerRequirement needs to be removed.

