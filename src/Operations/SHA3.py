from Operation import Operation


class SHA3(Operation):
    def proceed(self, state):

        offset = state.stack.pop().get_low_bits()
        length = state.stack.pop().get_low_bits()

        output = state.request_fresh_name()
        state.stack.push_ref(output)

        return [
            f"""
                let (local msize) = update_msize(msize, {offset}, {length})
                let (local memval) = create_from_memory({offset}, {length})
                local high
                local low
                %{{
                    from Crypto.Hash import keccak

                    keccak_hash = keccak.new(digest_bits=256)
                    arr = []
                    arr_length = {length}//16 if {length} % 16 == 0 else {length}//16+1
                    for i in range(arr_length):
                        arr.append(memory[ids.memval+i])

                    keccak_input = bytearray()
                    for i in range(arr_length-1):
                        keccak_input += arr[i].to_bytes(16,"big")
                    keccak_input += arr[-1].to_bytes(16,"big") if {length}%16 == 0 else arr[-1].to_bytes({length}%16,"big")

                    keccak_hash.update(keccak_input)
                    hashed = keccak_hash.digest()
                    ids.high = int.from_bytes(hashed[:16],"big")
                    ids.low = int.from_bytes(hashed[16:32],"big")
                %}}
                local {output} : Uint256 = Uint256(low,high)
                """
        ]

    def required_imports(self):
        return {"evm.utils": {"update_msize"}, "evm.array": {"create_from_memory"}}
