cwlVersion: v1.2
class: CommandLineTool

requirements:
 InlineJavascriptRequirement: {}
 InitialWorkDirRequirement:
   listing:
     - entry: $(inputs.case_dir)
       entryname: case
       writable: true

baseCommand: [mv]
arguments:
  - valueFrom: $(inputs.case_dir.basename)/$(inputs.new_location)
    position: 2 
    
    
inputs:
  case_dir:
    type: Directory
      
  input_file:
    type: File
    inputBinding:
      position: 1

  new_location:
    type: string

outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

