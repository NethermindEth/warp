import typing as ty

from . import base


class Section(base.SectionBase):
	@base.returns_single_item(base.ResponseBase)
	def publish(self, ipfs_path: str,
	            resolve: bool = True, lifetime: ty.Union[str, int] = "24h",
	            ttl: ty.Union[str, int] = None, key: str = None,
	            allow_offline: bool = False, **kwargs: base.CommonArgs):
		"""Publishes an object to IPNS
		
		IPNS is a PKI namespace, where names are the hashes of public keys, and
		the private key enables publishing new (signed) values. In publish, the
		default value of *name* is your own identity public key.
		
		.. code-block:: python
		
			>>> client.name.publish('/ipfs/QmfZY61ukoQuCX8e5Pt7v8pRfhkyxwZK … GZ5d')
			{'Value': '/ipfs/QmfZY61ukoQuCX8e5Pt7v8pRfhkyxwZKZMTodAtmvyGZ5d',
			 'Name': 'QmVgNoP89mzpgEAAqK8owYoDEyB97MkcGvoWZir8otE9Uc'}
		
		Parameters
		----------
		ipfs_path
			IPFS path of the object to be published
		allow_offline
			 When offline, save the IPNS record to the the local
			 datastore without broadcasting to the network instead
			 of simply failing.
		lifetime
			Time duration that the record will be valid for
			
			Accepts durations such as ``"300s"``, ``"1.5h"`` or ``"2h45m"``.
			Valid units are:
			
			 * ``"ns"``
			 * ``"us"`` (or ``"µs"``)
			 * ``"ms"``
			 * ``"s"``
			 * ``"m"``
			 * ``"h"``
		resolve
			Resolve given path before publishing
		ttl
			Time duration this record should be cached for.
			Same syntax like 'lifetime' option. (experimental feature)
		key
			Name of the key to be used, as listed by 'ipfs key list'.
		
		Returns
		-------
			dict
		
		+-------+----------------------------------------------------------+
		| Name  | Key ID of the key to which the given value was published |
		+-------+----------------------------------------------------------+
		| Value | Value that was published                                 |
		+-------+----------------------------------------------------------+
		"""
		opts = {"lifetime": str(lifetime),
		        "resolve": resolve,
		        "allow-offline": allow_offline}
		if ttl:
			opts["ttl"] = str(ttl)
		if key:
			opts["key"] = key
		kwargs.setdefault("opts", {}).update(opts)
		
		args = (ipfs_path,)
		return self._client.request('/name/publish', args, decoder='json', **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def resolve(self, name: str = None, recursive: bool = False,
	            nocache: bool = False, dht_record_count: ty.Optional[int] = None,
	            dht_timeout: ty.Optional[ty.Union[str, int]] = None,
	            **kwargs: base.CommonArgs):
		"""Retrieves the value currently published at the given IPNS name
		
		IPNS is a PKI namespace, where names are the hashes of public keys, and
		the private key enables publishing new (signed) values. In resolve, the
		default value of ``name`` is your own identity public key.
		
		.. code-block:: python
		
			>>> client.name.resolve()
			{'Path': '/ipfs/QmfZY61ukoQuCX8e5Pt7v8pRfhkyxwZKZMTodAtmvyGZ5d'}
		
		Parameters
		----------
		name
			The IPNS name to resolve (defaults to the connected node)
		recursive
			Resolve until the result is not an IPFS name (default: false)
		nocache
			Do not use cached entries (default: false)
		dht_record_count
			Number of records to request for DHT resolution.
		dht_timeout
			Maximum time to collect values during DHT resolution, e.g. "30s".
			
			For the exact syntax see the ``lifetime`` argument on
			:meth:`~ipfshttpclient.Client.name.publish`. Set this parameter to
			``0`` to disable the timeout.
		
		Returns
		-------
			dict
		
		+------+--------------------------------------+
		| Path | The resolved value of the given name |
		+------+--------------------------------------+
		"""
		opts = {"recursive": recursive, "nocache": nocache}
		if dht_record_count is not None:
			opts["dht-record-count"] = str(dht_record_count)
		if dht_timeout is not None:
			opts["dht-timeout"] = str(dht_timeout)
		
		kwargs.setdefault("opts", {}).update(opts)
		args = (name,) if name is not None else ()
		return self._client.request('/name/resolve', args, decoder='json', **kwargs)