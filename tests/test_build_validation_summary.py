import os
import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).parents[1]
WORKFLOW = ROOT / ".github/workflows/build-validation.yml"
HOOK = ROOT / ".githooks/pre-commit"


class ValidationWorkflowTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.workflow = WORKFLOW.read_text()

    def test_workflow_uses_only_credential_free_syntax_and_test_checks(self):
        for forbidden in ("secrets.", "NIX_SECRETS_DEPLOY_KEY", "ssh-agent", "nix build", "nix eval", "sops"):
            with self.subTest(forbidden=forbidden):
                self.assertNotIn(forbidden.lower(), self.workflow.lower())

        self.assertIn("git ls-files -z -- '*.nix'", self.workflow)
        self.assertIn('nix-instantiate --parse "$file"', self.workflow)
        self.assertIn("git ls-files -z -- '*.sh'", self.workflow)
        self.assertIn('bash -n "$file"', self.workflow)
        self.assertIn("python3 -m unittest discover -s tests", self.workflow)
        self.assertNotIn("system closure", self.workflow.lower())


class ValidationHookTests(unittest.TestCase):
    def setUp(self):
        self.hook = HOOK.read_text()

    def test_hook_runs_tracked_source_checks_without_flake_or_secret_access(self):
        for required in (
            "git ls-files -z -- '*.nix'",
            'nix-instantiate --parse "$file"',
            "git ls-files -z -- '*.sh'",
            'bash -n "$file"',
            "PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests",
        ):
            with self.subTest(check=required):
                self.assertIn(required, self.hook)

        for forbidden in ("nix build", "nix eval", "nix flake", "sops", "ssh-agent"):
            with self.subTest(forbidden=forbidden):
                self.assertNotIn(forbidden, self.hook.lower())

    def test_hook_stops_when_nix_syntax_check_fails(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            failing_nix = Path(temp_dir) / "nix-instantiate"
            failing_nix.write_text("#!/bin/sh\\nexit 1\\n")
            failing_nix.chmod(0o755)
            result = subprocess.run(
                [str(HOOK)],
                env=os.environ | {"PATH": f"{temp_dir}:{os.environ['PATH']}"},
                capture_output=True,
                text=True,
            )

        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn("Ran ", result.stdout + result.stderr)

    def test_hook_is_executable(self):
        self.assertTrue(HOOK.stat().st_mode & 0o111)

    def test_documentation_covers_setup_prerequisites_and_limits(self):
        docs = (ROOT / "docs/build-validation.md").read_text()
        for required in (
            "git config core.hooksPath .githooks",
            "nix-instantiate",
            "bash",
            "python3",
            "bypassable",
            "private `secrets` flake input",
            "do not validate host builds",
        ):
            with self.subTest(detail=required):
                self.assertIn(required, docs)


if __name__ == "__main__":
    unittest.main()
