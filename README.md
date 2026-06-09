# ip-000001

Display name: APB4 UART Controller

UID: ip-000001

Family: uart

Category: peripheral

Repository: git@github.com:openecos-projects/ip-000001.git

Upstream: https://github.com/retroSoC/uart

Upstream author/maintainer: retroSoC; known contributor: maksyuki

Current baseline: source snapshot imported as `20250627`

License: MulanPSL-2.0, with selected files carrying Solderpad Hardware License 0.51 provenance notices

Status: candidate

This repository is managed as a child repository of `ip-catalog`.

## Summary

This IP is an APB4-based UART controller implemented in SystemVerilog. The design provides UART transmit/receive logic, programmable baud-rate division, configurable word length, stop bit and parity settings, independent TX/RX FIFOs, and maskable interrupt status.

The local repository contains a source mirror for catalog evaluation. It does not perform automated upstream synchronization.

## Layout

```text
rtl/       SystemVerilog RTL and reusable support modules
tb/        SystemVerilog testbench files
model/     RS232 simulation model
docs/      Local catalog and provenance notes
reports/   Review, lint, simulation, or synthesis report summaries
```

## Catalog Mapping

The corresponding catalog record is expected at:

```text
data/ip/peripheral/ip-000001.yaml
```

The local metadata source is:

```text
ip.yaml
```

## Review Notes

- Upstream repository: https://github.com/retroSoC/uart
- Upstream default branch observed: `main`
- Upstream public description: `An APB4-based UART Controller`
- GitHub currently identifies the upstream license as `MulanPSL-2.0`.
- Several RTL files retain ETH Zurich / University of Bologna Solderpad Hardware License 0.51 provenance notices.
- Verification status is candidate-level only; no local passing simulation report has been added yet.
