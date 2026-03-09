cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.case_dir)
        entryname: case
        writable: true


baseCommand: [simpleFoam]

inputs:
  size: string?
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

  decompseDic:
    type: string
    default: system/decomposeParDict
    inputBinding:
      prefix: -decomposeParDict
      position: 3



outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

stdout: log.simpleFoam
stderr: log.simpleFoam