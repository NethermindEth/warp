from . import base


class Section(base.SectionBase):
	@base.returns_single_item(base.ResponseBase)
	def add(self, path: base.cid_t, *paths: base.cid_t, recursive: bool = True,
	        **kwargs: base.CommonArgs):
		"""Pins objects to the node's local repository
		
		Stores an IPFS object(s) from a given path in the local repository.
		
		.. code-block:: python
		
			>>> client.pin.add("QmfZY61ukoQuCX8e5Pt7v8pRfhkyxwZKZMTodAtmvyGZ5d")
			{'Pins': ['QmfZY61ukoQuCX8e5Pt7v8pRfhkyxwZKZMTodAtmvyGZ5d']}
		
		Parameters
		----------
		path
			Path to object(s) to be pinned
		recursive
			Recursively unpin the object linked to by the specified object(s)
		
		Returns
		-------
			dict
		
		+------+-----------------------------------------------------------+
		| Pins | List of IPFS objects that have been pinned by this action |
		+------+-----------------------------------------------------------+
		"""
		kwargs.setdefault("opts", {})["recursive"] = recursive
		
		args = (str(path), *(str(p) for p in paths))
		return self._client.request('/pin/add', args, decoder='json', **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def ls(self, *paths: base.cid_t, type: str = "all", **kwargs: base.CommonArgs):
		"""Lists objects pinned in the local repository
		
		By default, all pinned objects are returned, but the ``type`` flag or
		arguments can restrict that to a specific pin type or to some specific
		objects respectively. In particular the ``type="recursive"`` argument will
		only list objects added ``.pin.add(…)`` (or similar) and will greatly
		speed processing as obtaining this list does *not* require a complete
		repository metadata scan.
		
		.. code-block:: python
		
			>>> client.pin.ls()
			{'Keys': {
				'QmNNPMA1eGUbKxeph6yqV8ZmRkdVat … YMuz': {'Type': 'recursive'},
				'QmNPZUCeSN5458Uwny8mXSWubjjr6J … kP5e': {'Type': 'recursive'},
				'QmNg5zWpRMxzRAVg7FTQ3tUxVbKj8E … gHPz': {'Type': 'indirect'},
				…
				'QmNiuVapnYCrLjxyweHeuk6Xdqfvts … wCCe': {'Type': 'indirect'}
			}}
			
			>>> # While the above works you should always try to use `type="recursive"`
			>>> # instead as it will greatly speed up processing and only lists
			>>> # explicit pins (added with `.pin.add(…)` or similar), rather than
			>>> # than all objects that won't be removed as part of `.repo.gc()`:
			>>> client.pin.ls(type="recursive")
			{'Keys': {
				'QmNNPMA1eGUbKxeph6yqV8ZmRkdVat … YMuz': {'Type': 'recursive'},
				'QmNPZUCeSN5458Uwny8mXSWubjjr6J … kP5e': {'Type': 'recursive'},
				…
			}}
			
			>>> client.pin.ls('/ipfs/QmNNPMA1eGUbKxeph6yqV8ZmRkdVat … YMuz')
			{'Keys': {
				'QmNNPMA1eGUbKxeph6yqV8ZmRkdVat … YMuz': {'Type': 'recursive'}}}
			
			>>> client.pin.ls('/ipfs/QmdBCSn4UJP82MjhRVwpABww48tXL3 … mA6z')
			ipfshttpclient.exceptions.ErrorResponse:
				path '/ipfs/QmdBCSn4UJP82MjhRVwpABww48tXL3 … mA6z' is not pinned
		
		Parameters
		----------
		paths
			The IPFS paths or CIDs to search for
			
			If none are passed, return information about all pinned objects.
			If any of the passed CIDs is not pinned, then remote will
			return an error and an :exc:`ErrorResponse` exception will be raised.
		type
			The type of pinned keys to list. Can be:
			
			 * ``"direct"``
			 * ``"indirect"``
			 * ``"recursive"``
			 * ``"all"``
		
		Raises
		------
		~ipfsapi.exceptions.ErrorResponse
			Remote returned an error. Remote will return an error
			if any of the passed CIDs is not pinned. In this case,
			the exception will contain 'not pinned' in its args[0].
		
		Returns
		-------
			dict
		
		+------+--------------------------------------------------------------+
		| Keys | Mapping of IPFS object names currently pinned to their types |
		+------+--------------------------------------------------------------+
		"""
		kwargs.setdefault("opts", {})["type"] = type
		
		args = tuple(str(p) for p in paths)
		return self._client.request('/pin/ls', args, decoder='json', **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def rm(self, path: base.cid_t, *paths: base.cid_t, recursive: bool = True,
	       **kwargs: base.CommonArgs):
		"""Removes a pinned object from local storage
		
		Removes the pin from the given object allowing it to be garbage
		collected if needed. That is, depending on the node configuration
		it may not be garbage anytime soon or at all unless you manually
		clean up the local repository using :meth:`~ipfshttpclient.repo.gc`.
		
		Also note that an object is pinned both directly (that is its type
		is ``"recursive"``) and indirectly (meaning that it is referenced
		by another object that is still pinned) it may not be removed at all
		after this.
		
		.. code-block:: python
		
			>>> client.pin.rm('QmfZY61ukoQuCX8e5Pt7v8pRfhkyxwZKZMTodAtmvyGZ5d')
			{'Pins': ['QmfZY61ukoQuCX8e5Pt7v8pRfhkyxwZKZMTodAtmvyGZ5d']}
		
		Parameters
		----------
		path
			Path to object(s) to be unpinned
		recursive
			Recursively unpin the object linked to by the specified object(s)
		
		Returns
		-------
			dict
		
		+------+-------------------------------------------------------------+
		| Pins | List of IPFS objects that have been unpinned by this action |
		+------+-------------------------------------------------------------+
		"""
		kwargs.setdefault("opts", {})["recursive"] = recursive
		
		args = (str(path), *(str(p) for p in paths))
		return self._client.request('/pin/rm', args, decoder='json', **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def update(self, from_path: base.cid_t, to_path: base.cid_t, *,
	           unpin: bool = True, **kwargs: base.CommonArgs):
		"""Replaces one pin with another
		
		Updates one pin to another, making sure that all objects in the new pin
		are local. Then removes the old pin. This is an optimized version of
		using first using :meth:`~ipfshttpclient.Client.pin.add` to add a new pin
		for an object and then using :meth:`~ipfshttpclient.Client.pin.rm` to remove
		the pin for the old object.
		
		.. code-block:: python
		
			>>> client.pin.update("QmXMqez83NU77ifmcPs5CkNRTMQksBLkyfBf4H5g1NZ52P",
			...              "QmUykHAi1aSjMzHw3KmBoJjqRUQYNkFXm8K1y7ZsJxpfPH")
			{"Pins": ["/ipfs/QmXMqez83NU77ifmcPs5CkNRTMQksBLkyfBf4H5g1NZ52P",
					  "/ipfs/QmUykHAi1aSjMzHw3KmBoJjqRUQYNkFXm8K1y7ZsJxpfPH"]}
		
		Parameters
		----------
		from_path
			Path to the old object
		to_path
			Path to the new object to be pinned
		unpin
			Should the pin of the old object be removed?
		
		Returns
		-------
			dict
		
		+------+-------------------------------------------------------------+
		| Pins | List of IPFS objects that have been affected by this action |
		+------+-------------------------------------------------------------+
		"""
		kwargs.setdefault("opts", {})["unpin"] = unpin
		
		args = (str(from_path), str(to_path))
		return self._client.request('/pin/update', args, decoder='json', **kwargs)
	
	
	@base.returns_multiple_items(base.ResponseBase, stream=True)
	def verify(self, path: base.cid_t, *paths: base.cid_t, verbose: bool = False,
	           **kwargs: base.CommonArgs):
		"""Verifies that all recursive pins are completely available in the local
		repository
		
		Scan the repo for pinned object graphs and check their integrity.
		Issues will be reported back with a helpful human-readable error
		message to aid in error recovery. This is useful to help recover
		from datastore corruptions (such as when accidentally deleting
		files added using the filestore backend).
		
		This function returns an iterator has to be exhausted or closed
		using either a context manager (``with``-statement) or its
		``.close()`` method.
		
		.. code-block:: python
		
			>>> with client.pin.verify("QmN…TTZ", verbose=True) as pin_verify_iter:
			...     for item in pin_verify_iter:
			...         print(item)
			...
			{"Cid":"QmVkNdzCBukBRdpyFiKPyL2R15qPExMr9rV9RFV2kf9eeV","Ok":True}
			{"Cid":"QmbPzQruAEFjUU3gQfupns6b8USr8VrD9H71GrqGDXQSxm","Ok":True}
			{"Cid":"Qmcns1nUvbeWiecdGDPw8JxWeUfxCV8JKhTfgzs3F8JM4P","Ok":True}
			…
		
		Parameters
		----------
		path
			Path to object(s) to be checked
		verbose
			Also report status of items that were OK?
		
		Returns
		-------
			Iterable[dict]
		
		+-----+----------------------------------------------------+
		| Cid | IPFS object ID checked                             |
		+-----+----------------------------------------------------+
		| Ok  | Whether the given object was successfully verified |
		+-----+----------------------------------------------------+
		"""
		kwargs.setdefault("opts", {})["verbose"] = verbose
		
		args = (str(path), *(str(p) for p in paths))
		return self._client.request('/pin/verify', args, decoder='json', stream=True, **kwargs)