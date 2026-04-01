# Stage 1: Build Flutter web app
FROM debian:bookworm-slim AS build

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"
ENV TAR_OPTIONS=--no-same-owner

RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git --depth 1 -b stable ${FLUTTER_HOME}

WORKDIR /app
COPY . .

RUN flutter config --enable-web
RUN flutter precache --web
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve with nginx
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 10000

CMD ["sh", "-c", "sed -i 's/LISTEN_PORT/'\"${PORT:-10000}\"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]