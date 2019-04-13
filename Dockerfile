# Start with a build stage that will create the 'scratchgo' binary.
FROM golang:alpine AS builder

# We use the new go module support, so build stuff in a clean directory
# outside GOPATH.
WORKDIR /build

# Add code to the build directory.
COPY . .

# Create the 'scratchgo' binary. The netgo tag is needed to create a
# statically linked binary when using the net/http package, see:
# https://groups.google.com/forum/#!topic/golang-nuts/Rw89bnhPBUI
RUN go build -tags=netgo

# Create a new stage, this is the container we will actually run.
FROM scratch

# Copy the static executable from the builder stage.
COPY --from=builder /build/scratchgo /

# Make port 8080 available outside this container.
EXPOSE 8080

# Start the service.
ENTRYPOINT ["/scratchgo"]
