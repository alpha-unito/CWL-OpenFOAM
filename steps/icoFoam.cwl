cwlVersion: v1.2
class: CommandLineTool

requirements:
 InlineJavascriptRequirement: {}
 InitialWorkDirRequirement:
   listing:
     - entry: $(inputs.case_dir)
       entryname: case
       writable: true

baseCommand: [icoFoam]

inputs:
  size: string?
  case_dir:
    type: Directory
    inputBinding:
      prefix: -case 
      position: 1
      
  is_parallel:
    type: boolean
    default: false
    inputBinding:
      prefix: -parallel
      position: 2


outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

stdout: log.icoFoam
stderr: log.icoFoam
