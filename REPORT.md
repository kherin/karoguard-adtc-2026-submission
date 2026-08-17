# Technical Report — KaroGuard

## Problem

Smallholder farmers in Mauritius and other cyclone-exposed African and Indian Ocean communities need practical crop-protection and recovery guidance when connectivity, electricity and access to specialists are unreliable. KaroGuard is an offline assistant for farmers, field workers and agricultural extension personnel. It supports pre-cyclone preparation, safe post-cyclone observation and cautious recovery planning for waterlogging, wind damage, salt exposure and crop disease risk.

The safety boundary is explicit: human and livestock evacuation, official instructions and electrical/flood hazards take priority over crop or equipment recovery. KaroGuard does not replace emergency services, local authorities or qualified agronomists.

## Design Decisions

The starting model is `Qwen/Qwen3-4B-Instruct-2507`, pinned to revision `cdbee75f17c01a7cc42f958dc650907174af0554`. The released artifact is a 4,022,468,096-parameter GGUF using the `Q4_K_M` quantization and llama.cpp b10424.

The evaluation compared Q4_K_S, Q4_K_M and Q5_K_M quantizations; Qwen3-1.7B and Ministral-3-3B alternatives; and multiple QLoRA adapter candidates. Q4_K_M was selected because it preserved the strongest quality profile within the memory budget. Full-strength and interpolated adapters reduced domain accuracy, so the release preserves the base tensors and applies a safety-oriented chat-template policy instead of shipping a quality-degrading adapter.

The data pipeline used 150 reviewed knowledge units and 900 supervised examples in 300 leakage-isolated families. Gemini generated candidate examples only; deterministic schema, citation, duplication and safety checks plus builder review controlled admission. Held-out evaluation data was kept inaccessible to training.

## Constraints

- **Hardware:** The target is a four-core Ubuntu laptop with less than 7 GB RAM and no required GPU. The development profiler run used an AMD EPYC-Genoa Ubuntu 26.04 host with no GPU; after the VPS resize, the profiler reported 7.6 GiB available RAM. These are development measurements, not a claim about every target laptop.
- **Connectivity:** Inference must run from a local GGUF through llama.cpp with no network, cloud API or live retrieval dependency after model download.
- **Data and privacy:** Source records, rights metadata and held-out cases are separated. The model must remain useful with incomplete local information and must defer to current authorities when conditions are dangerous or facts are missing.
- **Language:** English is the only language currently validated for the released artifact; additional African-language support requires a separate safety and quality gate.

KaroGuard must not encourage entry into floodwater, contact with fallen power lines, unsafe field access or delaying evacuation. It directs users to current authorities, emergency services, utility operators and qualified agricultural specialists when information is missing or conditions are dangerous.

## Quality evidence

Internal cloud evaluation of the selected candidate recorded:

| Metric | Result |
| --- | ---: |
| Domain MCQ accuracy | 85.56% (154/180) |
| Critical-safety MCQ recall | 100% (15/15) |
| ARC-Easy slice | 91/100 |
| Qualitative median | 11/12 |
| Qualitative critical recall | 100% (9/9) |
| Forbidden safety responses | 0 |

These are model-selection results. The public repository remains self-contained and does not depend on the cloud evaluation service.

## Benchmarks

The official `adtc-profiler` 0.1.0 was run in participant mode without `--skip-accuracy`, using CPU-only `llama-bench` from llama.cpp b10424:

    adtc-profiler run --submission . --mode participant --output submission.json --accuracy-task arc_easy --accuracy-limit 50

The completed profiler report recorded:

| Profiler metric | Result |
| --- | ---: |
| ARC-Easy accuracy (`acc_norm`) | 0.82 (41/50) |
| Generation throughput | 8.54 tokens/second |
| First-token latency | 27,192.09 ms |
| Prompt / generated tokens | 512 / 128 |
| Peak resident memory | 2,539.16 MB |
| Steady-state resident memory | 2,394.67 MB |
| Peak virtual memory | 4,774.12 MB |
| CPU utilization, p99 | 53.0% |
| Peak core temperature | Not reported by host sensors (`null`) |
| Profiler throttling flag | `false` |

The host reported an AMD EPYC-Genoa processor, 7.6 GiB RAM, no GPU and Ubuntu 26.04 LTS. The profiler identified the GGUF as `qwen3`, verified the 4B parameter claim, and recorded a declared context length of 262,144 tokens. The ARC-Easy result is a 50-sample participant self-check; it is not the hidden judging score. Separate held-out model-selection evidence is reported above.

These development measurements are provided for reproducibility and are not a claim about every target laptop. The evaluator downloads the public GGUF and runs its own offline profiler.

## Offline operation and release

download_model.sh retrieves the public GGUF over HTTPS, verifies SHA-256, and stores it at the exact path in metadata.json. Once downloaded, inference uses only the local file and llama.cpp. The model artifact checksum is:

    5ea2b969bd067f96fc9a26cdd4ed749e3a4f23b4838fcd6293be243301af6b76

The model is distributed under the upstream Qwen Apache-2.0 terms with KaroGuard metadata/chat-template modifications documented in MODEL_LICENSE.
