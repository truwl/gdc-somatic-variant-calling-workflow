#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/awscli:1
  - class: EnvVarRequirement
    envDef:
      - envName: "AWS_CONFIG_FILE"
        envValue: $(inputs.aws_config_file.path)
      - envName: "AWS_SHARED_CREDENTIALS_FILE"
        envValue: $(inputs.aws_shared_credentials_file.path)
  - class: InlineJavascriptRequirement

inputs:
  - id: aws_config_file
    type: File

  - id: aws_shared_credentials_file
    type: File

  - id: s3cfg_section
    type: string
    inputBinding:
      prefix: --profile
      position: 2

  - id: endpoint_url
    type: string
    inputBinding:
      prefix: --endpoint-url
      position: 3

  - id: s3url
    type: string
    inputBinding:
      position: 4

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.s3url.split('/').slice(-1)[0])

baseCommand: [aws]
arguments:
  - valueFrom: s3
    position: 0

  - valueFrom: cp
    position: 1

  - valueFrom: .
    position: 99
