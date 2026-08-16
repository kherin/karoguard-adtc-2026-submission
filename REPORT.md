# Technical Report — KaroGuard

## Problem

Smallholder farmers in Mauritius and cyclone-exposed African and Indian Ocean communities often need actionable crop-protection guidance when connectivity, power and access to specialists are unreliable. KaroGuard is an offline assistant for preparation, post-cyclone observation and cautious recovery planning. It keeps emergency safety, official instructions and uncertainty ahead of crop or equipment protection.

## Design decisions

KaroGuard uses Qwen/Qwen3-4B-Instruct-2507 at the pinned revision cdbee75f17c01a7cc42f958dc650907174af0554. The final artifact is a 4B-parameter GGUF Q4_K_M model converted with llama.cpp b10424. Q4_K_M was selected as the best quality-preserving compact artifact after comparing Q4_K_S, Q4_K_M, Q5_K_M, Qwen3-1.7B, Ministral-3-3B, and several QLoRA candidates. The stronger adapters reduced domain accuracy, so the released artifact preserves the base tensors and applies a safety-oriented chat-template policy.

The private data pipeline used 150 reviewed knowledge units and 900 supervised examples in 300 leakage-isolated families. Gemini created candidate examples only; deterministic validation and builder review controlled admission. The final evaluation set was held out from training.

## African use case and constraints

The model is designed for Mauritius and transferable tropical cyclone contexts in Rodrigues, Madagascar, Comoros, Seychelles and Mozambique. It assumes limited connectivity, modest CPU hardware, local data privacy and no external retrieval service during inference. English is the only validated language currently declared.

KaroGuard must not encourage entry into floodwater, contact with fallen power lines, unsafe field access, or delaying evacuation. It directs users to current authorities, emergency services, utility operators and qualified agricultural specialists when information is missing or conditions are dangerous.

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

## Development benchmark

The released GGUF was exercised on the development VPS using llama.cpp b10424, one CPU thread and a 1 vCPU Ubuntu environment. The service reported approximately 2.3 GiB peak resident memory during development requests. Cloud candidate comparison recorded approximately 5.97 generation tokens/second for the untuned Q4_K_M baseline. Time-to-first-token and thermal sensor telemetry were not available from this development host.

### Official ADTC profiler smoke test

The official `adtc-profiler` 0.1.0 was installed from commit `ac2e137dca65ea3b09d997774f17dd8907b489fb` and run in participant mode using the Local Testing command from the submission template:

    adtc-profiler run --submission . --mode participant --output submission.json --skip-accuracy

The clean run used `llama-bench` from llama.cpp b10424 with CPU-only inference. The host reported an AMD EPYC-Genoa processor, 3.7 GB RAM, no GPU and Ubuntu 26.04 LTS. The profiler produced the following schema-valid measurements:

| Profiler metric | Result |
| --- | ---: |
| Generation throughput | 13.15 tokens/second |
| First-token latency | 19,413.30 ms |
| Peak resident memory | 2,542.93 MB |
| Steady-state resident memory | 2,415.93 MB |
| Peak virtual memory | 4,756.99 MB |
| CPU utilization, p99 | 97.0% |
| Peak core temperature | Not reported by host sensors (`null`) |
| Profiler throttling flag | `false` |

The profiler identified the GGUF as a `qwen3` model with 4,022,468,096 parameters, a 262,144-token declared context length and a parameter-count match against the 4B claim. The generated report uses schema version 1.1.0, records `measured_on` as `participant_laptop`, seed 42 and profiled repository commit `6bfede4925bd`. Per the template smoke-test command, the accuracy stage was not run and the report therefore contains `"accuracy": []`; the separate held-out quality evidence is reported above.

These development measurements are provided for reproducibility and are not a claim about every target laptop. The evaluator downloads the public GGUF and runs its own offline profiler.

## Offline operation and release

download_model.sh retrieves the public GGUF over HTTPS, verifies SHA-256, and stores it at the exact path in metadata.json. Once downloaded, inference uses only the local file and llama.cpp. The model artifact checksum is:

    5ea2b969bd067f96fc9a26cdd4ed749e3a4f23b4838fcd6293be243301af6b76

The model is distributed under the upstream Qwen Apache-2.0 terms with KaroGuard metadata/chat-template modifications documented in MODEL_LICENSE.
