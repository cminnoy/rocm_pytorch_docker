FROM rocm/pytorch:rocm7.1.1_ubuntu24.04_py3.12_pytorch_release_2.9.1

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install system dependencies
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
     gosu \
     sudo \
     htop \
     vim \
     ca-certificates \
     build-essential \
     wget \
     tree \
     git \
     cmake \
&& rm -rf /var/lib/apt/lists/*

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Fix GIDs (video=44, kvm=992, etc.)
RUN groupmod -g 44 video \
&& if getent group 992 >/dev/null 2>&1; then \
     groupmod -g 9999 "$(getent group 992 | cut -d: -f1)"; \
   fi \
&& if getent group kvm >/dev/null 2>&1; then \
     groupmod -g 992 kvm || true; \
   fi

RUN /opt/venv/bin/pip install numba numpy Pillow diskcache scikit-learn kornia
RUN /opt/venv/bin/pip install onnx onnxscript onnxsim onnxruntime
RUN /opt/venv/bin/pip install tensorboard torchsummary torchviz torchprofile
RUN /opt/venv/bin/pip install flatbuffers humanfriendly coloredlogs
RUN /opt/venv/bin/pip install qdrant-client
RUN /opt/venv/bin/pip install transformers sentence-transformers --no-deps
RUN /opt/venv/bin/pip install pymupdf tokenizers huggingface-hub safetensors requests regex tqdm
ENV OMP_NUM_THREADS 4
ENV TORCH_HOME /workspaces/.cache
CMD ["tail", "-f", "/dev/null"]
