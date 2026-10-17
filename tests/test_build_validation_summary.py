import os
import subprocess
import tempfile
import textwrap
import unittest
from pathlib import Path


WORKFLOW = Path(__file__).parents[1] / ".github/workflows/build-validation.yml"


class ValidationSummaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.workflow = WORKFLOW.read_text()
        cls.summary = cls.workflow.split("      - name: Report validation coverage\n", 1)[1]

    def test_summary_gates_success_claims_on_step_outcomes(self):
        for step_id, env_name in (
            ("nix_syntax", "NIX_SYNTAX_SUCCEEDED"),
            ("nixos_build", "NIXOS_BUILD_SUCCEEDED"),
            ("macos_eval", "MACOS_EVAL_SUCCEEDED"),
        ):
            with self.subTest(step=step_id):
                self.assertIn(
                    f"{env_name}: ${{{{ steps.{step_id}.outcome == 'success' }}}}",
                    self.summary,
                )
                self.assertRegex(
                    self.summary,
                    rf'if \[ "\${env_name}" = "true" \]; then',
                )

    def run_summary(self, *, secrets_available, fork, syntax, build, macos):
        script = textwrap.dedent(self.summary.split("        run: |\n", 1)[1])
        with tempfile.NamedTemporaryFile() as summary:
            env = os.environ | {
                "GITHUB_STEP_SUMMARY": summary.name,
                "SECRETS_AVAILABLE": secrets_available,
                "PULL_REQUEST_FORK": fork,
                "NIX_SYNTAX_OUTCOME": syntax,
                "NIX_SYNTAX_SUCCEEDED": str(syntax == "success").lower(),
                "NIXOS_BUILD_OUTCOME": build,
                "NIXOS_BUILD_SUCCEEDED": str(build == "success").lower(),
                "MACOS_EVAL_OUTCOME": macos,
                "MACOS_EVAL_SUCCEEDED": str(macos == "success").lower(),
            }
            subprocess.run(["bash", "-e", "-c", script], env=env, check=True)
            summary.seek(0)
            return summary.read().decode()

    def test_failed_build_is_not_reported_as_built(self):
        summary = self.run_summary(
            secrets_available="true", fork="false", syntax="success", build="failure", macos="success"
        )
        self.assertIn("NixOS system closure: build failed.", summary)
        self.assertNotIn("NixOS system closure: built successfully.", summary)

    def test_fork_skips_secret_dependent_checks_but_reports_syntax(self):
        summary = self.run_summary(
            secrets_available="false", fork="true", syntax="success", build="skipped", macos="skipped"
        )
        self.assertIn("Nix flake syntax: passed.", summary)
        self.assertIn("NixOS system closure: skipped because the private secrets input was unavailable.", summary)
        self.assertIn("macOS system derivations: evaluation skipped", summary)

    def test_summary_distinguishes_failure_skip_and_unsupported_build(self):
        for phrase in (
            "Nix flake syntax: failed.",
            "NixOS system closure: build failed.",
            "NixOS system closure: skipped because the private secrets input was unavailable.",
            "macOS system derivations: evaluation failed;",
            "building aarch64-darwin outputs is unsupported on Linux CI.",
        ):
            with self.subTest(phrase=phrase):
                self.assertIn(phrase, self.summary)

    def test_secret_is_not_in_summary_step_environment_or_output(self):
        summary_env = self.summary.split("        run: |", 1)[0]
        summary_run = self.summary.split("        run: |", 1)[1]
        self.assertNotIn("NIX_SECRETS_DEPLOY_KEY", summary_env)
        self.assertNotIn("NIX_SECRETS_DEPLOY_KEY", summary_run)

    def test_fork_and_trusted_secret_gating_is_preserved(self):
        self.assertIn(
            "steps.secrets.outputs.available != 'true' && (github.event_name != 'pull_request' || github.event.pull_request.head.repo.fork != true)",
            self.workflow,
        )
        self.assertIn(
            "if: steps.secrets.outputs.available == 'true'\n        uses: webfactory/ssh-agent",
            self.workflow,
        )


if __name__ == "__main__":
    unittest.main()
