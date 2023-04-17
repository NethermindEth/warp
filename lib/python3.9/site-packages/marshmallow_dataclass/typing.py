import marshmallow.fields
from . import NewType

Url = NewType("Url", str, field=marshmallow.fields.Url)
Email = NewType("Email", str, field=marshmallow.fields.Email)

# Aliases
URL = Url
