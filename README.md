# KaroGuard — Offline Cyclone-Resilience Assistant

KaroGuard is a compact agricultural decision-support model for smallholder farmers in Mauritius and other cyclone-exposed African and Indian Ocean communities.

It runs locally through llama.cpp after the model is downloaded. It helps organize pre-cyclone preparation, post-cyclone observations and recovery actions while keeping human safety ahead of crops, equipment and access.

## Quick start

    bash download_model.sh
    llama-cli -m model/KaroGuard-Q4_K_M.gguf -p "A cyclone warning is active. What should a tomato farmer do first?"

The model download is credential-free and the model does not require network access during inference.

## Model

- Base: Qwen/Qwen3-4B-Instruct-2507
- Runtime: llama.cpp
- Quantization: GGUF Q4_K_M
- Artifact SHA-256: 5ea2b969bd067f96fc9a26cdd4ed749e3a4f23b4838fcd6293be243301af6b76

## Safety

KaroGuard is informational decision support. Follow current official warnings and local authorities. Do not enter floodwater, approach fallen electrical lines, or delay evacuation to protect crops.

The model does not issue weather warnings, predict cyclone tracks, diagnose from images, prescribe regulated chemicals, or replace emergency services or qualified agronomists.

## License

Repository documentation follows the official submission-template license. The model artifact is based on Qwen3 and is distributed under Apache-2.0; see MODEL_LICENSE.
