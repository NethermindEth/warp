from . import base

from .. import multipart
from .. import utils


class Section(base.SectionBase):
	"""Interacting with raw IPFS blocks"""
	
	def get(self, cid: base.cid_t, **kwargs: base.CommonArgs):
		r"""Returns the raw contents of a block
		
		.. code-block:: python
		
			>>> client.block.get('QmTkzDwWqPbnAh5YiV5VwcTLnGdwSNsNTn2aDxdXBFca7D')
			b'\x121\n"\x12 \xdaW>\x14\xe5\xc1\xf6\xe4\x92\xd1 … \n\x02\x08\x01'
		
		Parameters
		----------
		cid
			The CID of an existing block to get
		
		Returns
		-------
			bytes
				Contents of the requested block
		"""
		args = (str(cid),)
		return self._client.request('/block/get', args, **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def put(self, file: utils.clean_file_t,
	        **kwargs: base.CommonArgs):
		"""Stores the contents of the given file object as an IPFS block
		
		.. code-block:: python
		
			>>> client.block.put(io.BytesIO(b'Mary had a little lamb'))
				{'Key':  'QmeV6C6XVt1wf7V7as7Yak3mxPma8jzpqyhtRtCvpKcfBb',
				 'Size': 22}
		
		Parameters
		----------
		file
			The data to be stored as an IPFS block
		
		Returns
		-------
			dict
				Information about the new block
				
				See :meth:`~ipfshttpclient.Client.block.stat`
		"""
		body, headers = multipart.stream_files(file, chunk_size=self.chunk_size)
		return self._client.request('/block/put', decoder='json', data=body,
		                            headers=headers, **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def stat(self, cid: base.cid_t, **kwargs: base.CommonArgs):
		"""Returns a dict with the size of the block with the given hash.
		
		.. code-block:: python
		
			>>> client.block.stat('QmTkzDwWqPbnAh5YiV5VwcTLnGdwSNsNTn2aDxdXBFca7D')
			{'Key':  'QmTkzDwWqPbnAh5YiV5VwcTLnGdwSNsNTn2aDxdXBFca7D',
			 'Size': 258}
		
		Parameters
		----------
		cid
			The CID of an existing block to stat
		
		Returns
		-------
			dict
				Information about the requested block
		"""
		args = (str(cid),)
		return self._client.request('/block/stat', args, decoder='json', **kwargs)