from . import base

from .. import multipart
from .. import utils


class Section(base.SectionBase):
	@base.returns_single_item(base.ResponseBase)
	def get(self, cid: base.cid_t, **kwargs: base.CommonArgs):
		"""Retrieves the contents of a DAG node

		.. code-block:: python

			>>> client.dag.get('QmTkzDwWqPbnAh5YiV5VwcTLnGdwSNsNTn2aDxdXBFca7D')
			{'Data': '\x08\x01',
			 'Links': [
				{'Hash': 'Qmd2xkBfEwEs9oMTk77A6jrsgurpF3ugXSg7dtPNFkcNMV',
				 'Name': 'Makefile',          'Size': 174},
				{'Hash': 'QmeKozNssnkJ4NcyRidYgDY2jfRZqVEoRGfipkgath71bX',
				 'Name': 'example',           'Size': 1474},
				{'Hash': 'QmZAL3oHMQYqsV61tGvoAVtQLs1WzRe1zkkamv9qxqnDuK',
				 'Name': 'home',              'Size': 3947},
				{'Hash': 'QmZNPyKVriMsZwJSNXeQtVQSNU4v4KEKGUQaMT61LPahso',
				 'Name': 'lib',               'Size': 268261},
				{'Hash': 'QmSY8RfVntt3VdxWppv9w5hWgNrE31uctgTiYwKir8eXJY',
				 'Name': 'published-version', 'Size': 55}
			]}

		Parameters
		----------
		cid
			Key of the object to retrieve, in CID format

		Returns
		-------
			dict
				Cid with the address of the dag object
		"""
		args = (str(cid),)
		return self._client.request('/dag/get', args, decoder='json', **kwargs)

	@base.returns_single_item(base.ResponseBase)
	def put(self, data: utils.clean_file_t, format: str = 'cbor',
	        input_enc: str = 'json', **kwargs: base.CommonArgs):
		"""Decodes the given input file as a DAG object and returns their key

		.. code-block:: python

			>>> client.dag.put(io.BytesIO(b'''
			...       {
			...           "Data": "another",
			...           "Links": [ {
			...               "Name": "some link",
			...               "Hash": "QmXg9Pp2ytZ14xgmQjYEiHjVjMFXzCV … R39V",
			...               "Size": 8
			...           } ]
			...       }'''))
			{'Cid': {
					'/': 'bafyreifgjgbmtykld2e3yncey3naek5xad3h4m2pxmo3of376qxh54qk34'
				}
			}

		Parameters
		----------
		data
			IO stream object of path to a file containing the data to put
		format
			Format that the object will be added as. Default: cbor
		input_enc
			Format that the input object will be. Default: json

		Returns
		-------
			dict
				Cid with the address of the dag object
		"""
		opts = {'format': format, 'input-enc': input_enc}
		kwargs.setdefault('opts', {}).update(opts)
		body, headers = multipart.stream_files(data, chunk_size=self.chunk_size)
		return self._client.request('/dag/put', decoder='json', data=body,
		                            headers=headers, **kwargs)

	@base.returns_single_item(base.ResponseBase)
	def resolve(self, cid: base.cid_t, **kwargs: base.CommonArgs):
		"""Resolves a DAG node from its CID, returning its address and remaining path

		.. code-block:: python

			>>> client.dag.resolve('QmTkzDwWqPbnAh5YiV5VwcTLnGdwSNsNTn2aDxdXBFca7D')
			{'Cid': {
					'/': 'QmTkzDwWqPbnAh5YiV5VwcTLnGdwSNsNTn2aDxdXBFca7D'
				}
			}

		Parameters
		----------
		cid
			Key of the object to resolve, in CID format

		Returns
		-------
			dict
				Cid with the address of the dag object
		"""
		args = (str(cid),)
		return self._client.request('/dag/resolve', args, decoder='json', **kwargs)

	@base.returns_single_item(base.ResponseBase)
	def imprt(self, data: utils.clean_file_t, **kwargs: base.CommonArgs):
		"""Imports a .car file with a DAG into IPFS

		.. code-block:: python

			>>> with open('data.car', 'rb') as file
			...     client.dag.imprt(file)
			{'Root': {
					'Cid': {
						'/': 'bafyreidepjmjhvhlvp5eyxqpmyyi7rxwvl7wsglwai3cnvq63komq4tdya'
					}
				}
			}

		*Note*: This method is named ``.imprt`` (rather than ``.import``) to avoid causing a Python
		:exc:`SyntaxError` due to ``import`` being global keyword in Python.

		Parameters
		----------
		data
			IO stream object with data that should be imported

		Returns
		-------
			dict
				Dictionary with the root CID of the DAG imported
		"""
		body, headers = multipart.stream_files(data, chunk_size=self.chunk_size)
		return self._client.request('/dag/import', decoder='json', data=body,
		                            headers=headers, **kwargs)

	def export(self, cid: str, **kwargs: base.CommonArgs):
		"""Exports a DAG into a .car file format

		.. code-block:: python

			>>> data = client.dag.export('bafyreidepjmjhvhlvp5eyxqpmyyi7rxwvl7wsglwai3cnvq63komq4tdya')

		*Note*: When exporting larger DAG structures, remember that you can set the *stream*
		parameter to ``True`` on any method to have it return results incrementally.

		Parameters
		----------
		cid
			Key of the object to export, in CID format

		Returns
		-------
			bytes
				DAG in a .car format
		"""
		args = (str(cid),)
		return self._client.request('/dag/export', args, **kwargs)
