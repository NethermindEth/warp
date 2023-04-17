from . import base


class LogSection(base.SectionBase):
	@base.returns_single_item(base.ResponseBase)
	def level(self, subsystem: str, level: str, **kwargs: base.CommonArgs):
		r"""Changes the logging output level for a given subsystem
		
		**This API is subject to future change or removal!**
		
		.. code-block:: python
		
			>>> client.unstable.log.level("path", "info")
			{"Message": "Changed log level of 'path' to 'info'\n"}
		
		Parameters
		----------
		subsystem
			The subsystem logging identifier (Use ``"all"`` for all subsystems)
		level
			The desired logging level. Must be one of:
			
			 * ``"debug"``
			 * ``"info"``
			 * ``"warning"``
			 * ``"error"``
			 * ``"fatal"``
			 * ``"panic"``
		
		Returns
		-------
			dict
		
		+--------+-----------------------+
		| Status | Textual status report |
		+--------+-----------------------+
		"""
		args = (subsystem, level)
		return self._client.request('/log/level', args,
		                            decoder='json', **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def ls(self, **kwargs: base.CommonArgs):
		"""Lists the available logging subsystems
		
		**This API is subject to future change or removal!**
		
		.. code-block:: python
		
			>>> client.unstable.log.ls()
			{'Strings': [
				'github.com/ipfs/go-libp2p/p2p/host', 'net/identify',
				'merkledag', 'providers', 'routing/record', 'chunk', 'mfs',
				'ipns-repub', 'flatfs', 'ping', 'mockrouter', 'dagio',
				'cmds/files', 'blockset', 'engine', 'mocknet', 'config',
				'commands/http', 'cmd/ipfs', 'command', 'conn', 'gc',
				'peerstore', 'core', 'coreunix', 'fsrepo', 'core/server',
				'boguskey', 'github.com/ipfs/go-libp2p/p2p/host/routed',
				'diagnostics', 'namesys', 'fuse/ipfs', 'node', 'secio',
				'core/commands', 'supernode', 'mdns', 'path', 'table',
				'swarm2', 'peerqueue', 'mount', 'fuse/ipns', 'blockstore',
				'github.com/ipfs/go-libp2p/p2p/host/basic', 'lock', 'nat',
				'importer', 'corerepo', 'dht.pb', 'pin', 'bitswap_network',
				'github.com/ipfs/go-libp2p/p2p/protocol/relay', 'peer',
				'transport', 'dht', 'offlinerouting', 'tarfmt', 'eventlog',
				'ipfsaddr', 'github.com/ipfs/go-libp2p/p2p/net/swarm/addr',
				'bitswap', 'reprovider', 'supernode/proxy', 'crypto', 'tour',
				'commands/cli', 'blockservice']}
		
		Returns
		-------
			dict
		
		+---------+-----------------------------------+
		| Strings | List of daemon logging subsystems |
		+---------+-----------------------------------+
		"""
		return self._client.request('/log/ls', decoder='json', **kwargs)
	
	
	@base.returns_multiple_items(base.ResponseBase, stream=True)
	def tail(self, **kwargs: base.CommonArgs):
		r"""Streams log outputs as they are generated
		
		**This API is subject to future change or removal!**
		
		This function returns an iterator that needs to be closed using a
		context manager (``with``-statement) or using the ``.close()`` method.
		
		.. code-block:: python
		
			>>> with client.unstable.log.tail() as log_tail_iter:
			...     for item in log_tail_iter:
			...         print(item)
			...
			{"event":"updatePeer","system":"dht",
			 "peerID":"QmepsDPxWtLDuKvEoafkpJxGij4kMax11uTH7WnKqD25Dq",
			 "session":"7770b5e0-25ec-47cd-aa64-f42e65a10023",
			 "time":"2016-08-22T13:25:27.43353297Z"}
			{"event":"handleAddProviderBegin","system":"dht",
			 "peer":"QmepsDPxWtLDuKvEoafkpJxGij4kMax11uTH7WnKqD25Dq",
			 "session":"7770b5e0-25ec-47cd-aa64-f42e65a10023",
			 "time":"2016-08-22T13:25:27.433642581Z"}
			{"event":"handleAddProvider","system":"dht","duration":91704,
			 "key":"QmNT9Tejg6t57Vs8XM2TVJXCwevWiGsZh3kB4HQXUZRK1o",
			 "peer":"QmepsDPxWtLDuKvEoafkpJxGij4kMax11uTH7WnKqD25Dq",
			 "session":"7770b5e0-25ec-47cd-aa64-f42e65a10023",
			 "time":"2016-08-22T13:25:27.433747513Z"}
			{"event":"updatePeer","system":"dht",
			 "peerID":"QmepsDPxWtLDuKvEoafkpJxGij4kMax11uTH7WnKqD25Dq",
			 "session":"7770b5e0-25ec-47cd-aa64-f42e65a10023",
			 "time":"2016-08-22T13:25:27.435843012Z"}
			…
		
		Returns
		-------
			Iterable[dict]
		"""
		return self._client.request('/log/tail', decoder='json',
		                            stream=True, **kwargs)



class RefsSection(base.SectionBase):
	@base.returns_multiple_items(base.ResponseBase)
	def __call__(self, cid: base.cid_t, **kwargs: base.CommonArgs):
		"""Returns the hashes of objects referenced by the given hash
		
		**This API is subject to future change or removal!** You likely want to
		use :meth:`~ipfshttpclient.object.links` instead.
		
		.. code-block:: python
		
			>>> client.unstable.refs('QmTkzDwWqPbnAh5YiV5VwcTLnGdwSNsNTn2aDxdXBFca7D')
			[{'Ref': 'Qmd2xkBfEwEs9oMTk77A6jrsgurpF3ugXSg7 … cNMV', 'Err': ''},
			 …
			 {'Ref': 'QmSY8RfVntt3VdxWppv9w5hWgNrE31uctgTi … eXJY', 'Err': ''}]
		
		Parameters
		----------
		cid
			Path to the object(s) to list refs from
		
		Returns
		-------
			list
		"""
		args = (str(cid),)
		return self._client.request('/refs', args, decoder='json', **kwargs)


	@base.returns_multiple_items(base.ResponseBase)
	def local(self, **kwargs: base.CommonArgs):
		"""Returns the hashes of all local objects
		
		**This API is subject to future change or removal!**
		
		.. code-block:: python
		
			>>> client.unstable.refs.local()
			[{'Ref': 'Qmd2xkBfEwEs9oMTk77A6jrsgurpF3ugXSg7 … cNMV', 'Err': ''},
			 …
			 {'Ref': 'QmSY8RfVntt3VdxWppv9w5hWgNrE31uctgTi … eXJY', 'Err': ''}]
		
		Returns
		-------
			list
		"""
		return self._client.request('/refs/local', decoder='json', **kwargs)



class Section(base.SectionBase):
	"""Features that are subject to change and are only provided for convenience"""
	log  = base.SectionProperty(LogSection)
	refs = base.SectionProperty(RefsSection)