/* 
  Stores all prefix/infix/suffix of solidity variables generated/modified by
  the transpiler.
  Every new generation should be added accordingly. 
*/

// Used in TupleFiller in TupleFixes
export const TUPLE_FILLER_PREFIX = '__warp_tf';

// Used in SourceUnitSplitter
export const FREE_FILE_NAME = '__warp_free.cairo';

// Used in IdentifierManglerPass and CairoStubProcessor
export const MANGLED_WARP = '__warp_';

// Used in StaticArrayIndexer
export const CALLDATA_TO_MEMORY_PREFIX = 'cd_to_wm_';

// Used in StorageAllocator
export const CONSTANT_STRING_TO_MEMORY_PREFIX = 'memory_string';

// Used in ModifierHandler in FunctionModifierHandler
export const MANGLED_PARAMETER = '__warp_parameter_';
export const MANGLED_RETURN_PARAMETER = '__warp_ret_parameter_';
export const MODIFIER_PREFIX = '__warp_modifier_';
export const ORIGINAL_FUNCTION_PREFIX = '__warp_original_';

// Used in ExternalArgModifier in MemoryRefInputModifier
export const CALLDATA_TO_MEMORY_FUNCTION_PARAMETER_PREFIX = 'cd_to_wm_param_';

// Used in IfFunctionaliser
export const IF_FUNCTIONALISER_INFIX = '_if_part';

// Used in PublicFunctionSplitter in ExternalFunctionCreator
export const INTERNAL_FUNCTION_SUFFIX = '_internal';

// Used in LoopFunctionaliser
//  - Used in ReturnToBreak
export const RETURN_FLAG_PREFIX = '__warp_rf';
export const RETURN_VALUE_PREFIX = '__warp_rv';
//  - Used in utils
export const WHILE_PREFIX = '__warp_while';

// Used in  VariableDeclarationExpressionSplitter
export const SPLIT_VARIABLE_PREFIX = '__warp_td_';

// Used in Expression Splitter
export const SPLIT_EXPRESSION_PREFIX = '__warp_se_';

// Used in Conditional Splitter
export const PRE_SPLIT_EXPRESSION_PREFIX = '__warp_pse_';
export const CONDITIONAL_FUNCTION_PREFIX = '__warp_conditional_';
export const CONDITIONAL_RETURN_VARIABLE = '__warp_rc_';
export const TUPLE_VALUE_PREFIX = '__warp_tv_';

// Used in UnloadingAssignment
export const COMPOUND_ASSIGNMENT_SUBEXPRESSION_PREFIX = '__warp_cs_';

// Used in StorageAllocator and InheritanceInliner in ConstructorInheritance
export const INIT_FUNCTION_PREFIX = '__warp_init_';

// Used in ExternalContractHandler
// Used in SourceUnitWriter (to distinguish generated interfaces from user defined ones)
export const TEMP_INTERFACE_SUFFIX = '@interface';

// Used in cairoUtilGenFunc/event.ts
export const EMIT_PREFIX = '__warp_emit_';
