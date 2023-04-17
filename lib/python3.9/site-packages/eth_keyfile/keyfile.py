import hashlib
import json
import uuid

from Crypto import Random
from Crypto.Cipher import AES
from Crypto.Protocol.KDF import scrypt
from Crypto.Util import Counter

from eth_keys import keys

from eth_utils import (
    big_endian_to_int,
    decode_hex,
    encode_hex,
    int_to_big_endian,
    is_dict,
    is_string,
    keccak,
    remove_0x_prefix,
    to_dict,
)


def encode_hex_no_prefix(value):
    return remove_0x_prefix(encode_hex(value))


def load_keyfile(path_or_file_obj):
    if is_string(path_or_file_obj):
        with open(path_or_file_obj) as keyfile_file:
            return json.load(keyfile_file)
    else:
        return json.load(path_or_file_obj)


def create_keyfile_json(private_key, password, version=3, kdf="pbkdf2", iterations=None):
    if version == 3:
        return _create_v3_keyfile_json(private_key, password, kdf, iterations)
    else:
        raise NotImplementedError("Not yet implemented")


def decode_keyfile_json(raw_keyfile_json, password):
    keyfile_json = normalize_keys(raw_keyfile_json)
    version = keyfile_json['version']

    if version == 3:
        return _decode_keyfile_json_v3(keyfile_json, password)
    else:
        raise NotImplementedError("Not yet implemented")


def extract_key_from_keyfile(path_or_file_obj, password):
    keyfile_json = load_keyfile(path_or_file_obj)
    private_key = decode_keyfile_json(keyfile_json, password)
    return private_key


@to_dict
def normalize_keys(keyfile_json):
    for key, value in keyfile_json.items():
        if is_string(key):
            norm_key = key.lower()
        else:
            norm_key = key

        if is_dict(value):
            norm_value = normalize_keys(value)
        else:
            norm_value = value

        yield norm_key, norm_value


#
# Version 3 creators
#
DKLEN = 32
SCRYPT_R = 1
SCRYPT_P = 8


def _create_v3_keyfile_json(private_key, password, kdf, work_factor=None):
    salt = Random.get_random_bytes(16)

    if work_factor is None:
        work_factor = get_default_work_factor_for_kdf(kdf)

    if kdf == 'pbkdf2':
        derived_key = _pbkdf2_hash(
            password,
            hash_name='sha256',
            salt=salt,
            iterations=work_factor,
            dklen=DKLEN,
        )
        kdfparams = {
            'c': work_factor,
            'dklen': DKLEN,
            'prf': 'hmac-sha256',
            'salt': encode_hex_no_prefix(salt),
        }
    elif kdf == 'scrypt':
        derived_key = _scrypt_hash(
            password,
            salt=salt,
            buflen=DKLEN,
            r=SCRYPT_R,
            p=SCRYPT_P,
            n=work_factor,
        )
        kdfparams = {
            'dklen': DKLEN,
            'n': work_factor,
            'r': SCRYPT_R,
            'p': SCRYPT_P,
            'salt': encode_hex_no_prefix(salt),
        }
    else:
        raise NotImplementedError("KDF not implemented: {0}".format(kdf))

    iv = big_endian_to_int(Random.get_random_bytes(16))
    encrypt_key = derived_key[:16]
    ciphertext = encrypt_aes_ctr(private_key, encrypt_key, iv)
    mac = keccak(derived_key[16:32] + ciphertext)

    address = keys.PrivateKey(private_key).public_key.to_address()

    return {
        'address': remove_0x_prefix(address),
        'crypto': {
            'cipher': 'aes-128-ctr',
            'cipherparams': {
                'iv': encode_hex_no_prefix(int_to_big_endian(iv)),
            },
            'ciphertext': encode_hex_no_prefix(ciphertext),
            'kdf': kdf,
            'kdfparams': kdfparams,
            'mac': encode_hex_no_prefix(mac),
        },
        'id': str(uuid.uuid4()),
        'version': 3,
    }


#
# Verson 3 decoder
#
def _decode_keyfile_json_v3(keyfile_json, password):
    crypto = keyfile_json['crypto']
    kdf = crypto['kdf']

    # Derive the encryption key from the password using the key derivation
    # function.
    if kdf == 'pbkdf2':
        derived_key = _derive_pbkdf_key(crypto, password)
    elif kdf == 'scrypt':
        derived_key = _derive_scrypt_key(crypto, password)
    else:
        raise TypeError("Unsupported key derivation function: {0}".format(kdf))

    # Validate that the derived key matchs the provided MAC
    ciphertext = decode_hex(crypto['ciphertext'])
    mac = keccak(derived_key[16:32] + ciphertext)

    expected_mac = decode_hex(crypto['mac'])

    if mac != expected_mac:
        raise ValueError("MAC mismatch")

    # Decrypt the ciphertext using the derived encryption key to get the
    # private key.
    encrypt_key = derived_key[:16]
    cipherparams = crypto['cipherparams']
    iv = big_endian_to_int(decode_hex(cipherparams['iv']))

    private_key = decrypt_aes_ctr(ciphertext, encrypt_key, iv)

    return private_key


#
# Key derivation
#
def _derive_pbkdf_key(crypto, password):
    kdf_params = crypto['kdfparams']
    salt = decode_hex(kdf_params['salt'])
    dklen = kdf_params['dklen']
    should_be_hmac, _, hash_name = kdf_params['prf'].partition('-')
    assert should_be_hmac == 'hmac'
    iterations = kdf_params['c']

    derive_pbkdf_key = _pbkdf2_hash(password, hash_name, salt, iterations, dklen)

    return derive_pbkdf_key


def _derive_scrypt_key(crypto, password):
    kdf_params = crypto['kdfparams']
    salt = decode_hex(kdf_params['salt'])
    p = kdf_params['p']
    r = kdf_params['r']
    n = kdf_params['n']
    buflen = kdf_params['dklen']

    derived_scrypt_key = _scrypt_hash(
        password,
        salt=salt,
        n=n,
        r=r,
        p=p,
        buflen=buflen,
    )
    return derived_scrypt_key


def _scrypt_hash(password, salt, n, r, p, buflen):
    derived_key = scrypt(
        password,
        salt=salt,
        key_len=buflen,
        N=n,
        r=r,
        p=p,
        num_keys=1,
    )
    return derived_key


def _pbkdf2_hash(password, hash_name, salt, iterations, dklen):
    derived_key = hashlib.pbkdf2_hmac(
        hash_name=hash_name,
        password=password,
        salt=salt,
        iterations=iterations,
        dklen=dklen,
    )

    return derived_key


#
# Encryption and Decryption
#
def decrypt_aes_ctr(ciphertext, key, iv):
    ctr = Counter.new(128, initial_value=iv, allow_wraparound=True)
    encryptor = AES.new(key, AES.MODE_CTR, counter=ctr)
    return encryptor.decrypt(ciphertext)


def encrypt_aes_ctr(value, key, iv):
    ctr = Counter.new(128, initial_value=iv, allow_wraparound=True)
    encryptor = AES.new(key, AES.MODE_CTR, counter=ctr)
    ciphertext = encryptor.encrypt(value)
    return ciphertext


#
# Utility
#
def get_default_work_factor_for_kdf(kdf):
    if kdf == 'pbkdf2':
        return 1000000
    elif kdf == 'scrypt':
        return 262144
    else:
        raise ValueError("Unsupported key derivation function: {0}".format(kdf))
