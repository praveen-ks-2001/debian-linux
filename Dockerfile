  FROM debian:bookworm-slim                   
                                                                                         
  ENV DEBIAN_FRONTEND=noninteractive                                                     
                                                                                         
  RUN apt-get update && \
      apt-get install -y --no-install-recommends \                                       
          tini wget curl git python3 python3-pip fastfetch ca-certificates && \
      apt-get clean && rm -rf /var/lib/apt/lists/*

  RUN wget -qO /usr/local/bin/ttyd
  https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 && \
      chmod +x /usr/local/bin/ttyd

  RUN echo "fastfetch" >> /root/.bashrc && \
      echo "cd /root" >> /root/.bashrc

  EXPOSE $PORT

  ENTRYPOINT ["tini", "--"]
  CMD ["/bin/bash", "-c", "\
      echo \"export PS1='\\[\\033[01;31m\\]$USERNAME@debian\\[\\033[00m\\]:\\[\\033[01;34
  m\\]\\w\\[\\033[00m\\]\\$ '\" >> /root/.bashrc && \
      /usr/local/bin/ttyd -p $PORT -c $USERNAME:$PASSWORD /bin/bash"]
