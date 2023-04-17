Ethereum Keyfile
================

A library for handling the encrypted keyfiles used to store ethereum
private keys

    This library and repository was previously located at
    https://github.com/pipermerriam/ethereum-keyfile. It was transferred
    to the Ethereum foundation github in November 2017 and renamed to
    ``eth-keyfile``. The PyPi package was also renamed from
    ``ethereum-keyfile`` to \`eth-keyfile.

Installation
------------

.. code:: sh

    pip install eth-keyfile

Development
-----------

.. code:: sh

    pip install -e . -r requirements-dev.txt

Running the tests
~~~~~~~~~~~~~~~~~

You can run the tests with:

.. code:: sh

    py.test tests

Or you can install ``tox`` to run the full test suite.

Releasing
~~~~~~~~~

Pandoc is required for transforming the markdown README to the proper
format to render correctly on pypi.

For Debian-like systems:

::

    apt install pandoc

Or on OSX:

.. code:: sh

    brew install pandoc

To release a new version:

.. code:: sh

    make release bump=$$VERSION_PART_TO_BUMP$$

How to bumpversion
^^^^^^^^^^^^^^^^^^

The version format for this repo is ``{major}.{minor}.{patch}`` for
stable, and ``{major}.{minor}.{patch}-{stage}.{devnum}`` for unstable
(``stage`` can be alpha or beta).

To issue the next version in line, specify which part to bump, like
``make release bump=minor`` or ``make release bump=devnum``.

If you are in a beta version, ``make release bump=stage`` will switch to
a stable.

To issue an unstable version when the current version is stable, specify
the new version explicitly, like
``make release bump="--new-version 2.0.0-alpha.1 devnum"``

Documentation
-------------

``eth_keyfile.load_keyfile(path_or_file_obj) --> keyfile_json``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Takes either a filesystem path represented as a string or a file object
and returns the parsed keyfile json as a python dictionary.

.. code:: python

    >>> from eth_keyfile import load_keyfile
    >>> load_keyfile('path/to-my-keystore/keystore.json')
    {
        "crypto" : {
            "cipher" : "aes-128-ctr",
            "cipherparams" : {
                "iv" : "6087dab2f9fdbbfaddc31a909735c1e6"
            },
            "ciphertext" : "5318b4d5bcd28de64ee5559e671353e16f075ecae9f99c7a79a38af5f869aa46",
            "kdf" : "pbkdf2",
            "kdfparams" : {
                "c" : 262144,
                "dklen" : 32,
                "prf" : "hmac-sha256",
                "salt" : "ae3cd4e7013836a3df6bd7241b12db061dbe2c6785853cce422d148a624ce0bd"
            },
            "mac" : "517ead924a9d0dc3124507e3393d175ce3ff7c1e96529c6c555ce9e51205e9b2"
        },
        "id" : "3198bc9c-6672-5ab3-d995-4942343ae5b6",
        "version" : 3
    }

``eth_keyfile.create_keyfile_json(private_key, password, kdf="pbkdf2", work_factor=None) --> keyfile_json``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Takes the following parameters:

-  ``private_key``: A bytestring of length 32
-  ``password``: A bytestring which will be the password that can be
   used to decrypt the resulting keyfile.
-  ``kdf``: The key derivation function. Allowed values are ``pbkdf2``
   and ``scrypt``. By default, ``pbkdf2`` will be used.
-  ``work_factor``: The work factor which will be used for the given key
   derivation function. By default ``1000000`` will be used for
   ``pbkdf2`` and ``262144`` for ``scrypt``.

Returns the keyfile json as a python dictionary.

.. code:: python

    >>> private_key = b'\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01'
    >>> create_keyfile_json(private_key, b'foo')
    {
        "address" : "1a642f0e3c3af545e7acbd38b07251b3990914f1",
        "crypto" : {
            "cipher" : "aes-128-ctr",
            "cipherparams" : {
                "iv" : "6087dab2f9fdbbfaddc31a909735c1e6"
            },
            "ciphertext" : "5318b4d5bcd28de64ee5559e671353e16f075ecae9f99c7a79a38af5f869aa46",
            "kdf" : "pbkdf2",
            "kdfparams" : {
                "c" : 262144,
                "dklen" : 32,
                "prf" : "hmac-sha256",
                "salt" : "ae3cd4e7013836a3df6bd7241b12db061dbe2c6785853cce422d148a624ce0bd"
            },
            "mac" : "517ead924a9d0dc3124507e3393d175ce3ff7c1e96529c6c555ce9e51205e9b2"
        },
        "id" : "3198bc9c-6672-5ab3-d995-4942343ae5b6",
        "version" : 3
    }

``eth_keyfile.decode_keyfile_json(keyfile_json, password) --> private_key``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Takes the keyfile json as a python dictionary and the password for the
keyfile, returning the decoded private key.

.. code:: python

    >>> keyfile_json = {
    ...     "crypto" : {
    ...         "cipher" : "aes-128-ctr",
    ...         "cipherparams" : {
    ...             "iv" : "6087dab2f9fdbbfaddc31a909735c1e6"
    ...         },
    ...         "ciphertext" : "5318b4d5bcd28de64ee5559e671353e16f075ecae9f99c7a79a38af5f869aa46",
    ...         "kdf" : "pbkdf2",
    ...         "kdfparams" : {
    ...             "c" : 262144,
    ...             "dklen" : 32,
    ...             "prf" : "hmac-sha256",
    ...             "salt" : "ae3cd4e7013836a3df6bd7241b12db061dbe2c6785853cce422d148a624ce0bd"
    ...         },
    ...         "mac" : "517ead924a9d0dc3124507e3393d175ce3ff7c1e96529c6c555ce9e51205e9b2"
    ...     },
    ...     "id" : "3198bc9c-6672-5ab3-d995-4942343ae5b6",
    ...     "version" : 3
    ... }
    >>> decode_keyfile_json(keyfile_json, b'foo')
    b'\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01'

``eth_keyfile.extract_key_from_keyfile(path_or_file_obj, password) --> private_key``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Takes a filesystem path represented by a string or a file object and the
password for the keyfile. Returns the private key as a bytestring.

.. code:: python

    >>> extract_key_from_keyfile('path/to-my-keystore/keyfile.json', b'foo')
    b'\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01'


