cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.case_dir)
        entryname: case
        writable: true

baseCommand: [snappyHexMesh]

inputs:
  case_dir:
    type: Directory
    inputBinding:
      prefix: -case
      position: 1

  is_parallel:
    type: boolean
    default: true
    inputBinding:
      prefix: -parallel
      position: 2

  overwrite:
    type: boolean
    default: false
    inputBinding:
      prefix: -overwrite
      position: 3
  
  decompseDic:
    type: string
    default: system/decomposeParDict
    inputBinding:
      prefix: -decomposeParDict
      position: 4


outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

stdout: log.snappyHexMesh
stderr: log.snappyHexMesh
