from starkware.cairo.common.cairo_builtins import HashBuiltin

# Performs an update for a single leaf (index) in a Merkle tree (where 0 <= index < 2^height).
# Updates the leaf from prev_leaf to new_leaf, and returns the previous and new roots of the
# Merkle tree resulting from the change.
# In particular, given a secret authentication path (of the siblings of the nodes in the path from
# the root to the leaf), this function computes the roots twice - once with prev_leaf and once with
# new_leaf, where the verifier is guaranteed that the same authentication path is used.
func merkle_update{hash_ptr : HashBuiltin*}(height, prev_leaf, new_leaf, index) -> (
        prev_root, new_root):
    if height == 0:
        # Assert that index is 0.
        index = 0
        # Return the two leaves and the Pedersen pointer.
        %{
            # Check that auth_path had the right number of elements.
            assert len(auth_path) == 0, 'Got too many values in auth_path.'
        %}
        return (prev_root=prev_leaf, new_root=new_leaf)
    end

    let prev_node_hash = hash_ptr
    let new_node_hash = hash_ptr + HashBuiltin.SIZE
    let hash_ptr = hash_ptr + 2 * HashBuiltin.SIZE

    %{ memory[ap] = ids.index % 2 %}
    jmp update_right if [ap] != 0; ap++

    update_left:
    %{
        # Hash hints.
        sibling = auth_path.pop()
        ids.prev_node_hash.y = sibling
        ids.new_node_hash.y = sibling
    %}
    prev_leaf = prev_node_hash.x
    new_leaf = new_node_hash.x

    # Make sure the same authentication path is used.
    let right_sibling = ap
    [right_sibling] = prev_node_hash.y
    [right_sibling] = new_node_hash.y; ap++

    # Call merkle_update recursively.
    return merkle_update(
        height=height - 1,
        prev_leaf=prev_node_hash.result,
        new_leaf=new_node_hash.result,
        index=index / 2)

    update_right:
    %{
        # Hash hints.
        sibling = auth_path.pop()
        ids.prev_node_hash.x = sibling
        ids.new_node_hash.x = sibling
    %}
    prev_leaf = prev_node_hash.y
    new_leaf = new_node_hash.y

    # Make sure the same authentication path is used.
    let left_sibling = ap
    [left_sibling] = prev_node_hash.x
    [left_sibling] = new_node_hash.x; ap++

    return merkle_update(
        height=height - 1,
        prev_leaf=prev_node_hash.result,
        new_leaf=new_node_hash.result,
        index=(index - 1) / 2)
end
