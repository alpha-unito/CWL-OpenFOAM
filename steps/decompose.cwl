cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.case_dir)
        entryname: case
        writable: true

baseCommand: [decomposePar]

inputs:
  size: string?
  case_dir:
    type: Directory
    inputBinding:
      prefix: -case
      position: 1
  decompseDic:
    type: string
    default: system/decomposeParDict
    inputBinding:
      prefix: -decomposeParDict
      position: 2


outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

stdout: log.decomposePar
stderr: log.decomposePar