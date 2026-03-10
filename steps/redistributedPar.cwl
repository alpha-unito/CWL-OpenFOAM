cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.case_dir)
        entryname: case
        writable: true

baseCommand: [redistributePar]


# runParallel -decomposeParDict system/decomposeParDictSolver redistributePar -constant -overwrite

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

  is_constant:
    type: boolean
    default: false
    inputBinding:
      prefix: -overwrite
      position: 4

  decomposeDict:
    type: string
    default: system/decomposeParDict
    inputBinding:
      prefix: -decomposeParDict
      position: 5



outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

stdout: log.redistributePar
stderr: log.redistributePar