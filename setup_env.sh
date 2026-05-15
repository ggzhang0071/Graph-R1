#!/bin/bash
# Setup script for Graph-R1 inside Docker container
# Run this after entering the container: bash setup_env.sh

set -e

echo "=== Graph-R1 Environment Setup ==="
cd /git/Graph-R1

# 1. Check GPU compatibility
echo "Checking GPU..."
python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA: {torch.version.cuda}'); print(f'GPU: {torch.cuda.get_device_name(0)}'); print(f'Capability: {torch.cuda.get_device_capability(0)}')"

# 2. Install core dependencies (skip flash-attn first to avoid build isolation issues)
echo "Installing Python dependencies (this may take a few minutes)..."
pip install --no-cache-dir -e .

# Install requirements except flash-attn
grep -v "^flash-attn" requirements.txt > /tmp/requirements_no_flash.txt
pip install --no-cache-dir -r /tmp/requirements_no_flash.txt

# 3. Install flash-attn with no build isolation (requires torch to be visible during build)
echo "Installing flash-attn (compilation required, this takes 10-30 minutes)..."
pip install --no-cache-dir flash-attn --no-build-isolation

# 4. Verify imports
echo "Verifying imports..."
python -c "
import torch
import transformers
import vllm
import ray
import graphr1
print('All core imports successful!')
print(f'PyTorch: {torch.__version__}, CUDA available: {torch.cuda.is_available()}')
"

# 5. Check dataset directory
echo ""
echo "=== Dataset Check ==="
if [ -d "/git/datasets/2WikiMultiHopQA" ]; then
  echo "Dataset found. You can now preprocess:"
  echo "  python script_process.py --data_source 2WikiMultiHopQA"
else
  echo "WARNING: Dataset directory not found at /git/datasets/"
  echo "Please download datasets from the TeraBox link in README.md"
  echo "and place them in /git/datasets/ on the host machine."
fi

echo ""
echo "=== Setup Complete ==="
