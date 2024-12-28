FROM ubuntu:noble

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# 安裝基本依賴包並清理無用的檔案
RUN apt-get update && \
    apt-get upgrade --yes --no-install-recommends --no-install-suggests && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 安裝基礎工具與 Podman 相關依賴
RUN apt-get update && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
    bash \
    build-essential \
    curl \
    htop \
    jq \
    locales \
    man \
    pipx \
    python3 \
    python3-pip \
    software-properties-common \
    sudo \
    systemd \
    systemd-sysv \
    unzip \
    vim \
    wget \
    podman \
    rsync && \
# 使用官方的 Git PPA 安裝最新版本的 Git
    add-apt-repository ppa:git-core/ppa && \
    apt-get install --yes git && \
    rm -rf /var/lib/apt/lists/*

# 生成需要的語系 (en_US.UTF-8)
RUN locale-gen en_US.UTF-8

# 設定語系環境變數以支持 Unicode 字符
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# 刪除預設的 ubuntu 使用者並新增 coder 使用者
RUN userdel -r ubuntu && \
    useradd coder \
    --create-home \
    --shell=/bin/bash \
    --uid=1000 \
    --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# 使用 coder 用戶來運行後續命令
USER coder

# 執行 pipx 初始化，確保二進制路徑添加到 PATH
RUN pipx ensurepath
