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

RUN /opt/venv/bin/pip install numba numpy Pillow diskcache scikit-learn kornia onnx onnxscript tensorboard torchsummary torchviz torchprofile

CMD ["tail", "-f", "/dev/null"]
