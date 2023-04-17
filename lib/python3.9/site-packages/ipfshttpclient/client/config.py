from . import base

from .. import utils


class Section(base.SectionBase):
	@base.returns_single_item(base.ResponseBase)
	def get(self, **kwargs: base.CommonArgs):
		#TODO: Support the optional `key` parameter
		"""Returns the currently used node configuration
		
		.. code-block:: python
		
			>>> config = client.config.get()
			>>> config['Addresses']
			{'API': '/ip4/127.0.0.1/tcp/5001',
			 'Gateway': '/ip4/127.0.0.1/tcp/8080',
			 'Swarm': ['/ip4/0.0.0.0/tcp/4001', '/ip6/::/tcp/4001']},
			>>> config['Discovery']
			{'MDNS': {'Enabled': True, 'Interval': 10}}
		
		Returns
		-------
			dict
				The entire IPFS daemon configuration
		"""
		return self._client.request('/config/show', decoder='json', **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def replace(self, config: utils.json_dict_t, **kwargs: base.CommonArgs):
		"""Replaces the existing configuration with a new configuration tree
		
		Make sure to back up the config file first if neccessary, as this
		operation can not be undone.
		"""
		return self._client.request('/config/replace', (config,), decoder='json', **kwargs)
	
	
	@base.returns_single_item(base.ResponseBase)
	def set(self, key: str, value: utils.json_value_t = None, **kwargs: base.CommonArgs):
		"""Adds or replaces a single configuration value
		
		.. code-block:: python
		
			>>> client.config.set("Addresses.Gateway")
			{'Key': 'Addresses.Gateway', 'Value': '/ip4/127.0.0.1/tcp/8080'}
			>>> client.config.set("Addresses.Gateway", "/ip4/127.0.0.1/tcp/8081")
			{'Key': 'Addresses.Gateway', 'Value': '/ip4/127.0.0.1/tcp/8081'}
		
		Parameters
		----------
		key
			The key of the configuration entry (e.g. "Addresses.API")
		value
			The value to set the configuration entry to
		
		Returns
		-------
			dict
		
		+-------+---------------------------------------------+
		| Key   | The requested configuration key             |
		+-------+---------------------------------------------+
		| Value | The new value of the this configuration key |
		+-------+---------------------------------------------+
		"""
		args = (key, value)
		return self._client.request('/config', args, decoder='json', **kwargs)