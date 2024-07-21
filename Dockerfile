# Stage 1: Build stage
FROM egpivo/sssd:latest AS builder

LABEL authors="Joseph Wang <egpivo@gmail.com>"\
      version="0.0.1"

# Set the working directory in the container
WORKDIR /sssd_cp

# Copy only necessary project files and Conda environment setup
COPY scripts/ scripts/
COPY envs/ envs/
COPY bin bin/
COPY notebooks notebooks/
COPY sssd_cp sssd_cp/
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
WORKDIR /sssd

# Copy the Conda environment directory from the build stage to the appropriate location
COPY --from=builder /opt/conda/envs/sssd-cp/ /opt/conda/envs/sssd-cp/

# Set up Conda environment
ENV PATH /opt/conda/envs/sssd-cp/bin:$PATH
RUN echo "conda activate sssd-cp" >> ~/.bashrc

# Copy necessary files from the build stage
COPY --from=builder /sssd_cp/bin bin/
COPY --from=builder /sssd_cp/scripts scripts/
COPY --from=builder /sssd_cp/envs envs/
COPY --from=builder /sssd_cp/notebooks notebooks/
COPY --from=builder /sssd_cp/sssd_cp sssd_cp/
COPY --from=builder /sssd_cp/pyproject.toml pyproject.toml

ENTRYPOINT ["/bin/bash", "-c", "/bin/bash scripts/docker/$ENTRYPOINT_SCRIPT"]
