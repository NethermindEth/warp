from __future__ import annotations

import glob
import os

abspath = os.path.abspath
joinpath = os.path.join


class Artifacts:
    def __init__(self, contract_path):
        self.base_source_dir = abspath(joinpath(contract_path, "../"))
        self.artifacts_dir = os.path.abspath(
            os.path.join(self.base_source_dir, "artifacts")
        )
        if not os.path.isdir(self.artifacts_dir):
            os.makedirs(self.artifacts_dir)
        self.clear_artifacts_dir()

    def write_artifact(self, artifact_name: str, artifact_data: str):
        path = abspath(joinpath(self.artifacts_dir, artifact_name))
        with open(path, "w") as f:
            f.write(artifact_data)

    def clear_artifacts_dir(self):
        if os.path.exists(self.artifacts_dir):
            files = glob.glob(os.path.join(self.artifacts_dir, "*"))
            for f in files:
                os.remove(f)
