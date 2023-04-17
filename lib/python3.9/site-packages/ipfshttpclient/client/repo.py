from . import base


class Section(base.SectionBase):
	@base.returns_multiple_items(base.ResponseBase)
	def gc(self, *, quiet: bool = False, **kwargs: base.CommonArgs):
		"""Removes stored objects that are not pinned from the repo
		
		.. code-block:: python
		
			>>> client.repo.gc()
			[{'Key': 'QmNPXDC6wTXVmZ9Uoc8X1oqxRRJr4f1sDuyQuwaHG2mpW2'},
			 {'Key': 'QmNtXbF3AjAk59gQKRgEdVabHcSsiPUnJwHnZKyj2x8Z3k'},
			 {'Key': 'QmRVBnxUCsD57ic5FksKYadtyUbMsyo9KYQKKELajqAp4q'},
			 …
			 {'Key': 'QmYp4TeCurXrhsxnzt5wqLqqUz8ZRg5zsc7GuUrUSDtwzP'}]
		
		Performs a garbage collection sweep of the local set of
		stored objects and remove ones that are not pinned in order
		to reclaim hard disk space. Returns the hashes of all collected
		objects.
		
		Parameters
		----------
		quiet
			Should the client will avoid downloading the list of removed objects?
			
			Passing ``True`` to this parameter often causing the GC process to
			speed up tremendously as it will also avoid generating the list of
			removed objects in the connected daemon at all.
		
		Returns
		-------
			dict
				List of IPFS objects that have been removed
		"""
		kwargs.setdefault("opts", {})["quiet"] = quiet
		
		return self._client.request('/repo/gc', decoder='json', **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def stat(self, **kwargs: base.CommonArgs):
		"""Returns local repository status information
		
		.. code-block:: python
		
			>>> client.repo.stat()
			{'NumObjects': 354,
			 'RepoPath': '…/.local/share/ipfs',
			 'Version': 'fs-repo@4',
			 'RepoSize': 13789310}
		
		Returns
		-------
			dict
				General information about the IPFS file repository
		
		+------------+-------------------------------------------------+
		| NumObjects | Number of objects in the local repo.            |
		+------------+-------------------------------------------------+
		| RepoPath   | The path to the repo being currently used.      |
		+------------+-------------------------------------------------+
		| RepoSize   | Size in bytes that the repo is currently using. |
		+------------+-------------------------------------------------+
		| Version    | The repo version.                               |
		+------------+-------------------------------------------------+
		"""
		return self._client.request('/repo/stat', decoder='json', **kwargs)
	
	
	#TODO: `version()`
