FROM node:20

ARG TZ
ENV TZ="$TZ"

ARG CLAUDE_CODE_VERSION=latest

# Install basic development tools and iptables/ipset
# Note: node:20 already includes curl, wget, git, build-essential, and many dev libraries via buildpack-deps
RUN apt-get update && apt-get install -y --no-install-recommends \
  less \
  sudo \
  fzf \
  zsh \
  man-db \
  gh \
  iptables \
  ipset \
  iproute2 \
  dnsutils \
  aggregate \
  jq \
  nano \
  vim \
  tk-dev \
  libxmlsec1-dev \
  locales \
  direnv \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install markdownlint-cli2
RUN npm install -g markdownlint-cli2

# Set up locale to fix warnings
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
  chown -R node:node /usr/local/share

ARG USERNAME=node

# Persist bash history.
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  && mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R $USERNAME /commandhistory

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

# Create workspace and config directories and set permissions
RUN mkdir -p /workspace /home/node/.claude && \
  chown -R node:node /workspace /home/node/.claude

WORKDIR /workspace

ARG GIT_DELTA_VERSION=0.18.2
RUN ARCH=$(dpkg --print-architecture) && \
  wget "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  sudo dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

USER node

# Install global packages
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# Set the default shell to zsh rather than sh
ENV SHELL=/bin/zsh

# Set the default editor and visual
ENV EDITOR nano
ENV VISUAL nano

# Default powerline10k theme
ARG ZSH_IN_DOCKER_VERSION=1.2.0
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v${ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
  -p git \
  -p fzf \
  -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
  -a "source /usr/share/doc/fzf/examples/completion.zsh" \
  -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  -x

# Install asdf-vm
ENV ASDF_DIR="/home/node/.asdf"
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1 && \
  echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc && \
  echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.zshrc && \
  echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc && \
  echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc

# Install asdf plugins
RUN bash -c '. "$HOME/.asdf/asdf.sh" && \
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && \
  asdf plugin add python https://github.com/asdf-community/asdf-python.git && \
  asdf plugin add task https://github.com/particledecay/asdf-task.git && \
  asdf plugin add uv https://github.com/asdf-community/asdf-uv.git && \
  asdf plugin add bun https://github.com/cometkim/asdf-bun.git && \
  asdf plugin add cocoapods https://github.com/ronnnnn/asdf-cocoapods.git && \
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git && \
  asdf plugin add bundler https://github.com/jonathanmorley/asdf-bundler.git && \
  asdf plugin add terraform https://github.com/asdf-community/asdf-hashicorp.git && \
  asdf plugin add lychee https://github.com/robertbagge/asdf-lychee.git'

# Copy .tool-versions and install all tools
COPY --chown=node:node .tool-versions /home/node/.tool-versions
WORKDIR /home/node
RUN bash -c '. "$HOME/.asdf/asdf.sh" && asdf install'

# Configure direnv shell integration
RUN echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc && \
  echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

WORKDIR /workspace

# Install Claude
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}


# Copy and set up firewall script
COPY init-firewall.sh /usr/local/bin/
USER root

# (as root layer)
RUN bash -lc 'printf "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh\n" > /etc/sudoers.d/node-firewall-robust && chmod 0440 /etc/sudoers.d/node-firewall-robust'

USER node

# Set up .venv volume that is owned by node user
USER root
RUN mkdir -p /workspace/.venv && chown node:node /workspace/.venv
VOLUME ["/workspace/.venv"]
USER node
