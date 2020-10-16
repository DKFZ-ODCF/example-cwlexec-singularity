# Ungulates Say! 

An example Singularity-based CWL-workflow to be run on IBM Spectrum LSF. This focuses much on [cwlexec](https://github.com/IBMSpectrumComputing/cwlexec) as an LSF-specific CWL workflow management system and how to use it to run Singularity containers. CWLexec uses LSF application profiles for this. Singularity is used, because it is a safe container system to be used in multi-user clusters.

## Run the containers locally with cwltool

You can run the singularity container locally with cwltool as follows:

```bash
cwltool --singularity cowsay.cwl cowsay.yaml
```

This is just to validate, that the "workflow" actually runs. Note that cwltool will actually pull the Docker-container for you and convert it into a Singularity container.

## Run the container on the cluster with cwlexec

In contrast to cwltool, cwlexec (tested with 0.2.2) does not pull the container by itself. Therefore, you first need to get the it.

### Get the Containers

First start by retrieving two containers. Two containers are needed to demonstrate how CWLexec uses works with different containers using the application profile. CWLexec cannot automatically convert Docker into Singularity images. Therefore the containers are pulled and converted manually. 

So, first pull the cowsay Docker container, convert it to Singularity, and test it to see what you can expect to obtain from the "workflows":

```bash
singularity pull docker://grycap/cowsay
singularity run grycap-cowsay.sif /usr/games/cowsay "hello"
```

Now pull the whalesay container and convert it and test it:

```bash
singularity pull --name docker_whalesay.sif docker://docker/whalesay
singularity run docker_whalesay.sif /usr/local/bin/cowsay "HULLOH"
```

Note that although the whalesay-container has a cowsay-binary, it is located in a different path.

### Now to CWLexec

The preferred tool to run the workflow on the LSF cluster is cwlexec from IBM. In contrast to cwltool or toil, it allows to set per-workflow resource requirements and queues (`lsf.json`). To run Singularity in the LSF cluster, however, it needs a working application profile. Your admins may have already defined a profile for all LSF users. Check with `bapp` on your head-node to get a list of profiles.

Before you can execute the workflows, you need to configure the paths to the containers in the CWL files (if you find a way to provide these during execution of CWLexec, I'd be interested to learn how!). The path is given in the `hints` block at the top of files in the `dockerPull` line. E.g.

```yaml
hints:
  DockerRequirement:
    dockerPull: /path/to/your/docker_whalesay.sif
```

If you use a relative path, then cwlexec assumes it to below the 


```bash
cwlexec -w "$PWD" --exec-config lsf.json cowsay-cwlexec.cwl cowsay.yaml
```

This will run the workflow using the `cwlexec2` application profile as defined in the `lsf.json`.

Now the same for a whale:

```bash
cwlexec -w "$PWD" --exec-config lsf.json whalesay-cwlexec.cwl whalesay.yaml
```

Note that both calls use the same `lsf.json`. We let the cow and the whale say different things, so you we use a a `cowsay.yaml` and a `whalesay.yaml`. 

