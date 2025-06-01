FROM debian:bookworm-slim AS build

RUN apt-get update &&  apt-get install -y nfs-common openssh-server samba 


# Cleanup
RUN apt-get autoremove -y; apt-get clean -y
RUN rm -rf /var/cache/apt/archives /var/lib/apt/lists

FROM scratch
COPY --from=build / /