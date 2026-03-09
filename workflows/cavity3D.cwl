cwlVersion: v1.2
class: Workflow

inputs:
  case_dirs:
    type: 
      type: array
      items:
        type: record
        fields:
        - name: case_dir
          type: Directory 
          # loadListing: no_listing 
        - name: size
          type: string
        - name: fvSolutions
          type: File[]

steps:
  cavity3d:
    in:
      case_dir: case_dirs
    scatter: case_dir
    out: [case_dir_out]
    run:
      class: Workflow
      inputs:
        case_dir:
          type:
            type: record
            fields:
            - name: case_dir
              type: Directory 
            - name: size
              type: string
            - name: fvSolutions
              type: File[]
      outputs:
        case_dir_out:
          type: Directory[]
          outputSource: multiConv/case_dir_out
      steps:
        copy_case:
          run: ../steps/copy-case.cwl
          in:
            record: case_dir
            case_dir: 
              valueFrom: "$(inputs.record.case_dir)"
          out: [case_dir_out]

        pop_size:
          run:
            class: ExpressionTool 
            inputs:
              record: 
                type:
                  type: record
                  fields:
                    case_dir: Directory 
                    size: string
                    fvSolutions: File[]
            outputs:
              size:
                type: string
            expression: >
              ${ return { "size": inputs.record.size } ; }
          in:
            record: case_dir
          out: [size]

        blockMesh:
          run: ../steps/blockMesh.cwl
          in:
            size: pop_size/size
            case_dir: copy_case/case_dir_out
          out: [case_dir_out]

        decompose:
          run: ../steps/decompose.cwl
          in:
            size: pop_size/size
            case_dir: blockMesh/case_dir_out
          out: [case_dir_out]

        renumberMesh:
          run: ../steps/renumberMesh.cwl
          in:
            size: pop_size/size
            case_dir: decompose/case_dir_out
            is_parallel:
              default: true
            overwrite:
              default: true
          out: [case_dir_out]
        pop_solutions:
          run:
            class: ExpressionTool 
            inputs:
              record: 
                type:
                  type: record
                  fields:
                    case_dir: Directory 
                    size: string
                    fvSolutions: File[]
            outputs:
              solutions:
                type: File[]
            expression: >
              ${ return { "solutions": inputs.record.fvSolutions }; }
          in:
            record: case_dir
          out: [solutions]
        multiConv:
          in: 
            size: pop_size/size
            case_dir: renumberMesh/case_dir_out
            fvSolution: pop_solutions/solutions
          out: [case_dir_out]
          scatter: fvSolution
          run:
            class: Workflow
            inputs:
              size: 
                type: string
              case_dir:
                type: Directory
              fvSolution:
                type: File
            outputs:
              case_dir_out:
                type: Directory
                outputSource: icoFoam/case_dir_out
            steps:
              copy_mesh:
                run: ../steps/copy-case.cwl
                in:
                  case_dir: case_dir
                out: [case_dir_out]
              inject_file:
                run: ../steps/inject_file.cwl
                in:
                  case_dir: copy_mesh/case_dir_out
                  input_file: fvSolution
                  new_location:
                    default: "system/fvSolution"
                out: [case_dir_out]
              icoFoam:
                run: ../steps/icoFoam.cwl
                in:
                  size: size
                  case_dir: inject_file/case_dir_out
                  is_parallel: 
                    default: true
                out: [case_dir_out]

      requirements:
        InlineJavascriptRequirement: {}
        SubworkflowFeatureRequirement: {}
        ScatterFeatureRequirement: {}
        StepInputExpressionRequirement: {}


outputs:
  case_dir_out:
    type: 
      type: array
      items:
        type: array
        items: Directory
    outputSource: cavity3d/case_dir_out


requirements:
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}