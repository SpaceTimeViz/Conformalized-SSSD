#
# Please check envs/dockers/Dockerfile.local for the original version
#
FROM egpivo/imputer:latest AS builder

LABEL authors="Joseph Wang <egpivo@gmail.com>" \
      version="0.0.9"

# Set the working directory in the container
WORKDIR /imputer

# Copy only necessary project files and Conda environment setup
COPY scripts/ scripts/
COPY envs/conda envs/conda/
COPY bin bin/
COPY imputer imputer/
COPY pyproject.toml pyproject.toml
COPY README.md README.md

# Build Conda environment and cleanup unnecessary files
RUN bash envs/conda/build_conda_env.sh && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Stage 2: Final production image
FROM continuumio/miniconda3:latest

# Set the working directory in the container
WORKDIR /imputer

# Copy the Conda environment directory from the build stage to the appropriate location
COPY --from=builder /opt/conda/envs/imputer/ /opt/conda/envs/imputer/

# Set up Conda environment
ENV PATH /opt/conda/envs/imputer/bin:$PATH
RUN echo "conda activate imputer" >> ~/.bashrc

# Copy necessary files from the build stage
COPY --from=builder /imputer/bin bin/
COPY --from=builder /imputer/scripts scripts/

# Set the entrypoint
ENTRYPOINT ["/bin/bash", "-c", "/bin/bash scripts/diffusion_process.sh --model_config configs/$MODEL_CONFIG --training_config configs/$TRAINING_CONFIG --inference_config configs/$INFERENCE_CONFIG"]
