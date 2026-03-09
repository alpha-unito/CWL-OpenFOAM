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

  prepare_geometry:
    run: ../steps/prepare-geometry.cwl
    in:
      case_dir: copy_case/case_dir_out
    out: [case_dir_out]

  surface_features:
    run: ../steps/surfaceFeatures.cwl
    in:
      case_dir: prepare_geometry/case_dir_out
    out: [case_dir_out]

  blockmesh:
    run: ../steps/blockMesh.cwl
    in:
      case_dir: surface_features/case_dir_out
    out: [case_dir_out]

  decompose:
    run: ../steps/decompose.cwl
    in:
      case_dir: blockmesh/case_dir_out
    out: [case_dir_out]

  snappy:
    run: ../steps/snappy-parallel.cwl
    in:
      case_dir: decompose/case_dir_out
      is_parallel:
        default: true
      overwrite:
        default: true
      decompseDic:
        default: system/decomposeParDict
    out: [case_dir_out]

  toposet:
    run: ../steps/topoSet-parallel.cwl
    in:
      case_dir: snappy/case_dir_out
      is_parallel:
        default: true
      decompseDic:
        default: system/decomposeParDict
    out: [case_dir_out]

  restore0_processor:
    run: ../steps/restore0-processor.cwl
    in:
      case_dir: toposet/case_dir_out
    out: [case_dir_out]

  patchsummary:
    run: ../steps/patchSummary-parallel.cwl
    in:
      case_dir: restore0_processor/case_dir_out
      is_parallel:
        default: true
      decompseDic:
        default: system/decomposeParDict
    out: [case_dir_out]

  potential:
    run: ../steps/potentialFoam.cwl
    in:
      case_dir: patchsummary/case_dir_out
      is_parallel:
        default: true
      writePhi:
        default: true
      decompseDic:
        default: system/decomposeParDict
    out: [case_dir_out]

  simpleFoam:
    run: ../steps/simpleFoam.cwl
    in:
      case_dir: potential/case_dir_out
      is_parallel:
        default: true
      decompseDic:
        default: system/decomposeParDict
    out: [case_dir_out]


  reconstructParMesh:
    run: ../steps/reconstructParMesh.cwl
    in:
      case_dir: simpleFoam/case_dir_out
      is_constant:
        default: true
    out: [case_dir_out]


  reconstruct:
    run: ../steps/reconstruct.cwl
    in:
      case_dir: reconstructParMesh/case_dir_out
      is_latestTime:
        default: true
      is_constant:
        default: false
    out: [case_dir_out]

outputs:
  case_dir_out:
    type: Directory
    outputSource: reconstruct/case_dir_out
