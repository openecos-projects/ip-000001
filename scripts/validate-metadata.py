#!/usr/bin/env python3
"""Validate the minimum child-repository metadata required by ip-catalog."""

from __future__ import annotations

from pathlib import Path
from typing import Any

import yaml


ROOT = Path(__file__).resolve().parents[1]
IP_YAML = ROOT / "ip.yaml"


def require_mapping(data: dict[str, Any], path: str) -> dict[str, Any]:
    current: Any = data
    for key in path.split("."):
        if not isinstance(current, dict) or key not in current:
            raise ValueError(f"missing required field: {path}")
        current = current[key]
    if not isinstance(current, dict):
        raise ValueError(f"field must be a mapping: {path}")
    return current


def require_value(data: dict[str, Any], path: str) -> Any:
    current: Any = data
    for key in path.split("."):
        if not isinstance(current, dict) or key not in current:
            raise ValueError(f"missing required field: {path}")
        current = current[key]
    if current in (None, "", []):
        raise ValueError(f"field must not be empty: {path}")
    return current


def main() -> None:
    with IP_YAML.open("r", encoding="utf-8") as f:
        data = yaml.safe_load(f) or {}

    if not isinstance(data, dict):
        raise ValueError("ip.yaml must contain a mapping at document root")

    for field in (
        "uid",
        "repo_name",
        "slug",
        "display_name",
        "summary",
        "category",
        "ip_family",
        "implementation_style",
        "links.catalog_repository",
        "links.repository",
        "upstream.owner",
        "upstream.repository",
        "upstream.author",
        "technical.languages",
        "technical.interfaces",
        "legal.license",
        "legal.license_risk",
        "quality.maturity",
        "internal.status",
        "metadata.first_seen_at",
        "metadata.last_reviewed_at",
    ):
        require_value(data, field)

    require_mapping(data, "catalog")

    if data["uid"] != "ip-000001":
        raise ValueError("uid must be ip-000001")
    if data["repo_name"] != "ip-000001":
        raise ValueError("repo_name must be ip-000001")
    if data["category"] != "peripheral":
        raise ValueError("category must be peripheral")
    if data["links"]["repository"] != "https://github.com/retroSoC/uart":
        raise ValueError("upstream repository link must reference retroSoC/uart")
    if data["upstream"].get("sync_policy") != "none":
        raise ValueError("upstream.sync_policy must remain none")

    print("metadata validation passed")


if __name__ == "__main__":
    main()
