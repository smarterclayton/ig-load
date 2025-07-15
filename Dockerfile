FROM golang:1.24
ENV KUBERNETES_VERSION=1.33
RUN \
    apt-get update && \
    apt-get -qy install lsof net-tools htop vim dnsutils apt-transport-https ca-certificates curl gnupg python3-pip && \
    # install kubectl
    mkdir -p -m 755 /etc/apt/keyrings && \
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/ /" > /etc/apt/sources.list.d/kubernetes.list && \
    chmod 644 /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get -qy install kubectl && \
    # cleanup
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
RUN \
    go install github.com/tsenart/vegeta/v12@03ca49e9b419c106db29d687827c4c823d8b8ece && \
    which vegeta && \
    go clean -cache -modcache
RUN \
    mkdir -p /opt/inference-perf && \
    git clone https://kubernetes-sigs/inference-perf.git /opt/inference-perf && \
    cd /opt/inference-perf && \
    pip install . --break-system-packages
COPY config/home/* /root/
COPY . /ig-load/
WORKDIR /ig-load
