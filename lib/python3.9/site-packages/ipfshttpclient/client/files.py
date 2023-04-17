import typing as ty

from . import base

from .. import multipart
from .. import utils


class Section(base.SectionBase):
	"""Manage files in IPFS's virtual “Mutable File System” (MFS) file storage space"""
	
	@base.returns_no_item
	def cp(self, source: str, dest: str, **kwargs: base.CommonArgs):
		"""Creates a copy of a file within the MFS
		
		Due to the nature of IPFS this will not actually involve any copying of
		the file's content. Instead, a new link will be added to the directory
		containing *dest* referencing the CID of *source* – this is very similar
		to how hard links to read-only files work in classical filesystems.
		
		.. code-block:: python
		
			>>> client.files.ls("/")
			{'Entries': [
				{'Size': 0, 'Hash': '', 'Name': 'Software', 'Type': 0},
				{'Size': 0, 'Hash': '', 'Name': 'test', 'Type': 0}
			]}
			>>> client.files.cp("/test", "/bla")
			>>> client.files.ls("/")
			{'Entries': [
				{'Size': 0, 'Hash': '', 'Name': 'Software', 'Type': 0},
				{'Size': 0, 'Hash': '', 'Name': 'bla', 'Type': 0},
				{'Size': 0, 'Hash': '', 'Name': 'test', 'Type': 0}
			]}
		
		Parameters
		----------
		source
			Filepath within the MFS to copy from
		dest
			Destination filepath within the MFS to which the file will be
			copied/linked to
		"""
		args = (source, dest)
		return self._client.request('/files/cp', args, **kwargs)


	#TODO: Add `flush(path="/")`


	@base.returns_single_item(base.ResponseBase)
	def ls(self, path: str, **kwargs: base.CommonArgs):
		"""Lists contents of a directory in the MFS
		
		.. code-block:: python
		
			>>> client.files.ls("/")
			{'Entries': [
				{'Size': 0, 'Hash': '', 'Name': 'Software', 'Type': 0}
			]}
		
		Parameters
		----------
		path
			Filepath within the MFS
		
		Returns
		-------
			dict
		
		+---------+------------------------------------------+
		| Entries | List of files in the given MFS directory |
		+---------+------------------------------------------+
		"""
		args = (path,)
		return self._client.request('/files/ls', args, decoder='json', **kwargs)
	
	
	@base.returns_no_item
	def mkdir(self, path: str, parents: bool = False, **kwargs: base.CommonArgs):
		"""Creates a directory within the MFS
		
		.. code-block:: python
		
			>>> client.files.mkdir("/test")
		
		Parameters
		----------
		path
			Filepath within the MFS
		parents
			Create parent directories as needed and do not raise an exception
			if the requested directory already exists
		"""
		kwargs.setdefault("opts", {})["parents"] = parents
		
		args = (path,)
		return self._client.request('/files/mkdir', args, **kwargs)
	
	
	@base.returns_no_item
	def mv(self, source: str, dest: str, **kwargs: base.CommonArgs):
		"""Moves files and directories within the MFS
		
		.. code-block:: python
		
			>>> client.files.mv("/test/file", "/bla/file")
		
		Parameters
		----------
		source
			Existing filepath within the MFS
		dest
			Destination to which the file will be moved in the MFS
		"""
		args = (source, dest)
		return self._client.request('/files/mv', args, **kwargs)
	
	
	def read(self, path: str, offset: int = 0, count: ty.Optional[int] = None,
	         **kwargs: base.CommonArgs):
		"""Reads a file stored in the MFS
		
		.. code-block:: python
		
			>>> client.files.read("/bla/file")
			b'hi'
		
		Parameters
		----------
		path
			Filepath within the MFS
		offset
			Byte offset at which to begin reading at
		count
			Maximum number of bytes to read (default is the entire remaining length)
		
		Returns
		-------
			bytes : MFS file contents
		"""
		opts = {"offset": offset}
		if count is not None:
			opts["count"] = count
		kwargs.setdefault("opts", {}).update(opts)
		
		args = (path,)
		return self._client.request('/files/read', args, **kwargs)
	
	
	@base.returns_no_item
	def rm(self, path: str, recursive: bool = False, **kwargs: base.CommonArgs):
		"""Removes a file from the MFS
		
		Note that the file's contents will not actually be removed from the IPFS
		node until the next repository GC run. If it is important to have the
		file's contents erased from the node this may be done manually by calling
		:meth`~ipfshttpclient.Client.repo.gc` at a time of convenience.
		
		.. code-block:: python
		
			>>> client.files.rm("/bla/file")
		
		Parameters
		----------
		path
			Filepath within the MFS
		recursive
			Recursively remove directories?
		"""
		kwargs.setdefault("opts", {})["recursive"] = recursive
		
		args = (path,)
		return self._client.request('/files/rm', args, **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def stat(self, path: str, **kwargs: base.CommonArgs):
		"""Returns basic ``stat`` information for an MFS file (including its hash)
		
		.. code-block:: python
		
			>>> client.files.stat("/test")
			{'Hash': 'QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn',
			 'Size': 0, 'CumulativeSize': 4, 'Type': 'directory', 'Blocks': 0}
		
		Parameters
		----------
		path
			Filepath within the MFS
		
		Returns
		-------
			dict : MFS file information
		"""
		args = (path,)
		return self._client.request('/files/stat', args, decoder='json', **kwargs)
	
	
	@base.returns_no_item
	def write(self, path: str, file: utils.clean_file_t, offset: int = 0,
	          create: bool = False, truncate: bool = False,
	          count: ty.Optional[int] = None, **kwargs: base.CommonArgs):
		"""Writes a file into the MFS
		
		.. code-block:: python
		
			>>> client.files.write("/test/file", io.BytesIO(b"hi"), create=True)
		
		Parameters
		----------
		path
			Filepath within the MFS
		file
			IO stream object with data that should be written
		offset
			Byte offset at which to begin writing at
		create
			Create the file if it does not exist
		truncate
			Truncate the file to size zero before writing
		count
			Maximum number of bytes to read from the source ``file``
		"""
		opts = {"offset": offset, "create": create, "truncate": truncate}
		if count is not None:
			opts["count"] = count
		kwargs.setdefault("opts", {}).update(opts)
		
		args = (path,)
		body, headers = multipart.stream_files(file, chunk_size=self.chunk_size)
		return self._client.request('/files/write', args, data=body, headers=headers, **kwargs)


class Base(base.ClientBase):
	files = base.SectionProperty(Section)
	
	
	def add(self, file: utils.clean_file_t, *files: utils.clean_file_t,
	        recursive: bool = False,
	        pattern: multipart.match_spec_t[ty.AnyStr] = None,
	        trickle: bool = False, follow_symlinks: bool = False,
	        period_special: bool = True, only_hash: bool = False,
	        wrap_with_directory: bool = False, chunker: ty.Optional[str] = None,
	        pin: bool = True, raw_leaves: bool = None, nocopy: bool = False,
	        cid_version: ty.Optional[int] = None,
	        **kwargs: base.CommonArgs):
		"""Adds a file, several files or directory of files to IPFS
		
		Arguments marked as “directories only” will be ignored unless *file*
		refers to a directory path or file descriptor. Passing a directory file
		descriptor is currently restricted to Unix (due to Python standard
		library limitations on Windows) and will prevent the *nocopy* feature
		from working.
		
		.. code-block:: python
		
			>>> with io.open('nurseryrhyme.txt', 'w', encoding='utf-8') as f:
			... 	numbytes = f.write('Mary had a little lamb')
			>>> client.add('nurseryrhyme.txt')
			{'Hash': 'QmZfF6C9j4VtoCsTp4KSrhYH47QMd3DNXVZBKaxJdhaPab',
			 'Name': 'nurseryrhyme.txt'}
		
		Directory uploads
		-----------------
		
		By default only regular files and directories immediately below the given
		directory path/FD are uploaded to the connected IPFS node; to upload an
		entire directory tree instead, *recursive* can be set to ``True``.
		Symbolic links and special files (pipes, sockets, devices nodes, …) cannot
		be represented by the UnixFS data structure this call creates and hence
		are ignored while scanning the target directory, to include the targets
		of symbolic links in the upload set *follow_symlinks* to ``True``.
		
		The set of files and directories included in the upload may be restricted
		by passing any combination of glob matching strings, compiled regular
		expression objects and custom :class:`~ipfshttpclient.filescanner.Matcher`
		objects. A file or directory will be included if it matches of the
		patterns provided. For regular expressions please note that as predicting
		which directories are relevant to the given pattern is impossible to do
		reliably if *recursive* is set to ``True`` the entire directory hierarchy
		will always be scanned and compared to the given expression even if only
		very few files are actually matched by the expression. To avoid this, pass
		a custom matching class or use glob-patterns instead (which will only
		cause a scan of the directories required to match their value).
		
		Note that unlike the ``ipfs add`` CLI interface this implementation will
		be default include dot-files (“files that are hidden”) – any file or
		directory whose name starts with a period/dot character – in the upload.
		For behaviour that is similar to the CLI command set *pattern* to
		``"**"`` – this enables the default glob behaviour of not matching
		dot-files unless *period_special* is set to ``False`` or the pattern
		actually starts with a period.
		
		Arguments
		---------
		file
			A filepath, path-object, file descriptor or open file object the
			file or directory to add
		recursive
			Upload files in subdirectories, if *file* refers to a directory?
		pattern
			A :mod:`glob` pattern,
			compiled regular expression object or arbitrary matcher used to limit
			the files and directories included as part of adding a directory
			(directories only)
		trickle
			Use trickle-dag format (optimized for streaming) when generating
			the dag; see `the old FAQ <https://github.com/ipfs/faq/issues/218>`_
			for more information
		follow_symlinks
			Follow symbolic links when recursively scanning directories? (directories only)
		period_special
			Treat files and directories with a leading period character (“dot-files”)
			specially in glob patterns? (directories only)
			
			If this is set these files will only be matched by path labels whose
			initial character is a period, but not by those starting with ``?``,
			``*`` or ``[``.
		only_hash
			Only chunk and hash, but do not write to disk
		wrap_with_directory
			Wrap files with a directory object to preserve their filename
		chunker
			The chunking algorithm to use
		pin
			Pin this object when adding
		raw_leaves
			Use raw blocks for leaf nodes. (experimental). (Default: ``True``
			when *nocopy* is True, or ``False`` otherwise)
		nocopy
			Add the file using filestore. Implies raw-leaves. (experimental).
		cid_version
			CID version. Default value is provided by IPFS daemon. (experimental)
		
		Returns
		-------
			Union[dict, list]
				File name and hash of the added file node, will return a list
				of one or more items unless only a single file (not directory)
				was given
		"""
		opts = {
			"trickle": trickle,
			"only-hash": only_hash,
			"wrap-with-directory": wrap_with_directory,
			"pin": pin,
			"raw-leaves": raw_leaves if raw_leaves is not None else nocopy,
			"nocopy": nocopy
		}  # type: ty.Dict[str, ty.Union[str, bool]]
		for option_name, option_value in [
			("chunker", chunker),
			("cid-version", cid_version),
		]:
			if option_value is not None:
				opts[option_name] = option_value
		kwargs.setdefault("opts", {}).update(opts)
		
		# There may be other cases where nocopy will silently fail to work, but
		# this is by far the most obvious one
		if isinstance(file, int) and nocopy:
			raise ValueError("Passing file descriptors is incompatible with *nocopy*")
		
		assert not isinstance(file, (tuple, list)), \
		       "Use `client.add(name1, name2, …)` to add several items"
		multiple = (len(files) > 0)
		to_send  = ((file,) + files) if multiple else file
		body, headers, is_dir = multipart.stream_filesystem_node(
			to_send, chunk_size=self.chunk_size, follow_symlinks=follow_symlinks,
			period_special=period_special, patterns=pattern, recursive=recursive
		)
		
		resp = self._client.request('/add', decoder='json', data=body, headers=headers, **kwargs)
		if not multiple and not is_dir and not wrap_with_directory:
			assert len(resp) == 1
			return base.ResponseBase(resp[0])
		elif kwargs.get("stream", False):
			return base.ResponseWrapIterator(resp, base.ResponseBase)
		return [base.ResponseBase(v) for v in resp]
	
	
	@base.returns_no_item
	def get(self, cid: base.cid_t, target: utils.path_t = ".",
	        **kwargs: base.CommonArgs) -> None:
		"""Downloads a file, or directory of files from IPFS
		
		Parameters
		----------
		cid
			The path to the IPFS object(s) to be outputted
		target
			The directory to place the downloaded files in
			
			Defaults to the current working directory.
		"""
		args = (str(cid),)
		return self._client.download('/get', target, args, **kwargs)
	
	
	def cat(self, cid: base.cid_t, offset: int = 0,
	        length: ty.Optional[int] = None, **kwargs: base.CommonArgs):
		r"""Retrieves the contents of a file identified by hash
		
		.. code-block:: python
		
			>>> client.cat('QmTkzDwWqPbnAh5YiV5VwcTLnGdwSNsNTn2aDxdXBFca7D')
			Traceback (most recent call last):
			  ...
			ipfsapi.exceptions.Error: this dag node is a directory
			>>> client.cat('QmeKozNssnkJ4NcyRidYgDY2jfRZqVEoRGfipkgath71bX')
			b'<!DOCTYPE html>\n<html>\n\n<head>\n<title>ipfs example viewer</…'
		
		Parameters
		----------
		cid
			The name or path of the IPFS object(s) to be retrieved
		offset
			Byte offset to begin reading from
		length
			Maximum number of bytes to read (defaults to reading the entire file)
		
		Returns
		-------
			bytes
				The file's contents
		"""
		args = (str(cid),)
		opts = {}
		if offset != 0:
			opts['offset'] = offset
		if length is not None:
			opts['length'] = length
		kwargs.setdefault('opts', opts)
		return self._client.request('/cat', args, **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def ls(self, cid: base.cid_t, **kwargs: base.CommonArgs):
		"""Returns a list of objects linked to by the given hash
		
		.. code-block:: python
		
			>>> client.ls('QmTkzDwWqPbnAh5YiV5VwcTLnGdwSNsNTn2aDxdXBFca7D')
			{'Objects': [
				{'Hash': 'QmTkzDwWqPbnAh5YiV5VwcTLnGdwSNsNTn2aDxdXBFca7D',
					'Links': [
						{'Hash': 'Qmd2xkBfEwEs9oMTk77A6jrsgurpF3ugXSg7dtPNFkcNMV',
						 'Name': 'Makefile',          'Size': 174, 'Type': 2},
						…
						{'Hash': 'QmSY8RfVntt3VdxWppv9w5hWgNrE31uctgTiYwKir8eXJY',
						 'Name': 'published-version', 'Size': 55,  'Type': 2}
					]
				}
			]}
		
		Parameters
		----------
		cid
			The path to the IPFS object(s) to list links from
		
		Returns
		-------
			dict
				Directory information and contents
		"""
		args = (str(cid),)
		return self._client.request('/ls', args, decoder='json', **kwargs)
