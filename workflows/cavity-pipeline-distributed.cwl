cwlVersion: v1.2
class: Workflow

inputs:
  case_dir:
    type: Directory

steps:

  copy_case:
    run: ../steps/copy-case.cwl
    in:
      case_dir: case_dir
    out: [case_dir_out]

  blockMesh:
    run: ../steps/blockMesh.cwl
    in:
      case_dir: copy_case/case_dir_out
    out: [case_dir_out]

  decompose:
    run: ../steps/decompose.cwl
    in:
      case_dir: blockMesh/case_dir_out
    out: [case_dir_out]

  renumberMesh:
    run: ../steps/renumberMesh.cwl
    in:
      case_dir: decompose/case_dir_out
      is_parallel:
        default: true
      overwrite:
        default: true
    out: [case_dir_out]

  icoFoam:
    run: ../steps/icoFoam.cwl
    in:
      case_dir: renumberMesh/case_dir_out
      is_parallel: 
        default: true
    out: [case_dir_out]

outputs:
  case_dir_out:
    type: Directory
    outputSource: icoFoam/case_dir_out
