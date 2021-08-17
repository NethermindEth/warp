from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash_state import (
    HashState, hash_finalize, hash_init, hash_update, hash_update_single)
from starkware.cairo.common.registers import get_fp_and_pc

const API_VERSION = 0

struct ContractEntryPoint:
    # A field element that encodes the signature of the called function.
    member selector : felt
    # The offset of the instruction that should be called within the contract bytecode.
    member offset : felt
end

struct ContractDefinition:
    member api_version : felt

    # The length and pointer to the external entry points table of the contract.
    member n_external_functions : felt
    member external_functions : ContractEntryPoint*

    # The length and pointer to the L1 handler entry points table of the contract.
    member n_l1_handlers : felt
    member l1_handlers : ContractEntryPoint*

    member n_builtins : felt
    # 'builtin_list' is a continuous memory segment containing the ASCII encoding of the (ordered)
    # builtins used by the program.
    member builtin_list : felt*

    # The hinted_contract_definition_hash field should be set to the starknet_keccak of the
    # contract program, including its hints. However the OS does not validate that.
    # This field may be used by the operator to differentiate between contract definitions that
    # differ only in the hints.
    # This field is included in the hash of the ContractDefinition to simplify the implementation.
    member hinted_contract_definition_hash : felt

    # The length and pointer of the bytecode.
    member bytecode_length : felt
    member bytecode_ptr : felt*
end

func contract_hash{hash_ptr : HashBuiltin*}(contract_definition : ContractDefinition*) -> (
        hash : felt):
    let (hash_state : HashState*) = hash_init()
    let (hash_state) = hash_update_single(
        hash_state_ptr=hash_state, item=contract_definition.api_version)

    # Hash external entry points.
    let (hash_state) = hash_update_single(
        hash_state_ptr=hash_state, item=contract_definition.n_external_functions)
    let (hash_state) = hash_update(
        hash_state_ptr=hash_state,
        data_ptr=contract_definition.external_functions,
        data_length=contract_definition.n_external_functions * ContractEntryPoint.SIZE)

    # Hash L1 handler entry points.
    let (hash_state) = hash_update_single(
        hash_state_ptr=hash_state, item=contract_definition.n_l1_handlers)
    let (hash_state) = hash_update(
        hash_state_ptr=hash_state,
        data_ptr=contract_definition.l1_handlers,
        data_length=contract_definition.n_l1_handlers * ContractEntryPoint.SIZE)

    # Hash builtins.
    let (hash_state) = hash_update_single(
        hash_state_ptr=hash_state, item=contract_definition.n_builtins)
    let (hash_state) = hash_update(
        hash_state_ptr=hash_state,
        data_ptr=contract_definition.builtin_list,
        data_length=contract_definition.n_builtins)

    # Hash hinted_contract_definition_hash.
    let (hash_state) = hash_update_single(
        hash_state_ptr=hash_state, item=contract_definition.hinted_contract_definition_hash)

    # Hash bytecode.
    let (hash_state) = hash_update_single(
        hash_state_ptr=hash_state, item=contract_definition.bytecode_length)
    let (hash_state) = hash_update(
        hash_state_ptr=hash_state,
        data_ptr=contract_definition.bytecode_ptr,
        data_length=contract_definition.bytecode_length)

    let (hash : felt) = hash_finalize(hash_state_ptr=hash_state)
    return (hash=hash)
end

# A list entry that maps a hash to the corresponding contract definition.
struct ContractDefinitionFact:
    # The hash of the contract. This member should be first, so that we can lookup items
    # with the hash as key, using find_element().
    member hash : felt
    member contract_definition : ContractDefinition*
end

# Loads the contract definitions from the 'os_input' hint variable.
# Returns ContractDefinitionFact list that maps a hash to a ContractDefinition.
func load_contract_definition_facts{pedersen_ptr : HashBuiltin*}() -> (
        n_contract_definition_facts, contract_definition_facts : ContractDefinitionFact*):
    alloc_locals
    local n_contract_definition_facts
    local contract_definition_facts : ContractDefinitionFact*
    %{
        ids.contract_definition_facts = segments.add()
        ids.n_contract_definition_facts = len(os_input.contract_definitions)
        vm_enter_scope({
            'contract_definitions_facts' : iter(os_input.contract_definitions.items()),
        })
    %}

    load_contract_definition_facts_inner(
        n_contract_definition_facts=n_contract_definition_facts,
        contract_definition_facts=contract_definition_facts)
    %{ vm_exit_scope() %}

    return (
        n_contract_definition_facts=n_contract_definition_facts,
        contract_definition_facts=contract_definition_facts)
end

# Loads 'n_contract_definition_facts' from the hint 'contract_definitions_facts' and appends the
# corresponding ContractDefinitionFact to contract_definition_facts.
func load_contract_definition_facts_inner{pedersen_ptr : HashBuiltin*}(
        n_contract_definition_facts, contract_definition_facts : ContractDefinitionFact*):
    if n_contract_definition_facts == 0:
        return ()
    end

    let contract_definition_fact = contract_definition_facts
    let contract_definition = contract_definition_fact.contract_definition

    # Fetch contract data form hints.
    %{
        from starkware.starknet.core.os.os_utils import get_contract_definition_struct

        contract_hash, contract_definition = next(contract_definitions_facts)

        cairo_contract = get_contract_definition_struct(
            identifiers=ids._context.identifiers, contract_definition=contract_definition)
        ids.contract_definition = segments.gen_arg(cairo_contract)
    %}

    assert contract_definition.api_version = API_VERSION

    let (hash) = contract_hash{hash_ptr=pedersen_ptr}(contract_definition)
    contract_definition_fact.hash = hash

    %{
        assert ids.contract_definition_fact.hash == int.from_bytes(contract_hash, 'big'), \
            'Computed contract_hash is inconsistent with the hash in the os_input'
        vm_load_program(contract_definition.program, ids.contract_definition.bytecode_ptr)
    %}

    return load_contract_definition_facts_inner(
        n_contract_definition_facts=n_contract_definition_facts - 1,
        contract_definition_facts=contract_definition_facts + ContractDefinitionFact.SIZE)
end
