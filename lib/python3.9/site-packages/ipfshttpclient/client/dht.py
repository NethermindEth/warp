from . import base

from .. import exceptions


class Section(base.SectionBase):
	@base.returns_single_item(base.ResponseBase)
	def findpeer(self, peer_id: str, *peer_ids: str, **kwargs: base.CommonArgs):
		"""Queries the DHT for all of the associated multiaddresses
		
		.. code-block:: python
		
			>>> client.dht.findpeer("QmaxqKpiYNr62uSFBhxJAMmEMkT6dvc3oHkrZN … MTLZ")
			[{'ID': 'QmfVGMFrwW6AV6fTWmD6eocaTybffqAvkVLXQEFrYdk6yc',
			  'Extra': '', 'Type': 6, 'Responses': None},
			 {'ID': 'QmTKiUdjbRjeN9yPhNhG1X38YNuBdjeiV9JXYWzCAJ4mj5',
			  'Extra': '', 'Type': 6, 'Responses': None},
			 {'ID': 'QmTGkgHSsULk8p3AKTAqKixxidZQXFyF7mCURcutPqrwjQ',
			  'Extra': '', 'Type': 6, 'Responses': None},
			 …
			 {'ID': '', 'Extra': '', 'Type': 2,
			  'Responses': [
				{'ID': 'QmaxqKpiYNr62uSFBhxJAMmEMkT6dvc3oHkrZNpH2VMTLZ',
				 'Addrs': [
					'/ip4/10.9.8.1/tcp/4001',
					'/ip6/::1/tcp/4001',
					'/ip4/164.132.197.107/tcp/4001',
					'/ip4/127.0.0.1/tcp/4001']}
			  ]}]
		
		Parameters
		----------
		peer_id
			The ID of the peer to search for
		
		Returns
		-------
			dict
				List of multiaddrs
		"""
		args = (peer_id,) + peer_ids
		return self._client.request('/dht/findpeer', args, decoder='json', **kwargs)
	
	
	@base.returns_multiple_items(base.ResponseBase)
	def findprovs(self, cid: base.cid_t, *cids: base.cid_t, **kwargs: base.CommonArgs):
		"""Finds peers in the DHT that can provide a specific value
		
		.. code-block:: python
		
			>>> client.dht.findprovs("QmNPXDC6wTXVmZ9Uoc8X1oqxRRJr4f1sDuyQu … mpW2")
			[{'ID': 'QmaxqKpiYNr62uSFBhxJAMmEMkT6dvc3oHkrZNpH2VMTLZ',
			  'Extra': '', 'Type': 6, 'Responses': None},
			 {'ID': 'QmaK6Aj5WXkfnWGoWq7V8pGUYzcHPZp4jKQ5JtmRvSzQGk',
			  'Extra': '', 'Type': 6, 'Responses': None},
			 {'ID': 'QmdUdLu8dNvr4MVW1iWXxKoQrbG6y1vAVWPdkeGK4xppds',
			  'Extra': '', 'Type': 6, 'Responses': None},
			 …
			 {'ID': '', 'Extra': '', 'Type': 4, 'Responses': [
				{'ID': 'QmVgNoP89mzpgEAAqK8owYoDEyB97Mk … E9Uc', 'Addrs': None}
			  ]},
			 {'ID': 'QmaxqKpiYNr62uSFBhxJAMmEMkT6dvc3oHkrZNpH2VMTLZ',
			  'Extra': '', 'Type': 1, 'Responses': [
				{'ID': 'QmSHXfsmN3ZduwFDjeqBn1C8b1tcLkxK6yd … waXw', 'Addrs': [
					'/ip4/127.0.0.1/tcp/4001',
					'/ip4/172.17.0.8/tcp/4001',
					'/ip6/::1/tcp/4001',
					'/ip4/52.32.109.74/tcp/1028'
				  ]}
			  ]}]
		
		Parameters
		----------
		cid
			The DHT key to find providers for
		
		Returns
		-------
			dict
				List of provider Peer IDs
		"""
		args = (str(cid),) + tuple(str(c) for c in cids)
		return self._client.request('/dht/findprovs', args, decoder='json', **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def get(self, key: str, *keys: str, **kwargs: base.CommonArgs):
		"""Queries the DHT for its best value related to given key
		
		There may be several different values for a given key stored in the
		DHT; in this context *best* means the record that is most desirable.
		There is no one metric for *best*: it depends entirely on the key type.
		For IPNS, *best* is the record that is both valid and has the highest
		sequence number (freshest). Different key types may specify other rules
		for what they consider to be the *best*.
		
		Parameters
		----------
		key
			One or more keys whose values should be looked up
		
		Returns
		-------
			str
		"""
		args = (key,) + keys
		res = self._client.request('/dht/get', args, decoder='json', **kwargs)
		
		if isinstance(res, dict) and "Extra" in res:
			return res["Extra"]
		else:
			for r in res:
				if "Extra" in r and len(r["Extra"]) > 0:
					return r["Extra"]
		raise exceptions.Error("empty response from DHT")
	
	
	#TODO: Implement `provide(cid)`
	
	
	@base.returns_multiple_items(base.ResponseBase)
	def put(self, key: str, value: str, **kwargs: base.CommonArgs):
		"""Writes a key/value pair to the DHT
		
		Given a key of the form ``/foo/bar`` and a value of any form, this will
		write that value to the DHT with that key.
		
		Keys have two parts: a keytype (foo) and the key name (bar). IPNS uses
		the ``/ipns/`` keytype, and expects the key name to be a Peer ID. IPNS
		entries are formatted with a special strucutre.
		
		You may only use keytypes that are supported in your ``ipfs`` binary:
		``go-ipfs`` currently only supports the ``/ipns/`` keytype. Unless you
		have a relatively deep understanding of the key's internal structure,
		you likely want to be using the :meth:`~ipfshttpclient.Client.name_publish`
		instead.
		
		Value is arbitrary text.
		
		.. code-block:: python
		
			>>> client.dht.put("QmVgNoP89mzpgEAAqK8owYoDEyB97Mkc … E9Uc", "test123")
			[{'ID': 'QmfLy2aqbhU1RqZnGQyqHSovV8tDufLUaPfN1LNtg5CvDZ',
			  'Extra': '', 'Type': 5, 'Responses': None},
			 {'ID': 'QmZ5qTkNvvZ5eFq9T4dcCEK7kX8L7iysYEpvQmij9vokGE',
			  'Extra': '', 'Type': 5, 'Responses': None},
			 {'ID': 'QmYqa6QHCbe6eKiiW6YoThU5yBy8c3eQzpiuW22SgVWSB8',
			  'Extra': '', 'Type': 6, 'Responses': None},
			 …
			 {'ID': 'QmP6TAKVDCziLmx9NV8QGekwtf7ZMuJnmbeHMjcfoZbRMd',
			  'Extra': '', 'Type': 1, 'Responses': []}]
		
		Parameters
		----------
		key
			A unique identifier
		value
			Abitrary text to associate with the input (2048 bytes or less)
		
		Returns
		-------
			list
		"""
		args = (key, value)
		return self._client.request('/dht/put', args, decoder='json', **kwargs)
	
	
	@base.returns_multiple_items(base.ResponseBase)
	def query(self, peer_id: str, *peer_ids: str, **kwargs: base.CommonArgs):
		"""Finds the closest Peer IDs to a given Peer ID by querying the DHT.
		
		.. code-block:: python
		
			>>> client.dht.query("/ip4/104.131.131.82/tcp/4001/ipfs/QmaCpDM … uvuJ")
			[{'ID': 'QmPkFbxAQ7DeKD5VGSh9HQrdS574pyNzDmxJeGrRJxoucF',
			  'Extra': '', 'Type': 2, 'Responses': None},
			 {'ID': 'QmR1MhHVLJSLt9ZthsNNhudb1ny1WdhY4FPW21ZYFWec4f',
			  'Extra': '', 'Type': 2, 'Responses': None},
			 {'ID': 'Qmcwx1K5aVme45ab6NYWb52K2TFBeABgCLccC7ntUeDsAs',
			  'Extra': '', 'Type': 2, 'Responses': None},
			 …
			 {'ID': 'QmYYy8L3YD1nsF4xtt4xmsc14yqvAAnKksjo3F3iZs5jPv',
			  'Extra': '', 'Type': 1, 'Responses': []}]
		
		Parameters
		----------
		peer_id
			The peerID to run the query against
		
		Returns
		-------
			dict
				List of peers IDs
		"""
		args = (peer_id,) + peer_ids
		return self._client.request('/dht/query', args, decoder='json', **kwargs)