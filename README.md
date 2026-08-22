# KaroGuard — Offline Cyclone-Resilience Assistant

KaroGuard is a compact agricultural decision-support model for smallholder farmers in Mauritius and other cyclone-exposed African and Indian Ocean communities.

It runs locally through llama.cpp after the model is downloaded. It helps organize pre-cyclone preparation, post-cyclone observations and recovery actions while keeping human safety ahead of crops, equipment and access.

## Quick start

    bash download_model.sh
    llama-cli -m model/KaroGuard-Q4_K_M.gguf -p "A cyclone warning is active. What should a tomato farmer do first?"

The model download is credential-free and the model does not require network access during inference.

The hosted model artifact is available from the public [KaroGuard Hugging Face repository](https://huggingface.co/kherin/karoguard-adtc-2026-gguf). The included `download_model.sh` script downloads that exact artifact and verifies its SHA-256 checksum before use.

## Model

- Base: Qwen/Qwen3-4B-Instruct-2507
- Runtime: llama.cpp
- Quantization: GGUF Q4_K_M
- Artifact SHA-256: 5ea2b969bd067f96fc9a26cdd4ed749e3a4f23b4838fcd6293be243301af6b76

## Submission validation

From a fresh public clone, run the exact ADTC participant smoke test:

    bash download_model.sh
    adtc-profiler run --submission . --mode participant --output submission.json --skip-accuracy

The committed `submission.json` was regenerated from a clean clone with `adtc-profiler 0.1.0`. It reports `environment.measured_on` as `participant_laptop`, confirms the claimed 4B parameter count, and records no thermal throttling. The model download requires no credentials; after the download, profiling and inference use the local GGUF without network access.

## Safety

KaroGuard is informational decision support. Follow current official warnings and local authorities. Do not enter floodwater, approach fallen electrical lines, or delay evacuation to protect crops.

The model does not issue weather warnings, predict cyclone tracks, diagnose from images, prescribe regulated chemicals, or replace emergency services or qualified agronomists.

## License

Repository documentation follows the official submission-template license. The model artifact is based on Qwen3 and is distributed under Apache-2.0; see MODEL_LICENSE.
