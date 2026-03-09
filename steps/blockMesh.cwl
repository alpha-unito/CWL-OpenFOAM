cwlVersion: v1.2
class: CommandLineTool

requirements:
 InlineJavascriptRequirement: {}
 InitialWorkDirRequirement:
   listing:
     - entry: $(inputs.case_dir)
       entryname: case
       writable: true

baseCommand: [blockMesh]

inputs:
  size: string?
  case_dir:
    type: Directory
    inputBinding: 
      prefix: -case
      position: 1
      

outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

stdout: log.blockMesh
stderr: log.blockMesh
