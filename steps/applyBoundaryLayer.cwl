cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.case_dir)
        entryname: case
        writable: true


# runParallel -decomposeParDict system/decomposeParDictSolver applyBoundaryLayer  -ybl 0.1

baseCommand: [applyBoundaryLayer]

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

  decompseDic:
    type: string
    default: system/decomposeParDict
    inputBinding:
      prefix: -decomposeParDict
      position: 4

  ybl:
    type: float
    default: 0.1
    inputBinding:
      prefix: -ybl
      position: 3


outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

stdout: log.applyBoundaryLayer
stderr: log.applyBoundaryLayer
