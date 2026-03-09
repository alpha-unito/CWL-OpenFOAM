cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.case_dir)
        entryname: case
        writable: true

baseCommand: [changeDictionary]


# runParallel -decomposeParDict system/decomposeParDictSolver changeDictionary -constant -enableFunctionEntries

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

  is_constant:
    type: boolean
    default: false
    inputBinding:
      prefix: -constant
      position: 3

  enableFunctionEntries:
    type: boolean
    default: true
    inputBinding:
      prefix: -enableFunctionEntries
      position: 4

  decompseDic:
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

stdout: log.changeDictionary
stderr: log.changeDictionary