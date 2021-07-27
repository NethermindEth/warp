from Operations.Binary import Binary


class SHA3(Binary):
    def generate_cairo_code(self, offset, length, output):
        offset = offset.get_low_bits()
        length = length.get_low_bits()

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
