FROM golang:alpine AS build
ARG CI_GITLAB_MODULES_REG_USERNAME
ARG CI_GITLAB_MODULES_REG_TOKEN
ARG APP_NAME=${APP_NAME}

ENV GOPRIVATE gitlab.com/bango

COPY ./ /src
WORKDIR /src
RUN apk update && apk add --no-cache git ca-certificates build-base

# Create a non-root user (in the build stage)
RUN adduser -D -g '' appuser

# Start from scratch for the runtime stage
FROM scratch AS runtime

# Copy the built binary and other necessary files
COPY --from=build /main /
COPY --from=build /src/config/*.yaml /config/
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy the non-root user from the build stage
COPY --from=build /etc/passwd /etc/passwd

# Use the non-root user to run the application
USER appuser

EXPOSE 8080
CMD ["/main"]